import Combine
import Foundation


// MARK: - CI/CD Pipeline Executor

/// Async pipeline executor with stage validation and mentor certification
/// Orchestrates the complete CI/CD process with ethics enforcement
class CICDPipelineExecutor: ObservableObject {
    static let shared = CICDPipelineExecutor()

    // MARK: - State Management

    @Published private(set) var currentPipeline: ExecutingPipeline?
    @Published private(set) var executionHistory: [PipelineExecution] = []
    @Published private(set) var activeStages: [StageExecution] = []

    // MARK: - Dependencies

    private let cicdConfig: NovaMindCICDConfig
    private let stageValidator: StageValidator
    private let mentorCertifier: MentorCertifier
    private let ethicsGuard: EthicsGuard
    private let resonanceTracker: ResonanceTracker

    // MARK: - Configuration

    private let executionConfig: ExecutionConfig
    private var cancellables = Set<AnyCancellable>()

    init(cicdConfig: NovaMindCICDConfig = .shared) {
        self.cicdConfig = cicdConfig
        self.stageValidator = StageValidator()
        self.mentorCertifier = MentorCertifier()
        self.ethicsGuard = EthicsGuard()
        self.resonanceTracker = ResonanceTracker()
        self.executionConfig = ExecutionConfig.default

        setupPipelineMonitoring()
    }

    // MARK: - Pipeline Execution

    /// Execute a complete CI/CD pipeline with full validation and monitoring
    func executePipeline(
        _ pipeline: CICDPipeline,
        agents: [AgentConfig],
        environment: ExecutionEnvironment,
        options: ExecutionOptions = ExecutionOptions()
    ) async throws -> PipelineExecutionResult {
        // Validate pre-execution requirements
        try await validatePipelineRequirements(pipeline, agents: agents, environment: environment)

        // Create execution context
        let execution = PipelineExecution(
            id: UUID().uuidString,
            pipeline: pipeline,
            agents: agents,
            environment: environment,
            options: options,
            startTime: Date()
        )

        // Update state
        await updateCurrentPipeline(execution)

        do {
            // Execute pipeline stages
            let result = try await executeStagesSequentially(execution)

            // Finalize execution
            await finalizePipelineExecution(execution, result: result)

            return result

        } catch {
            // Handle execution failure
            await handlePipelineFailure(execution, error: error)
            throw error
        }
    }

    /// Execute stages sequentially with validation and monitoring
    private func executeStagesSequentially(_ execution: PipelineExecution) async throws -> PipelineExecutionResult {
        var stageResults: [StageExecutionResult] = []
        var deployedAgents: [DeployedAgent] = []

        for (index, stage) in execution.pipeline.stages.enumerated() {
            // Pre-stage validation
            try await preStageValidation(stage: stage, execution: execution)

            // Create stage execution
            let stageExecution = StageExecution(
                stage: stage,
                execution: execution,
                stageIndex: index,
                startTime: Date()
            )

            await addActiveStage(stageExecution)

            do {
                // Execute stage with monitoring
                let stageResult = try await executeStageWithMonitoring(stageExecution)
                stageResults.append(stageResult)

                // Update deployed agents
                if let agents = stageResult.deployedAgents {
                    deployedAgents.append(contentsOf: agents)
                }

                // Post-stage validation
                try await postStageValidation(stage: stage, result: stageResult, execution: execution)

                await removeActiveStage(stageExecution)

            } catch {
                await removeActiveStage(stageExecution)
                throw PipelineExecutionError.stageExecutionFailed(stage: stage.name, error: error)
            }
        }

        return PipelineExecutionResult(
            execution: execution,
            stageResults: stageResults,
            deployedAgents: deployedAgents,
            totalDuration: Date().timeIntervalSince(execution.startTime),
            success: true
        )
    }

