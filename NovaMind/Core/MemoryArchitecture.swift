import Combine
import CryptoKit
import Foundation


// MARK: - Memory Architecture System

/// Comprehensive memory architecture for NovaMind multi-agent system
/// Implements four-tier memory: short-term, entity-bound, relation, and collective
class MemoryArchitecture: ObservableObject {
    static let shared = MemoryArchitecture()

    // MARK: - Memory Layers

    @Published private(set) var shortTermMemory: ShortTermMemory
    @Published private(set) var entityBoundMemory: EntityBoundMemory
    @Published private(set) var relationMemory: RelationMemory
    @Published private(set) var collectiveMemory: CollectiveMemory

    // MARK: - Configuration

    private let baseVectorPath = "/Vectors"
    private let encryptionKey: SymmetricKey
    private let memoryConfig: MemoryConfiguration

    // MARK: - Publishers

    @Published var memoryHealth: MemoryHealth
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Initialize encryption key
        self.encryptionKey = SymmetricKey(size: .bits256)

        // Load configuration
        self.memoryConfig = MemoryConfiguration.load()

        // Initialize memory layers
        self.shortTermMemory = ShortTermMemory()
        self.entityBoundMemory = EntityBoundMemory(
            vectorPath: "\(baseVectorPath)/agents",
            encryptionKey: encryptionKey
        )
        self.relationMemory = RelationMemory(
            vectorPath: "\(baseVectorPath)/relations",
            encryptionKey: encryptionKey
        )
        self.collectiveMemory = CollectiveMemory(
            vectorPath: "\(baseVectorPath)/collective",
            encryptionKey: encryptionKey
        )

        // Initialize health monitoring
        self.memoryHealth = MemoryHealth()

        setupHealthMonitoring()
    }

    deinit {
        syncTimer?.invalidate()
        cancellables.removeAll()
    }

    // MARK: - Memory Operations

    /// Store memory in the appropriate layer based on content type and scope
    func store<T: MemoryContent>(_ content: T, for context: MemoryContext) async throws {
        switch context.scope {
        case .shortTerm:
            await shortTermMemory.store(content, context: context)

        case .entityBound(let agentId):
            try await entityBoundMemory.store(content, agentId: agentId, context: context)

        case .relation(let agentA, let agentB):
            try await relationMemory.store(content, agentA: agentA, agentB: agentB, context: context)

        case .collective:
            try await collectiveMemory.store(content, context: context)
        }

        await updateMemoryHealth()
    }

    /// Retrieve memory from appropriate layer with semantic search
    func retrieve<T: MemoryContent>(
        _ type: T.Type,
        query: String,
        from context: MemoryContext,
        limit: Int = 10
    ) async throws -> [MemoryResult<T>] {
        switch context.scope {
        case .shortTerm:
            return await shortTermMemory.retrieve(type, query: query, limit: limit)

        case .entityBound(let agentId):
            return try await entityBoundMemory.retrieve(type, query: query, agentId: agentId, limit: limit)

        case .relation(let agentA, let agentB):
            return try await relationMemory.retrieve(type, query: query, agentA: agentA, agentB: agentB, limit: limit)

        case .collective:
            return try await collectiveMemory.retrieve(type, query: query, limit: limit)
        }
    }

    /// Clear memory based on reset conditions
    func clearMemory(for scope: MemoryScope, condition: ResetCondition) async {
        switch scope {
        case .shortTerm:
            if condition == .contextSwitch {
                await shortTermMemory.clear()
            }

        case .entityBound(let agentId):
            if condition == .agentReset {
                try? await entityBoundMemory.clearAgent(agentId)
            }

        case .relation(let agentA, let agentB):
            if condition == .mutualAgreement {
                try? await relationMemory.clearRelation(agentA: agentA, agentB: agentB)
            }

        case .collective:
            // Collective memory is immutable by design
            break
        }

        await updateMemoryHealth()
    }

    /// Synchronize collective memory across federation nodes
    func synchronizeCollectiveMemory() async throws {
        try await collectiveMemory.synchronize()
        await updateMemoryHealth()
    }

    // MARK: - Health Monitoring

    private func setupHealthMonitoring() {
        Timer.publish(every: 300, on: .main, in: .common) // Every 5 minutes
            .autoconnect()
            .sink { _ in
                Task {
                    await self.updateMemoryHealth()
                }
            }
            .store(in: &cancellables)
    }

    private func updateMemoryHealth() async {
        let shortTermHealth = await shortTermMemory.getHealth()
        let entityHealth = await entityBoundMemory.getHealth()
        let relationHealth = await relationMemory.getHealth()
        let collectiveHealth = await collectiveMemory.getHealth()

        await MainActor.run {
            self.memoryHealth = MemoryHealth(
                shortTerm: shortTermHealth,
                entityBound: entityHealth,
                relation: relationHealth,
                collective: collectiveHealth,
                lastUpdate: Date()
            )
        }
    }
}

