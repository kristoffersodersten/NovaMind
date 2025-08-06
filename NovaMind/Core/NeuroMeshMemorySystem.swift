import Combine
import CryptoKit
import Foundation


// MARK: - Neuromesh Memory System

/// Neuromesh Memory System - Three interconnected memory layers for functional and emotional characteristics
/// Enables self-reflection, collaboration, and collective improvement through sophisticated memory architecture
class NeuroMeshMemorySystem: ObservableObject {
    static let shared = NeuroMeshMemorySystem()

    // MARK: - Memory Layers

    @Published private(set) var entityMemory: EntityMemoryLayer
    @Published private(set) var relationMemory: RelationMemoryLayer
    @Published private(set) var collectiveMemory: CollectiveMemoryLayer

    // MARK: - Resonance Radar Integration

    @Published private(set) var resonanceRadar: NeuroMeshResonanceRadar

    // MARK: - Ethics & Emotion Framework

    @Published private(set) var ethicsFramework: NeuroMeshEthicsFramework
    @Published private(set) var emotionModel: NeuroMeshEmotionModel

    // MARK: - System Health

    @Published var systemHealth: NeuroMeshHealth
    @Published var participationMetrics: ParticipationProtocol

    private let encryptionKey: SymmetricKey
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Initialize encryption
        self.encryptionKey = SymmetricKey(size: .bits256)

        // Initialize memory layers
        self.entityMemory = EntityMemoryLayer(encryptionKey: encryptionKey)
        self.relationMemory = RelationMemoryLayer(encryptionKey: encryptionKey)
        self.collectiveMemory = CollectiveMemoryLayer(encryptionKey: encryptionKey)

        // Initialize supporting systems
        self.resonanceRadar = NeuroMeshResonanceRadar()
        self.ethicsFramework = NeuroMeshEthicsFramework()
        self.emotionModel = NeuroMeshEmotionModel()

        // Initialize health monitoring
        self.systemHealth = NeuroMeshHealth()
        self.participationMetrics = ParticipationProtocol()