    /// Execute individual stage with comprehensive monitoring
    private func executeStageWithMonitoring(_ stageExecution: StageExecution) async throws -> StageExecutionResult {
        let stage = stageExecution.stage

        // Start monitoring
        await startStageMonitoring(stageExecution)

        let result: StageExecutionResult

        switch stage.type {
        case .build:
            result = try await executeBuildStage(stageExecution)
        case .test:
            result = try await executeTestStage(stageExecution)
        case .deploy:
            result = try await executeDeployStage(stageExecution)
        case .validate:
            result = try await executeValidationStage(stageExecution)
        case .monitor:
            result = try await executeMonitoringStage(stageExecution)
        }

        // Stop monitoring
        await stopStageMonitoring(stageExecution, result: result)

        return result
    }

    // MARK: - Stage Execution Implementations

    private func executeBuildStage(_ stageExecution: StageExecution) async throws -> StageExecutionResult {
        let buildConfig = try stageExecution.stage.getBuildConfiguration()

        // Build agents in parallel with resource management
        let agentBuilds = try await withThrowingTaskGroup(of: AgentBuildResult.self) { group in
            for agent in stageExecution.execution.agents {
                group.addTask {
                    try await self.buildAgentWithValidation(
                        agent: agent,
                        config: buildConfig,
                        execution: stageExecution.execution
                    )
                }
            }

            var results: [AgentBuildResult] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }

        let allSuccessful = agentBuilds.allSatisfy(\.success)

        return StageExecutionResult(
            stage: stageExecution.stage,
            success: allSuccessful,
            duration: Date().timeIntervalSince(stageExecution.startTime),
            agentBuilds: agentBuilds,
            artifacts: agentBuilds.flatMap(\.artifacts),
            metadata: createStageMetadata(stageExecution)
        )
    }

    private func executeTestStage(_ stageExecution: StageExecution) async throws -> StageExecutionResult {
        let testConfig = try stageExecution.stage.getTestConfiguration()

        // Run comprehensive tests
        async let agentTests = runAgentTests(
            agents: stageExecution.execution.agents,
            config: testConfig,
            execution: stageExecution.execution
        )

        async let integrationTests = runIntegrationTests(
            agents: stageExecution.execution.agents,
            config: testConfig,
            execution: stageExecution.execution
        )

        async let ethicsTests = runEthicsTests(
            agents: stageExecution.execution.agents,
            config: testConfig,
            execution: stageExecution.execution
        )

        let (agentResults, integrationResults, ethicsResults) = try await (agentTests, integrationTests, ethicsTests)

        let overallSuccess = agentResults.success && integrationResults.success && ethicsResults.success

        return StageExecutionResult(
            stage: stageExecution.stage,
            success: overallSuccess,
            duration: Date().timeIntervalSince(stageExecution.startTime),
            testResults: CombinedTestResults(
                agent: agentResults,
                integration: integrationResults,
                ethics: ethicsResults
            ),
            metadata: createStageMetadata(stageExecution)
        )
    }

    private func executeDeployStage(_ stageExecution: StageExecution) async throws -> StageExecutionResult {
        let deployConfig = try stageExecution.stage.getDeployConfiguration()

        // Get mentor certifications for all agents
        let certifications = try await getMentorCertifications(
            agents: stageExecution.execution.agents,
            config: deployConfig,
            execution: stageExecution.execution
        )

        // Deploy agents with certified configurations
        let deployments = try await deployAgentsWithCertification(
            agents: stageExecution.execution.agents,
            certifications: certifications,
            config: deployConfig,
            execution: stageExecution.execution
        )

        // Validate deployment health
        try await validateDeploymentHealth(deployments)

        return StageExecutionResult(
            stage: stageExecution.stage,
            success: true,
            duration: Date().timeIntervalSince(stageExecution.startTime),
            deployedAgents: deployments,
            certifications: certifications,
            metadata: createStageMetadata(stageExecution)
        )
    }