// MARK: - Short Term Memory

/// In-memory storage bound to agent instance, resets on context switch
class ShortTermMemory: ObservableObject {
    private var storage: [String: Any] = [:]
    private var accessTimes: [String: Date] = [:]
    private let maxSize = 1000
    private let queue = DispatchQueue(label: "shortterm.memory", qos: .userInitiated)

    func store<T: MemoryContent>(_ content: T, context: MemoryContext) async {
        await withCheckedContinuation { continuation in
            queue.async {
                let key = self.generateKey(for: content, context: context)
                self.storage[key] = content
                self.accessTimes[key] = Date()

                // Evict old entries if needed
                self.evictIfNeeded()

                continuation.resume()
            }
        }
    }

    func retrieve<T: MemoryContent>(_ type: T.Type, query: String, limit: Int) async -> [MemoryResult<T>] {
        await withCheckedContinuation { continuation in
            queue.async {
                let results = self.storage.compactMap { (key, value) -> MemoryResult<T>? in
                    guard let content = value as? T else { return nil }

                    let similarity = self.calculateSimilarity(query: query, content: content)
                    guard similarity > 0.3 else { return nil }

                    self.accessTimes[key] = Date() // Update access time

                    return MemoryResult(
                        content: content,
                        similarity: similarity,
                        timestamp: self.accessTimes[key] ?? Date(),
                        source: .shortTerm
                    )
                }
                .sorted { $0.similarity > $1.similarity }
                .prefix(limit)

                continuation.resume(returning: Array(results))
            }
        }
    }

    func clear() async {
        await withCheckedContinuation { continuation in
            queue.async {
                self.storage.removeAll()
                self.accessTimes.removeAll()
                continuation.resume()
            }
        }
    }

    func getHealth() async -> MemoryLayerHealth {
        await withCheckedContinuation { continuation in
            queue.async {
                let health = MemoryLayerHealth(
                    totalEntries: self.storage.count,
                    memoryUsage: Double(self.storage.count) / Double(self.maxSize),
                    lastAccess: self.accessTimes.values.max() ?? Date.distantPast,
                    isHealthy: self.storage.count < self.maxSize * 9 / 10
                )
                continuation.resume(returning: health)
            }
        }
    }

    private func evictIfNeeded() {
        guard storage.count > maxSize else { return }

        // Evict least recently used entries
        let sortedByAccess = accessTimes.sorted { $0.value < $1.value }
        let toEvict = sortedByAccess.prefix(storage.count - maxSize + 100) // Evict extra for buffer

        for (key, _) in toEvict {
            storage.removeValue(forKey: key)
            accessTimes.removeValue(forKey: key)
        }
    }

    private func generateKey<T: MemoryContent>(for content: T, context: MemoryContext) -> String {
        return "\(context.id)_\(content.memoryType)_\(UUID().uuidString)"
    }

