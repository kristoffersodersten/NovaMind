import Combine
import CryptoKit
import Foundation

// MARK: - Enhanced Memory Architecture

/// Enhanced Memory Architecture with ChromaDB integration, vector embeddings, and federation support
class EnhancedMemoryArchitecture: ObservableObject {
    static let shared = EnhancedMemoryArchitecture()

    // MARK: - Core Components

    @Published private(set) var memoryManager: AdvancedMemoryManager
    @Published private(set) var vectorEngine: VectorEmbeddingEngine
    @Published private(set) var federationLayer: MemoryFederationLayer
    @Published private(set) var semanticSearch: SemanticSearchEngine
    @Published private(set) var persistenceLayer: EncryptedPersistenceLayer

    // MARK: - Operations and Monitoring

    private let operations: EnhancedMemoryOperations
    private let monitoring: EnhancedMemoryMonitoring
    private let config: EnhancedMemoryConfig
    private let encryptionKey: SymmetricKey

    init() {
        // Initialize encryption and configuration
        self.encryptionKey = SymmetricKey(size: .bits256)
        self.config = EnhancedMemoryConfig.loadFromYAML()

        // Initialize components
        self.memoryManager = AdvancedMemoryManager(config: config, encryptionKey: encryptionKey)
        self.vectorEngine = VectorEmbeddingEngine(config: config.vectorConfig)
        self.federationLayer = MemoryFederationLayer(config: config.federationConfig)
        self.semanticSearch = SemanticSearchEngine(vectorEngine: vectorEngine)
        self.persistenceLayer = EncryptedPersistenceLayer(encryptionKey: encryptionKey)

        // Initialize operations and monitoring
        self.operations = EnhancedMemoryOperations(
            memoryManager: memoryManager,
            vectorEngine: vectorEngine,
            federationLayer: federationLayer,
            semanticSearch: semanticSearch,
            persistenceLayer: persistenceLayer,
            config: config
        )

        self.monitoring = EnhancedMemoryMonitoring(
            memoryManager: memoryManager,
            vectorEngine: vectorEngine,
            federationLayer: federationLayer,
            semanticSearch: semanticSearch,
            persistenceLayer: persistenceLayer
        )
    }

    // MARK: - Public API

    /// Store memory with vector embeddings and semantic indexing
    func storeEnhancedMemory<T: EnhancedMemoryContent>(
        _ content: T,
        context: EnhancedMemoryContext,
        embeddings: [Double]? = nil
    ) async throws -> MemoryStoreResult {
        let result = try await operations.storeEnhancedMemory(content, context: context, embeddings: embeddings)
        await monitoring.updateMetrics(operation: .store, result: result)
        return result
    }

    /// Enhanced semantic search across all memory layers
    func semanticSearch<T: EnhancedMemoryContent>(
        _ type: T.Type,
        query: String,
        layers: [MemoryLayer] = [.all],
        filters: SearchFilters? = nil,
        limit: Int = 20
    ) async throws -> [EnhancedMemoryResult<T>] {
        let results = try await operations.performSemanticSearch(
            type,
            query: query,
            layers: layers,
            filters: filters,
            limit: limit
        )
        await monitoring.updateMetrics(operation: .search, resultCount: results.count)
        return results
    }

    /// Store entity-bound memory
    func storeEntityMemory<T: EnhancedMemoryContent>(
        _ content: T,
        agentId: String,
        emotionalContext: EmotionalContext? = nil,
        priority: MemoryPriority = .normal
    ) async throws -> MemoryStoreResult {
        return try await operations.storeEntityMemory(
            content,
            agentId: agentId,
            emotionalContext: emotionalContext,
            priority: priority
        )
    }

    /// Store collective memory
    func storeCollectiveMemory<T: EnhancedMemoryContent>(
        _ content: T,
        resolution: ConflictResolution?,
        consensus: ConsensusLevel,
        mentorValidation: MentorValidation?
    ) async throws -> MemoryStoreResult {
        return try await operations.storeCollectiveMemory(
            content,
            resolution: resolution,
            consensus: consensus,
            mentorValidation: mentorValidation
        )
    }

    // MARK: - Health and Monitoring

    var enhancedHealth: EnhancedMemoryHealth {
        monitoring.enhancedHealth
    }

    var performanceMetrics: MemoryPerformanceMetrics {
        monitoring.performanceMetrics
    }
}