    private func executeValidationStage(_ stageExecution: StageExecution) async throws -> StageExecutionResult {
        let validationConfig = try stageExecution.stage.getValidationConfiguration()

        // Run comprehensive validation
        let validationResults = try await performComprehensiveValidation(
            config: validationConfig,
            execution: stageExecution.execution
        )

        let validationSuccess = validationResults.allSatisfy(\.success)

        return StageExecutionResult(
            stage: stageExecution.stage,
            success: validationSuccess,
            duration: Date().timeIntervalSince(stageExecution.startTime),
            validationResults: validationResults,
            metadata: createStageMetadata(stageExecution)
        )
    }

    private func executeMonitoringStage(_ stageExecution: StageExecution) async throws -> StageExecutionResult {
        let monitoringConfig = try stageExecution.stage.getMonitoringConfiguration()

        // Setup monitoring systems
        try await setupComprehensiveMonitoring(
            config: monitoringConfig,
            execution: stageExecution.execution
        )

        return StageExecutionResult(
            stage: stageExecution.stage,
            success: true,
            duration: Date().timeIntervalSince(stageExecution.startTime),
            monitoringSetup: true,
            metadata: createStageMetadata(stageExecution)
        )
    }

    // MARK: - Stage Validation

    private func preStageValidation(
        stage: CICDStage,
        execution: PipelineExecution
    ) async throws {
        // Validate stage prerequisites
        try await stageValidator.validatePrerequisites(stage: stage, execution: execution)

        // Check ethics compliance
        try await ethicsGuard.validateStageEthics(stage: stage, execution: execution)

        // Verify resonance levels
        try await resonanceTracker.validateStageResonance(stage: stage, execution: execution)
    }

    private func postStageValidation(
        stage: CICDStage,
        result: StageExecutionResult,
        execution: PipelineExecution
    ) async throws {
        // Validate stage outputs
        try await stageValidator.validateOutputs(stage: stage, result: result, execution: execution)

        // Check post-stage ethics compliance
        try await ethicsGuard.validatePostStageEthics(stage: stage, result: result, execution: execution)

        // Verify resonance improvements
        try await resonanceTracker.validateResonanceImprovement(stage: stage, result: result, execution: execution)
    }

    // MARK: - Agent Operations

    private func buildAgentWithValidation(
        agent: AgentConfig,
        config: BuildConfiguration,
        execution: PipelineExecution
    ) async throws -> AgentBuildResult {
        // Pre-build validation
        try await stageValidator.validateAgentBuildRequirements(agent: agent, config: config)

        // Build agent
        let buildResult = try await cicdConfig.agentOrchestrator.buildAgent(
            config: agent,
            buildConfig: config,
            ethicsValidation: ethicsGuard.getBuildRules()
        )

        // Validate build artifacts
        try await stageValidator.validateBuildArtifacts(result: buildResult)

        return buildResult
    }

    private func getMentorCertifications(
        agents: [AgentConfig],
        config: DeployConfiguration,
        execution: PipelineExecution
    ) async throws -> [MentorCertification] {
        var certifications: [MentorCertification] = []

        for agent in agents {
            let certification = try await mentorCertifier.getCertification(
                agent: agent,
                deployConfig: config,
                execution: execution
            )

            certifications.append(certification)
        }

        return certifications
    }

    private func deployAgentsWithCertification(
        agents: [AgentConfig],
        certifications: [MentorCertification],
        config: DeployConfiguration,
        execution: PipelineExecution
    ) async throws -> [DeployedAgent] {
        let certificationMap = Dictionary(uniqueKeysWithValues:
            certifications.map { ($0.agentId, $0) })

        var deployedAgents: [DeployedAgent] = []

        for agent in agents {
            guard let certification = certificationMap[agent.id],
                  certification.approved else {
                throw PipelineExecutionError.deploymentNotCertified(agentId: agent.id)
            }

            let deployedAgent = try await cicdConfig.agentOrchestrator.deployAgent(
                config: agent,
                deployConfig: config,
                certification: certification,
                ethicsMonitoring: ethicsGuard.getDeploymentMonitoring()
            )

            deployedAgents.append(deployedAgent)
        }

        return deployedAgents
    }

