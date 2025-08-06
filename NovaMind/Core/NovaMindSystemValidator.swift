import Foundation


// MARK: - System Validator
class NovaMindSystemValidator {
    private let config: NovaMindEcosystemConfig

    init(config: NovaMindEcosystemConfig) {
        self.config = config
    }

    func validateSystem() -> ValidationResult {
        var issues: [String] = []

        // Validate all layers
        validateMentorshipLayer(&issues)
        validateMemoryArchitecture(&issues)
        validateCoralReefArchitecture(&issues)
        validateCoreDoctrines(&issues)
        validateAIAgents(&issues)
        validateCICDPipeline(&issues)

        return ValidationResult(
            isValid: issues.isEmpty,
            issues: issues,
            resonanceScore: calculateResonanceScore()
        )
    }

    private func validateMentorshipLayer(_ issues: inout [String]) {
        // Check if required files exist
        for file in config.requiredLayers.mentorshipLayer.mustExist where !fileExists(file) {
            issues.append("Missing mentorship file: \(file)")
        }

        // Check requirements
        for requirement in config.requiredLayers.mentorshipLayer.requirements where !requirementMet(requirement) {
            issues.append("Mentorship requirement not met: \(requirement)")
        }
    }

    private func validateMemoryArchitecture(_ issues: inout [String]) {
        // Validate entity-specific memory
        for file in config.requiredLayers.memoryArchitecture.entitySpecific.mustHave where !fileExists(file) {
            issues.append("Missing memory file: \(file)")
        }

        // Validate collective memory location
        let collectiveMemoryLocation = config.requiredLayers.memoryArchitecture.collectiveMemory.location
        if !fileExists(collectiveMemoryLocation) {
            issues.append("Collective memory store not found: \(collectiveMemoryLocation)")
        }
    }

    private func validateCoralReefArchitecture(_ issues: inout [String]) {
        // Check required files
        for file in config.requiredLayers.coralReefArchitecture.filesRequired where !fileExists(file) {
            issues.append("Missing coral reef file: \(file)")
        }

        // Validate structure
        let structure = config.requiredLayers.coralReefArchitecture.structure
        if !structure.selfHealing {
            issues.append("Self-healing not enabled in coral reef architecture")
        }

        if !structure.agentMigration {
            issues.append("Agent migration not allowed in coral reef architecture")
        }
    }

    private func validateCoreDoctrines(_ issues: inout [String]) {
        // Check required files
        for file in config.requiredLayers.coreDoctrines.mustExist where !fileExists(file) {
            issues.append("Missing core doctrine file: \(file)")
        }

        // Validate checks
        let checks = config.requiredLayers.coreDoctrines.checks
        if !checks.entityHasRights {
            issues.append("Entity rights not enforced")
        }

        if checks.semanticViolationCount > 0 {
            issues.append("Semantic violations detected: \(checks.semanticViolationCount)")
        }

        // Parse agent conflict resolution rate
        if let rate = parsePercentage(checks.agentConflictResolutionRate), rate < 95.0 {
            issues.append("Agent conflict resolution rate too low: \(rate)%")
        }
    }

    private func validateAIAgents(_ issues: inout [String]) {
        // Check minimum required agents
        for agent in config.requiredLayers.aiAgents.minimumRequired where !agentAvailable(agent) {
            issues.append("Required AI agent not available: \(agent)")
        }

        // Validate fallback handling
        let fallback = config.requiredLayers.aiAgents.fallbackHandling
        if fallback.semanticDegradationTolerance != "0%" {
            issues.append("Semantic degradation tolerance not zero: \(fallback.semanticDegradationTolerance)")
        }

        // Validate routing logic
        let routing = config.requiredLayers.aiAgents.routingLogic
        if !fileExists(routing.via) {
            issues.append("Routing coordinator not found: \(routing.via)")
        }
    }

    private func validateCICDPipeline(_ issues: inout [String]) {
        // Check required files
        for file in config.requiredLayers.cicdPipeline.requiredFiles where !fileExists(file) {
            issues.append("Missing CI/CD file: \(file)")
        }

        // Validate enforced stages
        let stages = config.requiredLayers.cicdPipeline.enforcedStages
        if stages.isEmpty {
            issues.append("No enforced CI/CD stages defined")
        }

        // Validate pipeline config
        let pipelineConfig = config.requiredLayers.cicdPipeline.pipelines
        if !pipelineConfig.aiApprovalRequired {
            issues.append("AI approval not required in CI/CD pipeline")
        }
    }

    private func calculateResonanceScore() -> Double {
        // Sophisticated resonance score calculation
        var score = 100.0

        // Collect all required files
        let allRequiredFiles = getAllRequiredFiles()

        // Deduct for missing files
        for file in allRequiredFiles where !fileExists(file) {
            score -= 2.0
        }

        // Deduct for semantic violations
        score -= Double(config.requiredLayers.coreDoctrines.checks.semanticViolationCount) * 5.0

        // Bonus for self-healing coral reef
        if config.requiredLayers.coralReefArchitecture.structure.selfHealing {
            score += 5.0
        }

        // Bonus for agent migration capability
        if config.requiredLayers.coralReefArchitecture.structure.agentMigration {
            score += 3.0
        }

        return max(0, min(100, score))
    }