        setupSystemIntegration()
    }

    // MARK: - Core Memory Operations

    /// Store memory with emotional context and ethical validation
    func storeMemoryWithContext<T: NeuroMeshMemoryContent>(
        _ content: T,
        context: NeuroMeshContext,
        emotionalState: EmotionalState? = nil
    ) async throws {
        // Validate ethics compliance
        try await ethicsFramework.validateWrite(content: content, context: context)

        // Process emotional context
        if let emotion = emotionalState {
            emotionModel.processEmotionalContext(emotion, for: context)
        }

        // Store in appropriate layer
        switch context.scope {
        case .entity(let agentId):
            try await entityMemory.store(content, agentId: agentId, context: context)

        case .relation(let agentA, let agentB):
            try await relationMemory.store(content, agentA: agentA, agentB: agentB, context: context)

        case .collective(let layer):
            try await collectiveMemory.store(content, layer: layer, context: context)
        }

        // Update resonance radar
        await resonanceRadar.processMemoryEvent(content: content, context: context)

        await updateSystemHealth()
    }

    /// Retrieve memory with emotional and contextual awareness
    func retrieveMemoryWithResonance<T: NeuroMeshMemoryContent>(
        _ type: T.Type,
        query: String,
        context: NeuroMeshContext,
        emotionalFilter: EmotionalState? = nil,
        limit: Int = 10
    ) async throws -> [NeuroMeshResult<T>] {
        // Get base results from memory layer
        let baseResults: [NeuroMeshResult<T>]

        switch context.scope {
        case .entity(let agentId):
            baseResults = try await entityMemory.retrieve(type, query: query, agentId: agentId, limit: limit)

        case .relation(let agentA, let agentB):
            baseResults = try await relationMemory.retrieve(type, query: query, agentA: agentA, agentB: agentB, limit: limit)

        case .collective(let layer):
            baseResults = try await collectiveMemory.retrieve(type, query: query, layer: layer, limit: limit)
        }

        // Apply emotional filtering
        let emotionallyFiltered = emotionModel.filterByEmotionalRelevance(
            results: baseResults,
            currentState: emotionalFilter,
            context: context
        )

        // Apply resonance radar insights
        let resonanceEnhanced = await resonanceRadar.enhanceWithResonanceInsights(
            results: emotionallyFiltered,
            query: query,
            context: context
        )

        return resonanceEnhanced
    }

    /// Trigger self-reflection process for an agent
    func triggerSelfReflection(for agentId: String, trigger: SelfReflectionTrigger) async throws {
        let reflectionContext = NeuroMeshContext(
            scope: .entity(agentId),
            purpose: .selfReflection,
            ethicalFlags: [.respectAsConstant]
        )

        // Analyze current patterns
        let patterns = try await entityMemory.analyzePatterns(agentId: agentId)

        // Generate self-reflection insights
        let reflection = SelfReflectionMemory(
            agentId: agentId,
            trigger: trigger,
            patterns: patterns,
            insights: generateReflectionInsights(patterns),
            emotionalContext: emotionModel.getCurrentState(for: agentId),
            timestamp: Date()
        )

        try await storeMemoryWithContext(
            reflection,
            context: reflectionContext,
            emotionalState: .introspective
        )

        // Update participation metrics
        participationMetrics.recordSelfReflection(agentId: agentId)
    }

    /// Handle collaborative memory mutation with consent
    func requestCollaborativeMemoryMutation(
        content: any NeuroMeshMemoryContent,
        agentA: String,
        agentB: String,
        mutationType: MutationType
    ) async throws -> MutationResult {
        // Check current relation state
        let relationContext = NeuroMeshContext(
            scope: .relation(agentA, agentB),
            purpose: .collaboration,
            ethicalFlags: [.respectAsConstant, .mutualConsent]
        )

        // Get mutual consent
        let consentA = try await requestMutationConsent(from: agentA, for: content, context: relationContext)
        let consentB = try await requestMutationConsent(from: agentB, for: content, context: relationContext)

        guard consentA.granted && consentB.granted else {
            return MutationResult(
                success: false,
                reason: "Mutual consent not obtained",
                alternativeSuggestions: generateConsentAlternatives(consentA, consentB)
            )
        }

        // Apply mutation
        try await relationMemory.applyMutation(
            content: content,
            agentA: agentA,
            agentB: agentB,
            mutationType: mutationType,
            context: relationContext
        )

        // Record collaboration success
        let collaborationMemory = CollaborationMemory(
            participants: [agentA, agentB],
            mutationType: mutationType,
            outcome: .successful,
            trustImpact: calculateTrustImpact(consentA, consentB),
            timestamp: Date()
        )

        try await storeMemoryWithContext(
            collaborationMemory,
            context: relationContext,
            emotionalState: .cooperative
        )

        return MutationResult(success: true, reason: "Collaborative mutation applied successfully")
    }

    // MARK: - System Integration

    private func setupSystemIntegration() {
        // Setup daily resonance radar analysis
        Timer.publish(every: 86400, on: .main, in: .common) // Daily
            .autoconnect()
            .sink { _ in
                Task {
                    await self.performDailyResonanceAnalysis()
                }
            }
            .store(in: &cancellables)

        // Setup emotional state monitoring
        Timer.publish(every: 300, on: .main, in: .common) // Every 5 minutes
            .autoconnect()
            .sink { _ in
                Task {
                    await self.updateEmotionalStates()
                }
            }
            .store(in: &cancellables)
    }

    private func performDailyResonanceAnalysis() async {
        await resonanceRadar.performDailyAnalysis()
        await updateSystemHealth()
    }

    private func updateEmotionalStates() async {
        await emotionModel.updateAllEmotionalStates()
    }

    private func updateSystemHealth() async {
        let entityHealth = await entityMemory.getHealth()
        let relationHealth = await relationMemory.getHealth()
        let collectiveHealth = await collectiveMemory.getHealth()
        let radarHealth = await resonanceRadar.getHealth()

        await MainActor.run {
            self.systemHealth = NeuroMeshHealth(
                entityLayer: entityHealth,
                relationLayer: relationHealth,
                collectiveLayer: collectiveHealth,
                resonanceRadar: radarHealth,
                ethicsCompliance: ethicsFramework.getComplianceScore(),
                emotionalWellbeing: emotionModel.getOverallWellbeing(),
                lastUpdate: Date()
            )
        }
    }

    // MARK: - Helper Methods

    private func generateReflectionInsights(_ patterns: [BehaviorPattern]) -> [ReflectionInsight] {
        return patterns.compactMap { pattern in
            ReflectionInsight(
                pattern: pattern,
                strength: calculatePatternStrength(pattern),
                recommendation: generatePatternRecommendation(pattern),
                emotionalRelevance: emotionModel.assessEmotionalRelevance(pattern)
            )
        }
    }

    private func calculatePatternStrength(_ pattern: BehaviorPattern) -> Double {
        return min(1.0, Double(pattern.frequency) * pattern.successRate / 100.0)
    }

    private func generatePatternRecommendation(_ pattern: BehaviorPattern) -> String {
        if pattern.successRate > 0.8 {
            return "Fortsätt utveckla detta mönster - hög framgångsgrad"
        } else if pattern.successRate > 0.5 {
            return "Överväg förbättringar av detta mönster"
        } else {
            return "Utforska alternativa tillvägagångssätt"
        }
    }

    private func requestMutationConsent(
        from agentId: String,
        for content: any NeuroMeshMemoryContent,
        context: NeuroMeshContext
    ) async throws -> ConsentResponse {
        // In production, this would query the actual agent
        // For now, simulate consent logic based on content and relationship
        let trustLevel = await relationMemory.getTrustLevel(agentId: agentId, context: context)
        let contentSafety = ethicsFramework.assessContentSafety(content)

        return ConsentResponse(
            agentId: agentId,
            granted: trustLevel > 0.7 && contentSafety > 0.8,
            confidence: trustLevel * contentSafety,
            conditions: generateConsentConditions(trustLevel, contentSafety)
        )
    }

    private func generateConsentConditions(_ trustLevel: Double, _ safety: Double) -> [String] {
        var conditions: [String] = []

        if trustLevel < 0.8 {
            conditions.append("Kräver ytterligare förtroendebyggande")
        }

        if safety < 0.9 {
            conditions.append("Behöver mentorsgranskning")
        }

        return conditions
    }

    private func generateConsentAlternatives(_ consentA: ConsentResponse, _ consentB: ConsentResponse) -> [String] {
        var alternatives: [String] = []

        if !consentA.granted {
            alternatives.append("Förbättra förtroendet med \(consentA.agentId)")
        }

        if !consentB.granted {
            alternatives.append("Adressera säkerhetsproblem med \(consentB.agentId)")
        }

        alternatives.append("Begär mentorsmediering")
        alternatives.append("Föreslå modifierad version")

        return alternatives
    }

    private func calculateTrustImpact(_ consentA: ConsentResponse, _ consentB: ConsentResponse) -> Double {
        return (consentA.confidence + consentB.confidence) / 2.0
    }
}