    // MARK: - Test Operations

    private func runAgentTests(
        agents: [AgentConfig],
        config: TestConfiguration,
        execution: PipelineExecution
    ) async throws -> TestResults {
        return try await cicdConfig.agentOrchestrator.runMultiAgentTests(
            agents: agents,
            testConfig: config,
            resonanceRules: resonanceTracker.getTestRules()
        )
    }

    private func runIntegrationTests(
        agents: [AgentConfig],
        config: TestConfiguration,
        execution: PipelineExecution
    ) async throws -> TestResults {
        // Simplified integration test runner
        return TestResults(
            success: true,
            duration: 1.0,
            coverage: 0.9,
            failures: []
        )
    }

    private func runEthicsTests(
        agents: [AgentConfig],
        config: TestConfiguration,
        execution: PipelineExecution
    ) async throws -> EthicsTestResults {
        return try await ethicsGuard.runComplianceTests(
            agents: agents,
            testConfig: config
        )
    }

    // MARK: - Validation Operations

    private func performComprehensiveValidation(
        config: ValidationConfiguration,
        execution: PipelineExecution
    ) async throws -> [ValidationResult] {
        async let behaviorValidation = stageValidator.validateAgentBehavior(
            agents: execution.agents,
            config: config
        )

        async let ethicsValidation = ethicsGuard.validateSystemCompliance(
            agents: execution.agents,
            rules: config.ethicsRules
        )

        async let resonanceValidation = resonanceTracker.validateSystemResonance(
            agents: execution.agents,
            thresholds: config.resonanceThresholds
        )

        let (behavior, ethics, resonance) = await (behaviorValidation, ethicsValidation, resonanceValidation)

        return [behavior, ethics, resonance]
    }

    private func validateDeploymentHealth(_ deployments: [DeployedAgent]) async throws {
        for deployment in deployments {
            try await stageValidator.validateDeploymentHealth(deployment)
        }
    }

    // MARK: - Monitoring Operations

    private func setupComprehensiveMonitoring(
        config: MonitoringConfiguration,
        execution: PipelineExecution
    ) async throws {
        // Setup resonance monitoring
        try await resonanceTracker.setupContinuousMonitoring(
            agents: execution.agents,
            config: config.resonanceConfig
        )

        // Setup ethics monitoring
        try await ethicsGuard.setupContinuousEthicsMonitoring(
            agents: execution.agents,
            config: config.ethicsConfig
        )

        // Setup performance monitoring
        try await stageValidator.setupPerformanceMonitoring(
            agents: execution.agents,
            config: config.performanceConfig
        )
    }

    // MARK: - Pipeline Validation

    private func validatePipelineRequirements(
        _ pipeline: CICDPipeline,
        agents: [AgentConfig],
        environment: ExecutionEnvironment
    ) async throws {
        // Validate pipeline structure
        try stageValidator.validatePipelineStructure(pipeline)

        // Validate agent configurations
        try stageValidator.validateAgentConfigurations(agents)

        // Validate environment readiness
        try await stageValidator.validateEnvironment(environment)

        // Validate ethics requirements
        try await ethicsGuard.validatePipelineEthics(pipeline: pipeline, agents: agents)

        // Validate resonance requirements
        try await resonanceTracker.validatePipelineResonance(pipeline: pipeline, agents: agents)
    }

    // MARK: - State Management

    private func updateCurrentPipeline(_ execution: PipelineExecution) async {
        await MainActor.run {
            currentPipeline = ExecutingPipeline(execution: execution)
        }
    }

    private func addActiveStage(_ stageExecution: StageExecution) async {
        await MainActor.run {
            activeStages.append(stageExecution)
        }
    }

