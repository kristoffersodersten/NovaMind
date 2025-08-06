import Foundation

// MARK: - Core Bird Agent Types

struct BirdAgent {
    let id: String
    let species: BirdSpecies
    let status: AgentStatus
    let identityHash: String
    var currentTask: String?
    var memoryState: AgentMemoryState
    var ethicalAlignment: EthicalAlignment
    let createdAt: Date
    var lastHeartbeat: Date
    
    init(species: BirdSpecies, identityHash: String) {
        self.id = "\(species.name)-\(UUID().uuidString.prefix(8))"
        self.species = species
        self.status = .active
        self.identityHash = identityHash
        self.currentTask = nil
        self.memoryState = AgentMemoryState()
        self.ethicalAlignment = EthicalAlignment()
        self.createdAt = Date()
        self.lastHeartbeat = Date()
    }
    
    init(id: String, species: BirdSpecies, status: AgentStatus, identityHash: String,
         currentTask: String?, memoryState: AgentMemoryState, ethicalAlignment: EthicalAlignment,
         createdAt: Date, lastHeartbeat: Date) {
        self.id = id
        self.species = species
        self.status = status
        self.identityHash = identityHash
        self.currentTask = currentTask
        self.memoryState = memoryState
        self.ethicalAlignment = ethicalAlignment
        self.createdAt = createdAt
        self.lastHeartbeat = lastHeartbeat
    }
}

enum AgentStatus: String {
    case active
    case inactive
    case paused
    case error
}

struct BirdSpecies {
    let name: String
    let description: String
    let capabilities: [AgentCapability]
    let autonomyLevel: Int
    let specializations: [String]
    let memoryBinding: MemoryBinding
}

enum AgentCapability: String, CaseIterable {
    case unitTesting = "unit_testing"
    case memoryManagement = "memory_management"
    case rapidExecution = "rapid_execution"
    case strategicAnalysis = "strategic_analysis"
    case patternRecognition = "pattern_recognition"
    case oversight = "oversight"
    case semanticAnalysis = "semantic_analysis"
    case documentation = "documentation"
    case reflection = "reflection"
    case performanceMonitoring = "performance_monitoring"
    case latencyDetection = "latency_detection"
    case benchmarking = "benchmarking"
    case memoryIntegrity = "memory_integrity"
    case driftCorrection = "drift_correction"
    case dataValidation = "data_validation"
    case cicdTrigger = "cicd_trigger"
    case deployment = "deployment"
    case refactorMonitoring = "refactor_monitoring"
    case uiTesting = "ui_testing"
    case visualDiffing = "visual_diffing"
    case pixelAnalysis = "pixel_analysis"
    case deepAnalysis = "deep_analysis"
    case correlationAnalysis = "correlation_analysis"
    case systemMemory = "system_memory"
    case ethicalAuditing = "ethical_auditing"
    case documentationReview = "documentation_review"
    case qualityAssurance = "quality_assurance"
    case integrationTesting = "integration_testing"
    case performanceOptimization = "performance_optimization"
    case securityAuditing = "security_auditing"
    case complianceValidation = "compliance_validation"
    case deploymentManagement = "deployment_management"
    case rollbackCapability = "rollback_capability"
    case monitoringAndAlerting = "monitoring_alerting"
}

struct MemoryBinding {
    let mode: MemoryBindingMode
    let stores: [MemoryStore]
}

enum MemoryBindingMode: String {
    case perEntity = "per_entity"
    case collective = "collective"
    case hybrid = "hybrid"
}

enum MemoryStore: String {
    case shortTerm = "short_term"
    case longTerm = "long_term"
    case collective = "collective"
    case relationBound = "relation_bound"
    case collectiveMesh = "collective_mesh"
}

// MARK: - Pipeline Types

enum PipelineStatus: String {
    case idle
    case running
    case success
    case failed
    case paused
}

enum TriggerCondition: String {
    case codeCommit = "code_commit"
    case pullRequest = "pull_request"
    case scheduleRun = "schedule_run"
    case manualTrigger = "manual_trigger"
    case emergencyDeploy = "emergency_deploy"
}

enum PipelineStage: String, CaseIterable {
    case preflightReflection = "preflight_reflection"
    case documentationAudit = "documentation_audit"
    case memoryIntegritySweep = "memory_integrity_sweep"
    case buildAndLint = "build_and_lint"
    case fullTestSuite = "full_test_suite"
    case constitutionalGate = "constitutional_gate"
    case deploymentPreparation = "deployment_preparation"
    case postDeploymentValidation = "post_deployment_validation"
}

struct StageResult {
    let stage: PipelineStage
    let success: Bool
    let executionTime: TimeInterval
    let details: [String]
    let ethicalViolations: [String]
    let timestamp: Date
}

struct StageProcessResult {
    let success: Bool
    let details: [String]
    let executionTime: TimeInterval
    let ethicalViolations: [String]
}

// MARK: - Agent State and Performance Types

struct AgentMemoryState {
    var shortTermMemory: [String: Any] = [:]
    var relationBoundMemory: [String: Any] = [:]
    var collectiveMeshMemory: [String: Any] = [:]
}

struct EthicalAlignment {
    var respectAsConstant: Bool = true
    var diversityAsStrength: Bool = true
    var semanticIntegrity: Bool = true
    var noSilentFailures: Bool = true
    var emergentAccountability: Bool = true
}

struct AgentPerformanceMetrics {
    let agentId: String
    let species: String
    var tasksCompleted: Int
    var averageExecutionTime: TimeInterval
    var successRate: Double
    var ethicalViolations: Int
    var lastActive: Date
}

struct EthicalComplianceStatus {
    var totalViolations: Int = 0
    var lastViolation: Date?
    var complianceScore: Double = 1.0
    var ethicalFrameworkVersion: String = "1.0.0"
}

// MARK: - String Extension for SHA512

extension String {
    func sha512() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(64))

        data.withUnsafeBytes { _ in
            // Simplified hash - in production use CryptoKit
            let simpleHash = abs(self.hashValue)
            let hashString = String(simpleHash, radix: 16)
            return hashString.padding(toLength: 64, withPad: "0", startingAt: 0)
        }

        return String(format: "%02x", digest).prefix(64).description
    }
}
