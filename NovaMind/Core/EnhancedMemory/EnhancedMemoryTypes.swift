import Foundation
import CryptoKit

// MARK: - Enhanced Memory Types

protocol EnhancedMemoryContent: Codable {
    var id: UUID { get }
    var memoryType: String { get }
    var searchableText: String { get }
    var enhancedMetadata: [String: Any] { get }
}

struct EnhancedMemoryItem<T: EnhancedMemoryContent> {
    let id: String
    let content: T
    let embeddings: [Double]
    let context: EnhancedMemoryContext
    let timestamp: Date
    let metadata: [String: Any]
}

struct EncryptedMemoryItem {
    let id: String
    let encryptedContent: String
    let embeddings: [Double]
    let metadata: [String: Any]
    let timestamp: Date
}

struct DecodedMemoryItem {
    let id: String
    let content: any EnhancedMemoryContent
    let embeddings: [Double]
    let context: EnhancedMemoryContext
    let timestamp: Date
    let metadata: [String: Any]
}

struct EnhancedMemoryContext {
    let scope: MemoryScope
    let targetLayer: MemoryLayer
    let priority: MemoryPriority = .normal
    let emotionalContext: EmotionalContext?
    let mutualConsent: MutualConsent?
    let resolution: ConflictResolution?
    let consensus: ConsensusLevel?
    let mentorValidation: MentorValidation?
    let federationPolicy: FederationPolicy

    init(
        scope: MemoryScope,
        targetLayer: MemoryLayer,
        priority: MemoryPriority = .normal,
        emotionalContext: EmotionalContext? = nil,
        mutualConsent: MutualConsent? = nil,
        resolution: ConflictResolution? = nil,
        consensus: ConsensusLevel? = nil,
        mentorValidation: MentorValidation? = nil,
        federationPolicy: FederationPolicy = .none
    ) {
        self.scope = scope
        self.targetLayer = targetLayer
        self.priority = priority
        self.emotionalContext = emotionalContext
        self.mutualConsent = mutualConsent
        self.resolution = resolution
        self.consensus = consensus
        self.mentorValidation = mentorValidation
        self.federationPolicy = federationPolicy
    }
}

struct EnhancedMemoryResult<T: EnhancedMemoryContent> {
    let content: T
    let similarity: Double
    let confidence: Double
    let timestamp: Date
    let source: MemorySource
    let context: EnhancedMemoryContext
    let embeddings: [Double]
}

struct MemoryStoreResult {
    let id: String
    let success: Bool
    let layer: MemoryLayer
    let timestamp: Date
}

struct SearchFilters {
    let dateRange: DateInterval?
    let priorityRange: ClosedRange<MemoryPriority>?
    let agentIds: [String]?
    let memoryTypes: [String]?
    let minimumTrustLevel: Double?
}

struct RetrievalContext {
    let query: String
    let layers: [MemoryLayer]
    let filters: SearchFilters?
    let limit: Int
}

struct ContextualQuery {
    let query: String
    let layers: [MemoryLayer]
    let filters: SearchFilters?
}

// MARK: - Enums

enum MemoryLayer: String, CaseIterable {
    case shortTerm
    case entityBound
    case relation
    case collective
    case all
}

enum MemoryOperation {
    case store
    case search
    case retrieve
}

enum MemoryPriority: Int, CaseIterable {
    case low = 1
    case normal = 2
    case high = 3
    case critical = 4
}

enum MemoryScope {
    case individual(String)
    case entity(String)
    case relation(String, String)
    case collective([String])
}

enum MemorySource {
    case local
    case federated(String)
    case synced(String)
}

// MARK: - Placeholder Types

struct EmptyMemoryContent: EnhancedMemoryContent {
    let id = UUID()
    let memoryType = "empty"
    let searchableText = ""
    let enhancedMetadata: [String: Any] = [:]
}

struct EmotionalContext {
    let primaryEmotion: String
    let intensity: Double
    let empathyLevel: Double
}

struct MutualConsent {
    let isValid: Bool
    let trustLevel: Double
    let timestamp: Date
}

struct ConflictResolution {
    let strategy: String
    let effectiveness: Double
    let timestamp: Date
}

struct ConsensusLevel {
    let value: Double
    let participants: [String]
    let timestamp: Date
}

struct MentorValidation {
    let isValid: Bool
    let mentorId: String
    let confidence: Double
    let timestamp: Date
}

struct FederationPolicy {
    let enabled: Bool
    let targetNodes: [String]
    
    static let none = FederationPolicy(enabled: false, targetNodes: [])
    static let agentSpecific = FederationPolicy(enabled: true, targetNodes: ["agent"])
    static let bilateral = FederationPolicy(enabled: true, targetNodes: ["bilateral"])
}
