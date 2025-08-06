import Foundation

// MARK: - Ecosystem Validation Types and Models

// MARK: - Enums

enum ValidationStatus: String, CaseIterable {
    case notStarted
    case inProgress
    case completed
    case failed
}

enum ValidationCategory: String, CaseIterable {
    case mentorship
    case resonance
    case coralReef
    case constitutional
}

enum TestStatus: String, CaseIterable {
    case notStarted
    case inProgress
    case passed
    case failed
}

enum TestImportance: String, CaseIterable {
    case low
    case medium
    case high
    case critical
}

enum EntityType: String, CaseIterable, Codable {
    case mentor
    case agent
    case coralNode
    case law
}

enum EntityStatus: String, CaseIterable, Codable {
    case active
    case inactive
    case degraded
    case failed
}

enum ConnectionType: String, CaseIterable, Codable {
    case mentorAgent
    case agentCoral
    case coralCoral
    case lawEnforcement
}

// MARK: - Core Data Structures

struct ValidationResult {
    let component: String
    let category: ValidationCategory
    let status: TestStatus
    let timestamp: Date
    let details: [ValidationDetail]
    let score: Double
}

struct ValidationDetail {
    let test: String
    let passed: Bool
    let message: String
    let importance: TestImportance
}

struct EcosystemMap: Codable {
    let mentors: [EcosystemEntity]
    let agents: [EcosystemEntity]
    let coralNodes: [EcosystemEntity]
    let laws: [EcosystemEntity]
    let overallHealth: Double
    let generatedAt: Date
}

struct EcosystemEntity: Identifiable, Codable {
    let id: String
    let type: EntityType
    let status: EntityStatus
    let connections: [String]
    let health: Double
    let metadata: [String: String]
}

struct ResonantValidationReport: Codable {
    let validationId: String
    let timestamp: Date
    let overallScore: Double
    let componentScores: [String: Double]
    let criticalFindings: [ValidationDetail]
    let recommendations: [String]
    let nextValidationDate: Date
}

struct EntityMemoryMap: Codable {
    let entities: [EcosystemEntity]
    let memoryConnections: [MemoryConnection]
    let memoryHealth: Double
    let lastUpdated: Date
}

struct MemoryConnection: Codable {
    let sourceId: String
    let targetId: String
    let connectionType: ConnectionType
    let strength: Double
    let lastActive: Date
}

// MARK: - Validation Context

struct ValidationContext {
    let mentorRegistry: MentorRegistry
    let resonanceRadar: AgentResonanceRadar
    let coralEngine: CoralEngine
    let lawEnforcer: LawEnforcer
    
    init() {
        self.mentorRegistry = MentorRegistry.shared
        self.resonanceRadar = AgentResonanceRadar.shared
        self.coralEngine = CoralEngine.shared
        self.lawEnforcer = LawEnforcer.shared
    }
}