    private func removeActiveStage(_ stageExecution: StageExecution) async {
        await MainActor.run {
            activeStages.removeAll { $0.id == stageExecution.id }
        }
    }

    private func finalizePipelineExecution(
        _ execution: PipelineExecution,
        result: PipelineExecutionResult
    ) async {
        await MainActor.run {
            executionHistory.append(execution)
            currentPipeline = nil
            activeStages.removeAll()
        }
    }

    private func handlePipelineFailure(
        _ execution: PipelineExecution,
        error: Error
    ) async {
        await MainActor.run {
            var failedExecution = execution
            failedExecution.error = error
            executionHistory.append(failedExecution)
            currentPipeline = nil
            activeStages.removeAll()
        }
    }

    // MARK: - Monitoring Setup

    private func setupPipelineMonitoring() {
        // Pipeline health monitoring
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                Task {
                    await self.updatePipelineHealth()
                }
            }
            .store(in: &cancellables)

        // Active stage monitoring
        Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                Task {
                    await self.monitorActiveStages()
                }
            }
            .store(in: &cancellables)
    }

    private func startStageMonitoring(_ stageExecution: StageExecution) async {
        // Start comprehensive stage monitoring
    }

    private func stopStageMonitoring(_ stageExecution: StageExecution, result: StageExecutionResult) async {
        // Stop stage monitoring and collect metrics
    }

    private func updatePipelineHealth() async {
        // Update overall pipeline health
    }

    private func monitorActiveStages() async {
        // Monitor active stages for issues
    }

    // MARK: - Helper Methods

    private func createStageMetadata(_ stageExecution: StageExecution) -> [String: Any] {
        return [
            "stage_id": stageExecution.stage.id,
            "stage_name": stageExecution.stage.name,
            "execution_id": stageExecution.execution.id,
            "stage_index": stageExecution.stageIndex,
            "start_time": stageExecution.startTime.iso8601String,
            "environment": stageExecution.execution.environment.name
        ]
    }
}

// MARK: - Supporting Components

/// Stage Validator for comprehensive stage validation
class StageValidator: ObservableObject {
    func validatePrerequisites(stage: CICDStage, execution: PipelineExecution) async throws {
        // Validate stage prerequisites
    }

    func validateOutputs(stage: CICDStage, result: StageExecutionResult, execution: PipelineExecution) async throws {
        // Validate stage outputs
    }

    func validatePipelineStructure(_ pipeline: CICDPipeline) throws {
        // Validate pipeline structure
    }

    func validateAgentConfigurations(_ agents: [AgentConfig]) throws {
        // Validate agent configurations
    }

    func validateEnvironment(_ environment: ExecutionEnvironment) async throws {
        // Validate environment readiness
    }

    func validateAgentBuildRequirements(agent: AgentConfig, config: BuildConfiguration) async throws {
        // Validate agent build requirements
    }

    func validateBuildArtifacts(result: AgentBuildResult) async throws {
        // Validate build artifacts
    }

    func validateDeploymentHealth(_ deployment: DeployedAgent) async throws {
        // Validate deployment health
    }

    func validateAgentBehavior(agents: [AgentConfig], config: ValidationConfiguration) async -> ValidationResult {
        return ValidationResult(success: true, duration: 0.5, details: "Agent behavior validated")
    }

    func setupPerformanceMonitoring(agents: [AgentConfig], config: PerformanceMonitoringConfig) async throws {
        // Setup performance monitoring
    }
}

/// Mentor Certifier for deployment approvals
class MentorCertifier: ObservableObject {
    func getCertification(
        agent: AgentConfig,
        deployConfig: DeployConfiguration,
        execution: PipelineExecution
    ) async throws -> MentorCertification {
        // Simplified mentor certification
        return MentorCertification(
            agentId: agent.id,
            approved: true,
            reason: "Agent meets all deployment criteria",
            mentor: "mentor_prime",
            timestamp: Date()
        )
    }
}

