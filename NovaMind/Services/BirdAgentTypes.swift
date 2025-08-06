import Foundation

// MARK: - Constitutional Gate Result

struct ConstitutionalGateResult {
    let success: Bool
    let details: [String]
    let ethicalViolations: [String]
}

// MARK: - Extended Bird Agent Capabilities

extension AgentCapability {
    static let performanceMonitoring = AgentCapability(rawValue: "performanceMonitoring")!
    static let latencyDetection = AgentCapability(rawValue: "latencyDetection")!
    static let benchmarking = AgentCapability(rawValue: "benchmarking")!
    static let memoryIntegrity = AgentCapability(rawValue: "memoryIntegrity")!
    static let driftCorrection = AgentCapability(rawValue: "driftCorrection")!
    static let dataValidation = AgentCapability(rawValue: "dataValidation")!
    static let cicdTrigger = AgentCapability(rawValue: "cicdTrigger")!
    static let deployment = AgentCapability(rawValue: "deployment")!
    static let refactorMonitoring = AgentCapability(rawValue: "refactorMonitoring")!
    static let uiTesting = AgentCapability(rawValue: "uiTesting")!
    static let visualDiffing = AgentCapability(rawValue: "visualDiffing")!
    static let pixelAnalysis = AgentCapability(rawValue: "pixelAnalysis")!
    static let deepAnalysis = AgentCapability(rawValue: "deepAnalysis")!
    static let correlationAnalysis = AgentCapability(rawValue: "correlationAnalysis")!
    static let systemMemory = AgentCapability(rawValue: "systemMemory")!
    static let rapidExecution = AgentCapability(rawValue: "rapidExecution")!
    static let oversight = AgentCapability(rawValue: "oversight")!
    static let reflection = AgentCapability(rawValue: "reflection")!
}

// MARK: - Extended Pipeline Stages

extension PipelineStage {
    static let documentationConsistencyAudit = PipelineStage(rawValue: "documentation_consistency_audit")!
    static let memoryIntegritySweep = PipelineStage(rawValue: "memory_integrity_sweep")!
    static let apiContractConformanceCheck = PipelineStage(rawValue: "api_contract_conformance_check")!
    static let performanceBenchmarkDiff = PipelineStage(rawValue: "performance_benchmark_diff")!
    static let guiPixelShiftDiff = PipelineStage(rawValue: "gui_pixel_shift_diff")!
    static let semanticRegressionReflection = PipelineStage(rawValue: "semantic_regression_reflection")!
    static let multiAgentConvergenceAssessment = PipelineStage(rawValue: "multi_agent_convergence_assessment")!
    static let mentorValidationAndCertification = PipelineStage(rawValue: "mentor_validation_and_certification")!
}

// MARK: - Mock Law Enforcer

class LawEnforcer {
    static let shared = LawEnforcer()
    
    private init() {}
    
    func getSystemComplianceReport() -> SystemComplianceReport {
        return SystemComplianceReport(
            recentViolations: [],
            compliance: ComplianceScore(overallScore: 0.95)
        )
    }
}

struct SystemComplianceReport {
    let recentViolations: [EthicalViolation]
    let compliance: ComplianceScore
}

struct ComplianceScore {
    let overallScore: Double
}

struct EthicalViolation {
    let description: String
    let status: ViolationStatus
}

enum ViolationStatus {
    case active, resolved
}