// MARK: - Entity Memory Layer

/// Private memory layer for individual agents - självkorrigering, preferensinlärning, emotionell kontext
class EntityMemoryLayer: ObservableObject {
    private let encryptionKey: SymmetricKey
    private let basePath = "/memory/entities"
    private var agentClients: [String: ChromaDBClient] = [:]

    init(encryptionKey: SymmetricKey) {
        self.encryptionKey = encryptionKey
    }

    func store<T: NeuroMeshMemoryContent>(
        _ content: T,
        agentId: String,
        context: NeuroMeshContext
    ) async throws {
        let client = try await getAgentClient(agentId)

        let embeddings = try await generateEmbeddings(for: content.searchableText)
        let encryptedContent = try encrypt(content)

        let document = ChromaDocument(
            id: UUID().uuidString,
            embeddings: embeddings,
            metadata: [
                "agent_id": agentId,
                "content_type": content.memoryType,
                "purpose": context.purpose.rawValue,
                "ethical_flags": context.ethicalFlags.map { $0.rawValue }.joined(separator: ","),
                "timestamp": ISO8601DateFormatter().string(from: Date()),
                "respect_as_constant": "true"
            ],
            document: encryptedContent
        )

        try await client.add(document)
    }

    func retrieve<T: NeuroMeshMemoryContent>(
        _ type: T.Type,
        query: String,
        agentId: String,
        limit: Int
    ) async throws -> [NeuroMeshResult<T>] {
        let client = try await getAgentClient(agentId)

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

            return NeuroMeshResult(
                content: decryptedContent,
                similarity: result.distance,
                timestamp: timestamp,
                source: .entity(agentId),
                emotionalResonance: calculateEmotionalResonance(result.metadata)
            )
        }
    }

    func analyzePatterns(agentId: String) async throws -> [BehaviorPattern] {
        let client = try await getAgentClient(agentId)

        // Query for behavioral patterns
        let behaviorQuery = try await generateEmbeddings(for: "behavior pattern success frequency")

        let results = try await client.query(
            queryEmbeddings: behaviorQuery,
            nResults: 50,
            whereMetadata: ["agent_id": agentId, "content_type": "behavior_pattern"]
        )

        return try results.compactMap { result in
            guard let encryptedContent = result.document else { return nil }
            let pattern: BehaviorPattern = try decrypt(encryptedContent)
            return pattern
        }
    }

    func getHealth() async -> MemoryLayerHealth {
        let totalAgents = agentClients.count
        let healthyAgents = await withTaskGroup(of: Bool.self) { group in
            for client in agentClients.values {
                group.addTask {
                    await client.isHealthy()
                }
            }

            var healthy = 0
            for await isHealthy in group {
                if isHealthy { healthy += 1 }
            }
            return healthy
        }

        return MemoryLayerHealth(
            totalEntries: totalAgents,
            memoryUsage: totalAgents > 0 ? Double(healthyAgents) / Double(totalAgents) : 1.0,
            lastAccess: Date(),
            isHealthy: healthyAgents == totalAgents
        )
    }

    private func getAgentClient(_ agentId: String) async throws -> ChromaDBClient {
        if let client = agentClients[agentId] {
            return client
        }

        let dbPath = "\(basePath)/\(agentId)/memory.vdb"

        let client = ChromaDBClient(
            path: dbPath,
            collectionName: "entity_memory",
            vectorModel: "all-mpnet-base-v2"
        )

        try await client.initialize()
        agentClients[agentId] = client

        return client
    }

    private func encrypt<T: Codable>(_ content: T) throws -> String {
        let data = try JSONEncoder().encode(content)
        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
        return sealedBox.combined?.base64EncodedString() ?? ""
    }

    private func decrypt<T: Codable>(_ encryptedString: String) throws -> T {
        guard let data = Data(base64Encoded: encryptedString) else {
            throw NeuroMeshError.decryptionFailed
        }

        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        return try JSONDecoder().decode(T.self, from: decryptedData)
    }

    private func generateEmbeddings(for text: String) async throws -> [Double] {
        // Mock embeddings - in production would use actual embedding service
        return Array(repeating: Double.random(in: -1...1), count: 768)
    }

    private func calculateEmotionalResonance(_ metadata: [String: Any]) -> Double {
        // Calculate emotional resonance based on metadata
        return Double.random(in: 0.1...1.0)
    }
}