    private func calculateSimilarity<T: MemoryContent>(query: String, content: T) -> Double {
        // Simple text similarity - in production would use semantic embeddings
        let queryWords = Set(query.lowercased().components(separatedBy: .whitespacesAndNewlines))
        let contentWords = Set(content.searchableText.lowercased().components(separatedBy: .whitespacesAndNewlines))

        let intersection = queryWords.intersection(contentWords)
        let union = queryWords.union(contentWords)

        return union.isEmpty ? 0.0 : Double(intersection.count) / Double(union.count)
    }
}

// MARK: - Entity Bound Memory

/// ChromaDB-backed memory bound to specific agent identities
class EntityBoundMemory: ObservableObject {
    private let vectorPath: String
    private let encryptionKey: SymmetricKey
    private let vectorModel = "all-mpnet-base-v2"
    private var chromaClients: [String: ChromaDBClient] = [:]

    init(vectorPath: String, encryptionKey: SymmetricKey) {
        self.vectorPath = vectorPath
        self.encryptionKey = encryptionKey
    }

    func store<T: MemoryContent>(_ content: T, agentId: String, context: MemoryContext) async throws {
        let client = try await getChromaClient(for: agentId)

        let embeddings = try await generateEmbeddings(for: content.searchableText)
        let encryptedContent = try encrypt(content)

        let document = ChromaDocument(
            id: UUID().uuidString,
            embeddings: embeddings,
            metadata: [
                "agent_id": agentId,
                "content_type": content.memoryType,
                "timestamp": ISO8601DateFormatter().string(from: Date()),
                "context_id": context.id
            ],
            document: encryptedContent
        )

        try await client.add(document)
    }

    func retrieve<T: MemoryContent>(
        _ type: T.Type,
        query: String,
        agentId: String,
        limit: Int
    ) async throws -> [MemoryResult<T>] {
        let client = try await getChromaClient(for: agentId)

        let queryEmbeddings = try await generateEmbeddings(for: query)

        let results = try await client.query(
            queryEmbeddings: queryEmbeddings,
            nResults: limit,
            whereMetadata: ["agent_id": agentId]
        )

        return try results.compactMap { result in
            guard let encryptedContent = result.document else { return nil }

            let decryptedContent: T = try decrypt(encryptedContent)
            let timestamp = ISO8601DateFormatter().date(from: result.metadata["timestamp"] as? String ?? "") ?? Date()

            return MemoryResult(
                content: decryptedContent,
                similarity: result.distance,
                timestamp: timestamp,
                source: .entityBound(agentId)
            )
        }
    }

    func clearAgent(_ agentId: String) async throws {
        if let client = chromaClients[agentId] {
            try await client.deleteCollection()
            chromaClients.removeValue(forKey: agentId)
        }
    }

    func getHealth() async -> MemoryLayerHealth {
        let totalClients = chromaClients.count
        let healthyClients = await withTaskGroup(of: Bool.self) { group in
            for client in chromaClients.values {
                group.addTask {
                    await client.isHealthy()
                }
            }

            var healthy = 0
            for await isHealthy in group where isHealthy {
                healthy += 1
            }
            return healthy
        }

        return MemoryLayerHealth(
            totalEntries: totalClients,
            memoryUsage: totalClients > 0 ? Double(healthyClients) / Double(totalClients) : 1.0,
            lastAccess: Date(),
            isHealthy: healthyClients == totalClients
        )
    }

    private func getChromaClient(for agentId: String) async throws -> ChromaDBClient {
        if let client = chromaClients[agentId] {
            return client
        }

        let agentHash = generateAgentHash(agentId)
        let dbPath = "\(vectorPath)/\(agentHash)/memory.vdb"

        let client = ChromaDBClient(
            path: dbPath,
            collectionName: "agent_memory",
            vectorModel: vectorModel
        )

        try await client.initialize()
        chromaClients[agentId] = client

        return client
    }

