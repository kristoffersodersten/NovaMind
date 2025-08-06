import Foundation
import Combine
import CryptoKit

// MARK: - Enhanced Memory Operations Manager

/// Handles the core memory operations for the Enhanced Memory Architecture
class EnhancedMemoryOperations {
    private let memoryManager: AdvancedMemoryManager
    private let vectorEngine: VectorEmbeddingEngine
    private let federationLayer: MemoryFederationLayer
    private let semanticSearch: SemanticSearchEngine
    private let persistenceLayer: EncryptedPersistenceLayer
    private let config: EnhancedMemoryConfig

    init(
        memoryManager: AdvancedMemoryManager,
        vectorEngine: VectorEmbeddingEngine,
        federationLayer: MemoryFederationLayer,
        semanticSearch: SemanticSearchEngine,
        persistenceLayer: EncryptedPersistenceLayer,
        config: EnhancedMemoryConfig
    ) {
        self.memoryManager = memoryManager
        self.vectorEngine = vectorEngine
        self.federationLayer = federationLayer
        self.semanticSearch = semanticSearch
        self.persistenceLayer = persistenceLayer
        self.config = config
    }

    /// Store memory with vector embeddings and semantic indexing
    func storeEnhancedMemory<T: EnhancedMemoryContent>(
        _ content: T,
        context: EnhancedMemoryContext,
        embeddings: [Double]? = nil
    ) async throws -> MemoryStoreResult {
        // Generate or use provided embeddings
        let vectorEmbeddings = embeddings ?? try await vectorEngine.generateEmbeddings(
            for: content.searchableText,
            model: config.vectorConfig.embeddingModel
        )

        // Create enhanced memory item
        let memoryItem = EnhancedMemoryItem(
            id: UUID().uuidString,
            content: content,
            embeddings: vectorEmbeddings,
            context: context,
            timestamp: Date(),
            metadata: content.enhancedMetadata
        )

        // Encrypt content
        let encryptedItem = try await persistenceLayer.encrypt(memoryItem)

        // Store in appropriate layer
        let storeResult = try await memoryManager.store(
            encryptedItem,
            layer: context.targetLayer,
            federationPolicy: context.federationPolicy
        )

        // Index for semantic search
        try await semanticSearch.index(
            item: memoryItem,
            layer: context.targetLayer
        )

        // Federate if required
        if context.federationPolicy.enabled {
            try await federationLayer.broadcast(
                item: encryptedItem,
                nodes: context.federationPolicy.targetNodes
            )
        }

        return storeResult
    }

    /// Enhanced semantic search across all memory layers
    func performSemanticSearch<T: EnhancedMemoryContent>(
        _ type: T.Type,
        query: String,
        layers: [MemoryLayer] = [.all],
        filters: SearchFilters? = nil,
        limit: Int = 20
    ) async throws -> [EnhancedMemoryResult<T>] {
        // Generate query embeddings
        let queryEmbeddings = try await vectorEngine.generateEmbeddings(
            for: query,
            model: config.vectorConfig.embeddingModel
        )

        // Perform semantic search
        let searchResults = try await semanticSearch.search(
            embeddings: queryEmbeddings,
            type: type,
            layers: layers,
            filters: filters,
            limit: limit
        )

        // Decrypt and decode results efficiently with parallel processing
        let enhancedResults: [EnhancedMemoryResult<T>] = await withTaskGroup(
            of: EnhancedMemoryResult<T>?.self,
            returning: [EnhancedMemoryResult<T>].self
        ) { group in
            for result in searchResults {
                group.addTask { [weak self] in
                    guard let self = self else { return nil }

                    do {
                        let decryptedItem = try await self.persistenceLayer.decrypt(result.encryptedItem)

                        if let content = decryptedItem.content as? T {
                            return EnhancedMemoryResult(
                                content: content,
                                similarity: result.similarity,
                                confidence: result.confidence,
                                timestamp: decryptedItem.timestamp,
                                source: result.source,
                                context: decryptedItem.context,
                                embeddings: decryptedItem.embeddings
                            )
                        }
                    } catch {
                        // Log error and continue
                        print("Failed to decrypt memory item: \(error)")
                    }
                    return nil
                }
            }

            var results: [EnhancedMemoryResult<T>] = []
            for await result in group {
                if let result = result {
                    results.append(result)
                }
            }
            return results
        }

        return enhancedResults.sorted { $0.similarity > $1.similarity }
    }

    /// Store entity-bound memory with enhanced metadata
    func storeEntityMemory<T: EnhancedMemoryContent>(
        _ content: T,
        agentId: String,
        emotionalContext: EmotionalContext? = nil,
        priority: MemoryPriority = .normal
    ) async throws -> MemoryStoreResult {
        let context = EnhancedMemoryContext(
            scope: .entity(agentId),
            targetLayer: .entityBound,
            priority: priority,
            emotionalContext: emotionalContext,
            federationPolicy: FederationPolicy.agentSpecific
        )

        return try await storeEnhancedMemory(content, context: context)
    }

    /// Store collective memory with resolution validation
    func storeCollectiveMemory<T: EnhancedMemoryContent>(
        _ content: T,
        resolution: ConflictResolution?,
        consensus: ConsensusLevel,
        mentorValidation: MentorValidation?
    ) async throws -> MemoryStoreResult {
        // Validate consensus requirement
        guard consensus.value >= config.collectiveConfig.consensusThreshold else {
            throw EnhancedMemoryError.insufficientConsensus(
                required: config.collectiveConfig.consensusThreshold,
                actual: consensus.value
            )
        }

        let context = EnhancedMemoryContext(
            scope: .collective(consensus.participants),
            targetLayer: .collective,
            priority: .critical,
            resolution: resolution,
            consensus: consensus,
            mentorValidation: mentorValidation,
            federationPolicy: FederationPolicy.bilateral
        )

        return try await storeEnhancedMemory(content, context: context)
    }
}