    private func getAllRequiredFiles() -> [String] {
        return config.requiredLayers.mentorshipLayer.mustExist +
               config.requiredLayers.memoryArchitecture.entitySpecific.mustHave +
               config.requiredLayers.coralReefArchitecture.filesRequired +
               config.requiredLayers.coreDoctrines.mustExist +
               config.requiredLayers.cicdPipeline.requiredFiles
    }

    // MARK: - Helper Methods
    private func fileExists(_ filename: String) -> Bool {
        // Check in workspace or bundle
        let workspaceURL = URL(fileURLWithPath: "/Users/kristoffersodersten/NovaMind")
        let fullPath = workspaceURL.appendingPathComponent(filename).path

        return FileManager.default.fileExists(atPath: fullPath) ||
               Bundle.main.path(forResource: filename, ofType: nil) != nil
    }

    private func requirementMet(_ requirement: String) -> Bool {
        // Check specific requirements based on string content
        switch requirement {
        case "paired mentors with agents":
            return checkPairedMentorsWithAgents()
        case "memory layer validation":
            return checkMemoryLayerValidation()
        case "cosmic resonance propagation":
            return checkCosmicResonancePropagation()
        default:
            return true // Default to true for unknown requirements
        }
    }

    private func agentAvailable(_ agent: String) -> Bool {
        // Check if AI agent is available in the system
        switch agent {
        case "collective_llm":
            return checkCollectiveLLMAvailability()
        case "mentor_agent":
            return checkMentorAgentAvailability()
        case "memory_agent":
            return checkMemoryAgentAvailability()
        default:
            return false // Default to false for unknown agents
        }
    }

    private func parsePercentage(_ percentageString: String) -> Double? {
        let cleanString = percentageString.replacingOccurrences(of: "%", with: "")
        return Double(cleanString)
    }

    // MARK: - Specific Validation Checks
    private func checkPairedMentorsWithAgents() -> Bool {
        // Check if mentors are properly paired with agents
        return fileExists("NovaMindKit/NeuroMeshEmotionalModel.swift") &&
               fileExists("Infrastructure/APIClient.swift")
    }

    private func checkMemoryLayerValidation() -> Bool {
        // Check memory layer integrity
        return fileExists("Core/MemoryArchitecture.swift") &&
               fileExists("NovaMindKit/NeuroMeshMemorySystem.swift")
    }

    private func checkCosmicResonancePropagation() -> Bool {
        // Check cosmic resonance system
        return fileExists("NovaMindKit/Semantic360ResonanceRadar.swift") &&
               fileExists("Core/NovaMindQuantumSystem.swift")
    }

    private func checkCollectiveLLMAvailability() -> Bool {
        // Check if collective LLM is configured
        return fileExists("Infrastructure/APIClient.swift") &&
               fileExists("NovaMindKit/CollectiveMemoryLayer.swift")
    }

    private func checkMentorAgentAvailability() -> Bool {
        // Check if mentor agent is available
        return fileExists("NovaMindKit/NeuroMeshEmotionalModel.swift")
    }

    private func checkMemoryAgentAvailability() -> Bool {
        // Check if memory agent is available
        return fileExists("NovaMindKit/NeuroMeshMemorySystem.swift")
    }
}

// MARK: - Advanced Validation Methods
extension NovaMindSystemValidator {
    func validateResonanceIntegrity() -> ResonanceValidationResult {
        var resonanceIssues: [String] = []

        // Check if resonance radar is properly configured
        if !fileExists("NovaMindKit/Semantic360ResonanceRadar.swift") {
            resonanceIssues.append("Semantic360ResonanceRadar not found")
        }

        // Check quantum system integration
        if !fileExists("Core/NovaMindQuantumSystem.swift") {
            resonanceIssues.append("NovaMindQuantumSystem not found")
        }

        // Check neuro-mesh integration
        if !fileExists("NovaMindKit/NeuroMeshIntegrationExamples.swift") {
            resonanceIssues.append("NeuroMeshIntegration examples not found")
        }

        let resonanceScore = calculateAdvancedResonanceScore(issues: resonanceIssues)

        return ResonanceValidationResult(
            resonanceScore: resonanceScore,
            isStable: resonanceScore > 80.0,
            issues: resonanceIssues
        )
    }

    private func calculateAdvancedResonanceScore(issues: [String]) -> Double {
        let baseScore = 100.0
        let penaltyPerIssue = 15.0

        return max(0, baseScore - (Double(issues.count) * penaltyPerIssue))
    }
}

// MARK: - Supporting Types
struct ResonanceValidationResult {
    let resonanceScore: Double
    let isStable: Bool
    let issues: [String]

    var report: String {
        var report = "Resonance Validation Report\n"
        report += "==========================\n\n"
        report += "Resonance Score: \(String(format: "%.1f", resonanceScore))%\n"
        report += "Stability: \(isStable ? "STABLE" : "UNSTABLE")\n\n"

        if !issues.isEmpty {
            report += "Resonance Issues:\n"
            report += "----------------\n"
            for (index, issue) in issues.enumerated() {
                report += "\(index + 1). \(issue)\n"
            }
        } else {
            report += "No resonance issues detected.\n"
        }

        return report
    }
}