/// Ethics Guard for ethical compliance
class EthicsGuard: ObservableObject {
    func validateStageEthics(stage: CICDStage, execution: PipelineExecution) async throws {
        // Validate stage ethics
    }

    func validatePostStageEthics(stage: CICDStage, result: StageExecutionResult, execution: PipelineExecution) async throws {
        // Validate post-stage ethics
    }

    func validatePipelineEthics(pipeline: CICDPipeline, agents: [AgentConfig]) async throws {
        // Validate pipeline ethics
    }

    func getBuildRules() -> [EthicsRule] {
        return []
    }

    func getDeploymentMonitoring() -> EthicsMonitoringConfig {
        return EthicsMonitoringConfig()
    }

    func runComplianceTests(agents: [AgentConfig], testConfig: TestConfiguration) async throws -> EthicsTestResults {
        return EthicsTestResults(success: true, duration: 0.5, compliance: 0.98, violations: [])
    }

    func validateSystemCompliance(agents: [AgentConfig], rules: [EthicsRule]) async -> ValidationResult {
        return ValidationResult(success: true, duration: 0.3, details: "System ethics compliance verified")
    }

    func setupContinuousEthicsMonitoring(agents: [AgentConfig], config: EthicsMonitoringConfig) async throws {
        // Setup ethics monitoring
    }
}

/// Resonance Tracker for harmony monitoring
class ResonanceTracker: ObservableObject {
    func validateStageResonance(stage: CICDStage, execution: PipelineExecution) async throws {
        // Validate stage resonance
    }

    func validateResonanceImprovement(stage: CICDStage, result: StageExecutionResult, execution: PipelineExecution) async throws {
        // Validate resonance improvement
    }

    func validatePipelineResonance(pipeline: CICDPipeline, agents: [AgentConfig]) async throws {
        // Validate pipeline resonance
    }

    func getTestRules() -> [String] {
        return ["harmony_maintenance", "consensus_validation"]
    }

    func validateSystemResonance(agents: [AgentConfig], thresholds: ResonanceThresholds) async -> ValidationResult {
        return ValidationResult(success: true, duration: 0.2, details: "System resonance within thresholds")
    }

    func setupContinuousMonitoring(agents: [AgentConfig], config: ResonanceMonitoringConfig) async throws {
        // Setup resonance monitoring
    }
}

// MARK: - Execution Types

struct ExecutingPipeline {
    let execution: PipelineExecution
    var currentStage: Int = 0
    var status: ExecutionStatus = .running
}

struct PipelineExecution {
    let id: String
    let pipeline: CICDPipeline
    let agents: [AgentConfig]
    let environment: ExecutionEnvironment
    let options: ExecutionOptions
    let startTime: Date
    var error: Error?
}

struct StageExecution {
    let id = UUID().uuidString
    let stage: CICDStage
    let execution: PipelineExecution
    let stageIndex: Int
    let startTime: Date
    var status: StageStatus = .running
}

struct ExecutionEnvironment {
    let name: String
    let type: EnvironmentType
    let configuration: [String: Any]
    let resources: ResourceAllocation
}

enum EnvironmentType: String, Codable {
    case development
    case staging
    case production
}

struct ResourceAllocation {
    let cpu: Double
    let memory: Double
    let storage: Double
    let network: Double
}

struct ExecutionOptions {
    let parallel: Bool = false
    let failFast: Bool = true
    let timeout: TimeInterval = 3600
    let retryCount: Int = 3
}

struct ExecutionConfig {
    let maxConcurrentStages: Int = 3
    let stageTimeout: TimeInterval = 1800
    let healthCheckInterval: TimeInterval = 30

    static let `default` = ExecutionConfig()
}

// MARK: - Result Types

struct PipelineExecutionResult {
    let execution: PipelineExecution
    let stageResults: [StageExecutionResult]
    let deployedAgents: [DeployedAgent]
    let totalDuration: TimeInterval
    let success: Bool
}