    private func generateAgentHash(_ agentId: String) -> String {
        let inputData = Data(agentId.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    private func encrypt<T: Codable>(_ content: T) throws -> String {
        let data = try JSONEncoder().encode(content)
        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
        return sealedBox.combined?.base64EncodedString() ?? ""
    }

    private func decrypt<T: Codable>(_ encryptedString: String) throws -> T {
        guard let data = Data(base64Encoded: encryptedString) else {
            throw MemoryError.decryptionFailed
        }

        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        return try JSONDecoder().decode(T.self, from: decryptedData)
    }

    private func generateEmbeddings(for text: String) async throws -> [Double] {
        // In production, this would call the actual embedding model
        // For now, return mock embeddings
        return Array(repeating: Double.random(in: -1...1), count: 768)
    }
}

// MARK: - Relation Memory

/// Memory for interaction patterns between agents/users
class RelationMemory: ObservableObject {
    private let vectorPath: String
    private let encryptionKey: SymmetricKey
    private let vectorModel = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
    private var relationClients: [String: ChromaDBClient] = [:]

    init(vectorPath: String, encryptionKey: SymmetricKey) {
        self.vectorPath = vectorPath
        self.encryptionKey = encryptionKey
    }

    func store<T: MemoryContent>(_ content: T, agentA: String, agentB: String, context: MemoryContext) async throws {
        let relationKey = generateRelationKey(agentA: agentA, agentB: agentB)
        let client = try await getRelationClient(for: relationKey)

        let embeddings = try await generateEmbeddings(for: content.searchableText)
        let encryptedContent = try encrypt(content)

        let document = ChromaDocument(
            id: UUID().uuidString,
            embeddings: embeddings,
            metadata: [
                "agent_a": agentA,
                "agent_b": agentB,
                "relation_type": content.memoryType,
                "timestamp": ISO8601DateFormatter().string(from: Date()),
                "context_id": context.id,
                "immutable": "true"
            ],
            document: encryptedContent
        )

        try await client.add(document)
    }

    func retrieve<T: MemoryContent>(
        _ type: T.Type,
        query: String,
        agentA: String,
        agentB: String,
        limit: Int
    ) async throws -> [MemoryResult<T>] {
        let relationKey = generateRelationKey(agentA: agentA, agentB: agentB)
        let client = try await getRelationClient(for: relationKey)

        let queryEmbeddings = try await generateEmbeddings(for: query)

        let results = try await client.query(
            queryEmbeddings: queryEmbeddings,
            nResults: limit,
            whereMetadata: ["agent_a": agentA, "agent_b": agentB]
        )

        return try results.compactMap { result in
            guard let encryptedContent = result.document else { return nil }

            let decryptedContent: T = try decrypt(encryptedContent)
            let timestamp = ISO8601DateFormatter().date(from: result.metadata["timestamp"] as? String ?? "") ?? Date()

            return MemoryResult(
                content: decryptedContent,
                similarity: result.distance,
                timestamp: timestamp,
                source: .relation(agentA, agentB)
            )
        }
    }

    func clearRelation(agentA: String, agentB: String) async throws {
        let relationKey = generateRelationKey(agentA: agentA, agentB: agentB)

        if let client = relationClients[relationKey] {
            try await client.deleteCollection()
            relationClients.removeValue(forKey: relationKey)
        }
    }

    func getHealth() async -> MemoryLayerHealth {
        let totalRelations = relationClients.count
        let healthyRelations = await withTaskGroup(of: Bool.self) { group in
            for client in relationClients.values {
                group.addTask {
                    await client.isHealthy()
                }
            }

            var healthy = 0
            for await isHealthy in group where isHealthy {
                healthy += 1
            }
            return healthy
        }

        return MemoryLayerHealth(
            totalEntries: totalRelations,
            memoryUsage: totalRelations > 0 ? Double(healthyRelations) / Double(totalRelations) : 1.0,
            lastAccess: Date(),
            isHealthy: healthyRelations == totalRelations
        )
    }

    private func generateRelationKey(agentA: String, agentB: String) -> String {
        // Ensure consistent ordering for bidirectional relations
        let sortedAgents = [agentA, agentB].sorted()
        let relationString = "\(sortedAgents[0])-\(sortedAgents[1])"

        let inputData = Data(relationString.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    private func getRelationClient(for relationKey: String) async throws -> ChromaDBClient {
        if let client = relationClients[relationKey] {
            return client
        }

        let dbPath = "\(vectorPath)/\(relationKey)/memory.vdb"

        let client = ChromaDBClient(
            path: dbPath,
            collectionName: "relation_memory",
            vectorModel: vectorModel
        )

        try await client.initialize()
        relationClients[relationKey] = client

        return client
    }

    private func encrypt<T: Codable>(_ content: T) throws -> String {
        let data = try JSONEncoder().encode(content)
        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
        return sealedBox.combined?.base64EncodedString() ?? ""
    }

    private func decrypt<T: Codable>(_ encryptedString: String) throws -> T {
        guard let data = Data(base64Encoded: encryptedString) else {
            throw MemoryError.decryptionFailed
        }

        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        return try JSONDecoder().decode(T.self, from: decryptedData)
    }

    private func generateEmbeddings(for text: String) async throws -> [Double] {
        // In production, this would call the actual embedding model
        return Array(repeating: Double.random(in: -1...1), count: 384) // MiniLM dimensions
    }
}

// MARK: - Collective Memory

/// Federated, immutable collective memory for resolved conflicts and solutions
class CollectiveMemory: ObservableObject {
    private let vectorPath: String
    private let encryptionKey: SymmetricKey
    private var federationNodes: [FederationNode] = []
    private var localClient: ChromaDBClient?
    private let syncInterval: TimeInterval = 4 * 3600 // 4 hours

    init(vectorPath: String, encryptionKey: SymmetricKey) {
        self.vectorPath = vectorPath
        self.encryptionKey = encryptionKey

        setupFederationNodes()
        scheduleSync()
    }

    func store<T: MemoryContent>(_ content: T, context: MemoryContext) async throws {
        // Collective memory is write-on-resolution only
        guard context.isResolution else {
            throw MemoryError.unauthorizedWrite
        }

        let client = try await getLocalClient()

        let embeddings = try await generateEmbeddings(for: content.searchableText)
        let encryptedContent = try encrypt(content)

        let document = ChromaDocument(
            id: UUID().uuidString,
            embeddings: embeddings,
            metadata: [
                "content_type": content.memoryType,
                "timestamp": ISO8601DateFormatter().string(from: Date()),
                "context_id": context.id,
                "immutable": "true",
                "resolution": "true",
                "node_id": getCurrentNodeId()
            ],
            document: encryptedContent
        )

        try await client.add(document)

        // Broadcast to federation
        await broadcastToFederation(document)
    }

    func retrieve<T: MemoryContent>(_ type: T.Type, query: String, limit: Int) async throws -> [MemoryResult<T>] {
        let client = try await getLocalClient()

        let queryEmbeddings = try await generateEmbeddings(for: query)

        let results = try await client.query(
            queryEmbeddings: queryEmbeddings,
            nResults: limit,
            whereMetadata: ["immutable": "true"]
        )

        return try results.compactMap { result in
            guard let encryptedContent = result.document else { return nil }

            let decryptedContent: T = try decrypt(encryptedContent)
            let timestamp = ISO8601DateFormatter().date(from: result.metadata["timestamp"] as? String ?? "") ?? Date()

            return MemoryResult(
                content: decryptedContent,
                similarity: result.distance,
                timestamp: timestamp,
                source: .collective
            )
        }
    }

    func synchronize() async throws {
        for node in federationNodes {
            try await syncWithNode(node)
        }
    }

    func getHealth() async -> MemoryLayerHealth {
        let localHealthy = await localClient?.isHealthy() ?? false
        let federationHealth = await checkFederationHealth()

        return MemoryLayerHealth(
            totalEntries: federationNodes.count + 1, // +1 for local
            memoryUsage: federationHealth,
            lastAccess: Date(),
            isHealthy: localHealthy && federationHealth > 0.7
        )
    }

    private func getLocalClient() async throws -> ChromaDBClient {
        if let client = localClient {
            return client
        }

        let dbPath = "\(vectorPath)/ledger.vdb"

        let client = ChromaDBClient(
            path: dbPath,
            collectionName: "collective_memory",
            vectorModel: "all-mpnet-base-v2"
        )

        try await client.initialize()
        localClient = client

        return client
    }

    private func setupFederationNodes() {
        // In production, this would discover federation peers
        federationNodes = [
            FederationNode(id: "node_alpha", endpoint: "https://alpha.novamind.federation"),
            FederationNode(id: "node_beta", endpoint: "https://beta.novamind.federation"),
            FederationNode(id: "node_gamma", endpoint: "https://gamma.novamind.federation")
        ]
    }

    private var syncTimer: Timer?

    private func scheduleSync() {
        syncTimer?.invalidate()
        syncTimer = Timer.scheduledTimer(withTimeInterval: syncInterval, repeats: true) { [weak self] _ in
            Task {
                try? await self?.synchronize()
            }
        }
    }

    private func broadcastToFederation(_ document: ChromaDocument) async {
        await withTaskGroup(of: Void.self) { group in
            for node in federationNodes {
                group.addTask {
                    try? await self.sendToNode(document, node: node)
                }
            }
        }
    }

    private func syncWithNode(_ node: FederationNode) async throws {
        // Sync implementation would handle incremental updates
        // For now, simulate sync operation
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
    }

    private func sendToNode(_ document: ChromaDocument, node: FederationNode) async throws {
        // Federation broadcast implementation
        try await Task.sleep(nanoseconds: 50_000_000) // 50ms
    }

    private func checkFederationHealth() async -> Double {
        let healthyNodes = await withTaskGroup(of: Bool.self) { group in
            for node in federationNodes {
                group.addTask {
                    await self.checkNodeHealth(node)
                }
            }

            var healthy = 0
            for await isHealthy in group where isHealthy {
                healthy += 1
            }
            return healthy
        }

        return federationNodes.isEmpty ? 1.0 : Double(healthyNodes) / Double(federationNodes.count)
    }

    private func checkNodeHealth(_ node: FederationNode) async -> Bool {
        // Mock health check
        return Bool.random()
    }

    private func getCurrentNodeId() -> String {
        return "local_node_\(UUID().uuidString.prefix(8))"
    }

    private func encrypt<T: Codable>(_ content: T) throws -> String {
        let data = try JSONEncoder().encode(content)
        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
        return sealedBox.combined?.base64EncodedString() ?? ""
    }

    private func decrypt<T: Codable>(_ encryptedString: String) throws -> T {
        guard let data = Data(base64Encoded: encryptedString) else {
            throw MemoryError.decryptionFailed
        }

        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        return try JSONDecoder().decode(T.self, from: decryptedData)
    }

    private func generateEmbeddings(for text: String) async throws -> [Double] {
        // In production, this would call the actual embedding model
        return Array(repeating: Double.random(in: -1...1), count: 768)
    }
}

// MARK: - Supporting Types

protocol MemoryContent: Codable, Identifiable {
    var memoryType: String { get }
    var searchableText: String { get }
}

struct MemoryContext {
    let id: String
    let scope: MemoryScope
    let isResolution: Bool
    let priority: MemoryPriority

    init(scope: MemoryScope, isResolution: Bool = false, priority: MemoryPriority = .normal) {
        self.id = UUID().uuidString
        self.scope = scope
        self.isResolution = isResolution
        self.priority = priority
    }
}

enum ResetCondition {
    case contextSwitch
    case agentReset
    case mutualAgreement
    case systemRestart
}

struct MemoryResult<T: MemoryContent> {
    let content: T
    let similarity: Double
    let timestamp: Date
    let source: MemorySource
}

enum MemorySource {
    case shortTerm
    case entityBound(String)
    case relation(String, String)
    case collective
}

struct MemoryHealth {
    let shortTerm: MemoryLayerHealth
    let entityBound: MemoryLayerHealth
    let relation: MemoryLayerHealth
    let collective: MemoryLayerHealth
    let lastUpdate: Date

    init() {
        self.shortTerm = MemoryLayerHealth()
        self.entityBound = MemoryLayerHealth()
        self.relation = MemoryLayerHealth()
        self.collective = MemoryLayerHealth()
        self.lastUpdate = Date()
    }

    init(
        shortTerm: MemoryLayerHealth,
        entityBound: MemoryLayerHealth,
        relation: MemoryLayerHealth,
        collective: MemoryLayerHealth,
        lastUpdate: Date
    ) {
        self.shortTerm = shortTerm
        self.entityBound = entityBound
        self.relation = relation
        self.collective = collective
        self.lastUpdate = lastUpdate
    }

    var overallHealth: Double {
        let weights = [0.2, 0.3, 0.2, 0.3] // Short, Entity, Relation, Collective
        let healths = [shortTerm.healthScore, entityBound.healthScore, relation.healthScore, collective.healthScore]

        return zip(weights, healths).map(*).reduce(0, +)
    }
}

struct MemoryLayerHealth {
    let totalEntries: Int
    let memoryUsage: Double
    let lastAccess: Date
    let isHealthy: Bool

    init() {
        self.totalEntries = 0
        self.memoryUsage = 0.0
        self.lastAccess = Date.distantPast
        self.isHealthy = true
    }

    init(totalEntries: Int, memoryUsage: Double, lastAccess: Date, isHealthy: Bool) {
        self.totalEntries = totalEntries
        self.memoryUsage = memoryUsage
        self.lastAccess = lastAccess
        self.isHealthy = isHealthy
    }

    var healthScore: Double {
        guard isHealthy else { return 0.0 }

        let usageScore = memoryUsage < 0.8 ? 1.0 : (1.0 - memoryUsage)
        let accessScore = lastAccess.timeIntervalSinceNow > -3600 ? 1.0 : 0.5 // Recent access

        return (usageScore + accessScore) / 2.0
    }
}

struct MemoryConfiguration {
    let maxShortTermEntries: Int
    let encryptionEnabled: Bool
    let federationEnabled: Bool
    let syncInterval: TimeInterval
    let vectorDimensions: Int

    static func load() -> MemoryConfiguration {
        return MemoryConfiguration(
            maxShortTermEntries: 1000,
            encryptionEnabled: true,
            federationEnabled: true,
            syncInterval: 4 * 3600,
            vectorDimensions: 768
        )
    }
}

struct FederationNode {
    let id: String
    let endpoint: String
    var isActive: Bool = true
    var lastSync: Date?
}

enum MemoryError: Error, LocalizedError {
    case encryptionFailed
    case decryptionFailed
    case unauthorizedWrite
    case vectorModelNotFound
    case federationSyncFailed

    var errorDescription: String? {
        switch self {
        case .encryptionFailed: return "Failed to encrypt memory content"
        case .decryptionFailed: return "Failed to decrypt memory content"
        case .unauthorizedWrite: return "Unauthorized write to collective memory"
        case .vectorModelNotFound: return "Vector embedding model not found"
        case .federationSyncFailed: return "Federation synchronization failed"
        }
    }
}
