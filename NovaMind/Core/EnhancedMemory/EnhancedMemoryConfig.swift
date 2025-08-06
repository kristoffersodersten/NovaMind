import Foundation

// MARK: - Configuration Types

struct EnhancedMemoryConfig {
    let vectorConfig: VectorConfig
    let federationConfig: FederationConfig
    let collectiveConfig: CollectiveConfig
    let performanceConfig: PerformanceConfig
    let chromaPath: String
    let encryptionEnabled: Bool
    let maxMemorySize: Int
    let cleanupInterval: TimeInterval
    
    static func loadFromYAML() -> EnhancedMemoryConfig {
        // Load from YAML configuration
        return EnhancedMemoryConfig(
            vectorConfig: VectorConfig.default,
            federationConfig: FederationConfig.default,
            collectiveConfig: CollectiveConfig.default,
            performanceConfig: PerformanceConfig.default,
            chromaPath: "./chroma_db",
            encryptionEnabled: true,
            maxMemorySize: 1000000,
            cleanupInterval: 3600.0
        )
    }
}

struct VectorConfig {
    let embeddingModel: String
    let dimensions: Int
    let similarity: String
    
    static let `default` = VectorConfig(
        embeddingModel: "text-embedding-ada-002",
        dimensions: 1536,
        similarity: "cosine"
    )
}

struct FederationConfig {
    let enabled: Bool
    let nodes: [String]
    let syncInterval: TimeInterval
    
    static let `default` = FederationConfig(
        enabled: false,
        nodes: [],
        syncInterval: 300.0
    )
}

struct CollectiveConfig {
    let enabled: Bool
    let consensusThreshold: Double
    let trustThreshold: Double
    
    static let `default` = CollectiveConfig(
        enabled: true,
        consensusThreshold: 0.7,
        trustThreshold: 0.6
    )
}

struct PerformanceConfig {
    let cacheSize: Int
    let batchSize: Int
    let timeout: TimeInterval
    
    static let `default` = PerformanceConfig(
        cacheSize: 1000,
        batchSize: 50,
        timeout: 30.0
    )
}

// MARK: - Health and Monitoring Types

struct EnhancedMemoryHealth {
    let overallHealth: Double
    let componentHealth: [String: ComponentHealth]
    let lastUpdated: Date
    
    init() {
        self.overallHealth = 1.0
        self.componentHealth = [:]
        self.lastUpdated = Date()
    }
}

struct ComponentHealth {
    let isHealthy: Bool
    let lastCheck: Date
    let metrics: [String: Double]
}

struct MemoryPerformanceMetrics {
    let operationCounts: [MemoryOperation: Int]
    let averageLatency: [MemoryOperation: TimeInterval]
    let successRate: Double
    let lastReset: Date
    
    init() {
        self.operationCounts = [:]
        self.averageLatency = [:]
        self.successRate = 1.0
        self.lastReset = Date()
    }
}

// MARK: - ChromaDB Types

class ChromaDBClient {
    let path: String
    let collectionName: String
    let vectorModel: String

    init(path: String, collectionName: String, vectorModel: String) {
        self.path = path
        self.collectionName = collectionName
        self.vectorModel = vectorModel
    }

    func initialize() async throws {
        // Initialize ChromaDB client
    }

    func add(_ document: ChromaDocument) async throws {
        // Add document to ChromaDB
    }

    func query(
        queryEmbeddings: [Double],
        nResults: Int,
        whereMetadata: [String: Any]? = nil
    ) async throws -> [QueryResult] {
        // Query ChromaDB
        return []
    }

    func deleteCollection() async throws {
        // Delete collection
    }

    func isHealthy() async -> Bool {
        return true
    }
}

struct ChromaDocument {
    let id: String
    let embeddings: [Double]
    let metadata: [String: Any]
    let document: String?
}

struct QueryResult {
    let id: String
    let distance: Double
    let metadata: [String: Any]
    let document: String?
}

// MARK: - Error Types

enum EnhancedMemoryError: Error {
    case insufficientConsent(required: Double, actual: Double)
    case insufficientConsensus(required: Double, actual: Double)
    case noMemoriesToFuse
    case decryptionFailed
    case vectorGenerationFailed
    case federationSyncFailed
    case invalidConfiguration
    
    var localizedDescription: String {
        switch self {
        case .insufficientConsent(let required, let actual):
            return "Insufficient consent - required: \(required), actual: \(actual)"
        case .insufficientConsensus(let required, let actual):
            return "Insufficient consensus - required: \(required), actual: \(actual)"
        case .noMemoriesToFuse:
            return "No memories provided for fusion"
        case .decryptionFailed:
            return "Failed to decrypt memory content"
        case .vectorGenerationFailed:
            return "Failed to generate vector embeddings"
        case .federationSyncFailed:
            return "Federation synchronization failed"
        case .invalidConfiguration:
            return "Invalid memory configuration"
        }
    }
}