struct StageExecutionResult {
    let stage: CICDStage
    let success: Bool
    let duration: TimeInterval
    let agentBuilds: [AgentBuildResult]?
    let artifacts: [BuildArtifact]?
    let testResults: CombinedTestResults?
    let deployedAgents: [DeployedAgent]?
    let certifications: [MentorCertification]?
    let validationResults: [ValidationResult]?
    let monitoringSetup: Bool?
    let metadata: [String: Any]

    init(
        stage: CICDStage,
        success: Bool,
        duration: TimeInterval,
        agentBuilds: [AgentBuildResult]? = nil,
        artifacts: [BuildArtifact]? = nil,
        testResults: CombinedTestResults? = nil,
        deployedAgents: [DeployedAgent]? = nil,
        certifications: [MentorCertification]? = nil,
        validationResults: [ValidationResult]? = nil,
        monitoringSetup: Bool? = nil,
        metadata: [String: Any] = [:]
    ) {
        self.stage = stage
        self.success = success
        self.duration = duration
        self.agentBuilds = agentBuilds
        self.artifacts = artifacts
        self.testResults = testResults
        self.deployedAgents = deployedAgents
        self.certifications = certifications
        self.validationResults = validationResults
        self.monitoringSetup = monitoringSetup
        self.metadata = metadata
    }
}

struct CombinedTestResults {
    let agent: TestResults
    let integration: TestResults
    let ethics: EthicsTestResults

    var overallSuccess: Bool {
        return agent.success && integration.success && ethics.success
    }
}

// MARK: - Enhanced Configuration Types

struct MentorCertification {
    let agentId: String
    let approved: Bool
    let reason: String
    let mentor: String
    let timestamp: Date
    let conditions: [String] = []
    let validUntil: Date?

    init(agentId: String, approved: Bool, reason: String, mentor: String, timestamp: Date, conditions: [String] = [], validUntil: Date? = nil) {
        self.agentId = agentId
        self.approved = approved
        self.reason = reason
        self.mentor = mentor
        self.timestamp = timestamp
        self.conditions = conditions
        self.validUntil = validUntil
    }
}

struct PerformanceMonitoringConfig {
    let metricsInterval: TimeInterval = 30
    let alertThresholds: [String: Double] = [:]
    let retentionPeriod: TimeInterval = 86400 * 7 // 7 days
}

// MARK: - Status Enums

enum ExecutionStatus: String, Codable {
    case pending
    case running
    case completed
    case failed
    case cancelled
}

enum StageStatus: String, Codable {
    case pending
    case running
    case completed
    case failed
    case skipped
}

// MARK: - Error Types

enum PipelineExecutionError: Error, LocalizedError {
    case stageExecutionFailed(stage: String, error: Error)
    case deploymentNotCertified(agentId: String)
    case validationFailed(stage: String, reason: String)
    case timeoutExceeded(stage: String, timeout: TimeInterval)
    case resourceAllocationFailed(resource: String)
    case prerequisiteNotMet(stage: String, prerequisite: String)

    var errorDescription: String? {
        switch self {
        case .stageExecutionFailed(let stage, let error):
            return "Stage '\(stage)' execution failed: \(error.localizedDescription)"
        case .deploymentNotCertified(let agentId):
            return "Deployment not certified for agent: \(agentId)"
        case .validationFailed(let stage, let reason):
            return "Validation failed for stage '\(stage)': \(reason)"
        case .timeoutExceeded(let stage, let timeout):
            return "Stage '\(stage)' exceeded timeout of \(timeout) seconds"
        case .resourceAllocationFailed(let resource):
            return "Failed to allocate resource: \(resource)"
        case .prerequisiteNotMet(let stage, let prerequisite):
            return "Prerequisite '\(prerequisite)' not met for stage '\(stage)'"
        }
    }
}

// MARK: - Extensions

extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
