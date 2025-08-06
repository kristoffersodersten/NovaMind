import Foundation


// MARK: - Main Configuration Structure
struct NovaMindEcosystemConfig: Codable {
    let ecosystemValidationDirective: String
    let scope: String
    let project: String
    let platform: String
    let executionMode: String
    let requiredLayers: RequiredLayers
    let output: OutputValidation

    enum CodingKeys: String, CodingKey {
        case ecosystemValidationDirective = "ecosystem_validation_directive"
        case scope, project, platform
        case executionMode = "execution_mode"
        case requiredLayers = "required_layers"
        case output
    }
}

// MARK: - Required Layers
struct RequiredLayers: Codable {
    let mentorshipLayer: MentorshipLayer
    let memoryArchitecture: MemoryArchitecture
    let coralReefArchitecture: CoralReefArchitecture
    let coreDoctrines: CoreDoctrines
    let aiAgents: AIAgents
    let cicdPipeline: CICDPipeline

    enum CodingKeys: String, CodingKey {
        case mentorshipLayer = "mentorship_layer"
        case memoryArchitecture = "memory_architecture"
        case coralReefArchitecture = "coral_reef_architecture"
        case coreDoctrines = "core_doctrines"
        case aiAgents = "ai_agents"
        case cicdPipeline = "cicd_pipeline"
    }
}

// MARK: - Mentorship Layer
struct MentorshipLayer: Codable {
    let mustExist: [String]
    let requirements: [String]

    enum CodingKeys: String, CodingKey {
        case mustExist = "must_exist"
        case requirements
    }
}

// MARK: - Memory Architecture
struct MemoryArchitecture: Codable {
    let shortTerm: String
    let midTerm: String
    let longTerm: String
    let entitySpecific: EntitySpecificMemory
    let collectiveMemory: CollectiveMemory

    enum CodingKeys: String, CodingKey {
        case shortTerm = "short_term"
        case midTerm = "mid_term"
        case longTerm = "long_term"
        case entitySpecific = "entity_specific"
        case collectiveMemory = "collective_memory"
    }
}

struct EntitySpecificMemory: Codable {
    let mustHave: [String]

    enum CodingKeys: String, CodingKey {
        case mustHave = "must_have"
    }
}

struct CollectiveMemory: Codable {
    let strategy: String
    let location: String

    enum CodingKeys: String, CodingKey {
        case strategy, location
    }
}

// MARK: - Coral Reef Architecture
struct CoralReefArchitecture: Codable {
    let structure: CoralStructure
    let filesRequired: [String]
    let validation: CoralValidation

    enum CodingKeys: String, CodingKey {
        case structure
        case filesRequired = "files_required"
        case validation
    }
}

struct CoralStructure: Codable {
    let selfHealing: Bool
    let agentMigration: Bool
    let swarmLogic: String

    enum CodingKeys: String, CodingKey {
        case selfHealing = "self-healing"
        case agentMigration = "agent_migration"
        case swarmLogic = "swarm_logic"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selfHealing = try container.decode(Bool.self, forKey: .selfHealing)
        agentMigration = try container.decode(Bool.self, forKey: .agentMigration)

        let swarmValue = try container.decode(String.self, forKey: .swarmLogic)
        swarmLogic = swarmValue == "enabled" ? "enabled" : swarmValue
    }
}

struct CoralValidation: Codable {
    let noOrphanedAgents: Bool
    let noSemanticallyDivergentNodes: Bool
    let cycleLatency: String
    let memoryBandwidth: String

    enum CodingKeys: String, CodingKey {
        case noOrphanedAgents = "no orphaned agents"
        case noSemanticallyDivergentNodes = "no semantically divergent nodes"
        case cycleLatency = "cycleLatency"
        case memoryBandwidth = "memoryBandwidth"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        noOrphanedAgents = try container.decode(Bool.self, forKey: .noOrphanedAgents)
        noSemanticallyDivergentNodes = try container.decode(Bool.self, forKey: .noSemanticallyDivergentNodes)
        cycleLatency = try container.decode(String.self, forKey: .cycleLatency)
        memoryBandwidth = try container.decode(String.self, forKey: .memoryBandwidth)
    }
}

// MARK: - Core Doctrines
struct CoreDoctrines: Codable {
    let enforced: [String]
    let verifiedBy: String
    let mustExist: [String]
    let checks: DoctrineChecks

    enum CodingKeys: String, CodingKey {
        case enforced
        case verifiedBy = "verified_by"
        case mustExist = "must_exist"
        case checks
    }
}