// MARK: - Relation Memory Layer

/// Shared memory for agent-agent and agent-user relationships
class RelationMemoryLayer: ObservableObject {
    private let encryptionKey: SymmetricKey
    private let basePath = "/memory/relations"
    private var relationClients: [String: ChromaDBClient] = [:]

    init(encryptionKey: SymmetricKey) {
        self.encryptionKey = encryptionKey
    }

    func store<T: NeuroMeshMemoryContent>(
        _ content: T,
        agentA: String,
        agentB: String,
        context: NeuroMeshContext
    ) async throws {
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
                "content_type": content.memoryType,
                "purpose": context.purpose.rawValue,
                "mutual_consent": "required",
                "timestamp": ISO8601DateFormatter().string(from: Date())
            ],
            document: encryptedContent
        )

        try await client.add(document)
    }

    func retrieve<T: NeuroMeshMemoryContent>(
        _ type: T.Type,
        query: String,
        agentA: String,
        agentB: String,
        limit: Int
    ) async throws -> [NeuroMeshResult<T>] {
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

            return NeuroMeshResult(
                content: decryptedContent,
                similarity: result.distance,
                timestamp: timestamp,
                source: .relation(agentA, agentB),
                emotionalResonance: calculateEmotionalResonance(result.metadata)
            )
        }
    }

    func applyMutation<T: NeuroMeshMemoryContent>(
        content: T,
        agentA: String,
        agentB: String,
        mutationType: MutationType,
        context: NeuroMeshContext
    ) async throws {
        // Apply mutation with consent validation
        try await store(content, agentA: agentA, agentB: agentB, context: context)

        // Record mutation event
        let mutationRecord = MutationRecord(
            mutationType: mutationType,
            participants: [agentA, agentB],
            contentType: content.memoryType,
            timestamp: Date(),
            success: true
        )

        try await store(mutationRecord, agentA: agentA, agentB: agentB, context: context)
    }

    func getTrustLevel(agentId: String, context: NeuroMeshContext) async -> Double {
        // Calculate trust level based on historical interactions
        // Mock implementation
        return Double.random(in: 0.5...1.0)
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
            for await isHealthy in group {
                if isHealthy { healthy += 1 }
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

        let dbPath = "\(basePath)/\(relationKey)/memory.vdb"

        let client = ChromaDBClient(
            path: dbPath,
            collectionName: "relation_memory",
            vectorModel: "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
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
            throw NeuroMeshError.decryptionFailed
        }

        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        return try JSONDecoder().decode(T.self, from: decryptedData)
    }

    private func generateEmbeddings(for text: String) async throws -> [Double] {
        return Array(repeating: Double.random(in: -1...1), count: 384) // MiniLM dimensions
    }

    private func calculateEmotionalResonance(_ metadata: [String: Any]) -> Double {
        return Double.random(in: 0.1...1.0)
    }
}