struct DoctrineChecks: Codable {
    let entityHasRights: Bool
    let semanticViolationCount: Int
    let agentConflictResolutionRate: String

    enum CodingKeys: String, CodingKey {
        case entityHasRights = "entity_has_rights"
        case semanticViolationCount = "semantic_violation_count"
        case agentConflictResolutionRate = "agent_conflict_resolution_rate"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entityHasRights = try container.decode(Bool.self, forKey: .entityHasRights)
        semanticViolationCount = try container.decode(Int.self, forKey: .semanticViolationCount)
        agentConflictResolutionRate = try container.decode(String.self, forKey: .agentConflictResolutionRate)
    }
}

// MARK: - AI Agents
struct AIAgents: Codable {
    let minimumRequired: [String]
    let fallbackHandling: FallbackHandling
    let routingLogic: RoutingLogic

    enum CodingKeys: String, CodingKey {
        case minimumRequired = "minimum_required"
        case fallbackHandling = "fallback_handling"
        case routingLogic = "routing_logic"
    }
}

struct FallbackHandling: Codable {
    let semanticDegradationTolerance: String
    let agentSwitchingPolicy: String

    enum CodingKeys: String, CodingKey {
        case semanticDegradationTolerance = "semantic_degradation_tolerance"
        case agentSwitchingPolicy = "agent_switching_policy"
    }
}

struct RoutingLogic: Codable {
    let via: String
    let method: String

    enum CodingKeys: String, CodingKey {
        case via, method
    }
}

// MARK: - CI/CD Pipeline
struct CICDPipeline: Codable {
    let requiredFiles: [String]
    let enforcedStages: [String]
    let pipelines: PipelineConfig
    let mustPass: [String]

    enum CodingKeys: String, CodingKey {
        case requiredFiles = "required_files"
        case enforcedStages = "enforced_stages"
        case pipelines
        case mustPass = "must_pass"
    }
}

struct PipelineConfig: Codable {
    let triggerOn: String
    let environment: String
    let aiApprovalRequired: Bool

    enum CodingKeys: String, CodingKey {
        case triggerOn = "trigger_on"
        case environment
        case aiApprovalRequired = "ai_approval_required"
    }
}

// MARK: - Output Validation
struct OutputValidation: Codable {
    let generateFiles: [String]
    let failIf: FailConditions

    enum CodingKeys: String, CodingKey {
        case generateFiles = "generate_files"
        case failIf = "fail_if"
    }
}

struct FailConditions: Codable {
    let resonanceScore: String
    let unpairedMentorAgent: String
    let collectiveMemoryIncoherence: String

    enum CodingKeys: String, CodingKey {
        case resonanceScore = "resonance_score"
        case unpairedMentorAgent = "unpaired_mentor_agent"
        case collectiveMemoryIncoherence = "collective_memory_incoherence"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resonanceScore = try container.decode(String.self, forKey: .resonanceScore)
        unpairedMentorAgent = try container.decode(String.self, forKey: .unpairedMentorAgent)
        collectiveMemoryIncoherence = try container.decode(String.self,
                                                         forKey: .collectiveMemoryIncoherence)
    }
}

// MARK: - Configuration Loader
class NovaMindConfigLoader {
    static func loadFromJSON() -> NovaMindEcosystemConfig? {
        guard let url = Bundle.main.url(forResource: "NovaMindConfig", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not load configuration file")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let config = try decoder.decode(NovaMindEcosystemConfig.self, from: data)
            return config
        } catch {
            print("Error decoding configuration: \(error)")
            return nil
        }
    }

    static func loadFromYAML() -> NovaMindEcosystemConfig? {
        // This would require a YAML parsing library like Yams
        // For now, we'll return nil
        print("YAML parsing not implemented yet")
        return nil
    }
}

// MARK: - Validation Result
struct ValidationResult {
    let isValid: Bool
    let issues: [String]
    let resonanceScore: Double

    var report: String {
        var report = "NovaMind Ecosystem Validation Report\n"
        report += "=====================================\n\n"
        report += "Validation Status: \(isValid ? "PASSED" : "FAILED")\n"
        report += "Resonance Score: \(String(format: "%.1f", resonanceScore))%\n\n"

        if !issues.isEmpty {
            report += "Issues Found:\n"
            report += "------------\n"
            for (index, issue) in issues.enumerated() {
                report += "\(index + 1). \(issue)\n"
            }
        } else {
            report += "No issues found. All systems operational.\n"
        }

        return report
    }
}