// MARK: - Supporting Types

protocol NeuroMeshMemoryContent: Codable, Identifiable {
    var memoryType: String { get }
    var searchableText: String { get }
    var emotionalContext: EmotionalContext? { get }
}

struct NeuroMeshContext {
    let id: String
    let scope: NeuroMeshScope
    let purpose: NeuroMeshPurpose
    let ethicalFlags: [EthicalFlag]

    init(scope: NeuroMeshScope, purpose: NeuroMeshPurpose, ethicalFlags: [EthicalFlag] = []) {
        self.id = UUID().uuidString
        self.scope = scope
        self.purpose = purpose
        self.ethicalFlags = ethicalFlags
    }
}

enum NeuroMeshScope {
    case entity(String) // agentId
    case relation(String, String) // agentA, agentB
    case collective(CollectiveLayer)
}

enum CollectiveLayer {
    case goldenStandard
    case tweaks
    case errors // laro_db
}

enum NeuroMeshPurpose: String {
    case selfReflection = "self_reflection"
    case collaboration = "collaboration"
    case improvement = "improvement"
    case errorLearning = "error_learning"
    case trustBuilding = "trust_building"
}

enum EthicalFlag: String {
    case respectAsConstant = "respect_as_constant"
    case diversityAsStrength = "diversity_as_strength"
    case selfReflectiveEvolution = "self_reflective_evolution"
    case truthAsAsymptote = "truth_as_asymptote"
    case mutualConsent = "mutual_consent"
}

struct NeuroMeshResult<T: NeuroMeshMemoryContent> {
    let content: T
    let similarity: Double
    let timestamp: Date
    let source: NeuroMeshSource
    let emotionalResonance: Double
}

enum NeuroMeshSource {
    case entity(String)
    case relation(String, String)
    case collective(CollectiveLayer)
}

struct NeuroMeshHealth {
    let entityLayer: MemoryLayerHealth
    let relationLayer: MemoryLayerHealth
    let collectiveLayer: MemoryLayerHealth
    let resonanceRadar: RadarHealth
    let ethicsCompliance: Double
    let emotionalWellbeing: Double
    let lastUpdate: Date

    init() {
        self.entityLayer = MemoryLayerHealth()
        self.relationLayer = MemoryLayerHealth()
        self.collectiveLayer = MemoryLayerHealth()
        self.resonanceRadar = RadarHealth()
        self.ethicsCompliance = 1.0
        self.emotionalWellbeing = 1.0
        self.lastUpdate = Date()
    }

    init(entityLayer: MemoryLayerHealth, relationLayer: MemoryLayerHealth, collectiveLayer: MemoryLayerHealth, resonanceRadar: RadarHealth, ethicsCompliance: Double, emotionalWellbeing: Double, lastUpdate: Date) {
        self.entityLayer = entityLayer
        self.relationLayer = relationLayer
        self.collectiveLayer = collectiveLayer
        self.resonanceRadar = resonanceRadar
        self.ethicsCompliance = ethicsCompliance
        self.emotionalWellbeing = emotionalWellbeing
        self.lastUpdate = lastUpdate
    }

    var overallHealth: Double {
        let weights = [0.25, 0.25, 0.25, 0.1, 0.1, 0.05]
        let scores = [
            entityLayer.healthScore,
            relationLayer.healthScore,
            collectiveLayer.healthScore,
            resonanceRadar.healthScore,
            ethicsCompliance,
            emotionalWellbeing
        ]

        return zip(weights, scores).map(*).reduce(0, +)
    }
}

enum NeuroMeshError: Error, LocalizedError {
    case encryptionFailed
    case decryptionFailed
    case ethicsViolation(String)
    case consentNotObtained
    case invalidScope

    var errorDescription: String? {
        switch self {
        case .encryptionFailed: return "Failed to encrypt memory content"
        case .decryptionFailed: return "Failed to decrypt memory content"
        case .ethicsViolation(let reason): return "Ethics violation: \(reason)"
        case .consentNotObtained: return "Mutual consent not obtained for memory mutation"
        case .invalidScope: return "Invalid memory scope specified"
        }
    }
}
