import Foundation

// MARK: - Bird Agent Deployment Manager
class BirdAgentDeploymentManager {
    private let speciesManager = BirdSpeciesManager()
    private let mentorRegistry = MentorRegistry.shared
    
    // MARK: - Agent Deployment
    
    func deployInitialAgents(species: [BirdSpecies]) -> ([BirdAgent], [String: AgentPerformanceMetrics]) {
        var agents: [BirdAgent] = []
        var performanceMetrics: [String: AgentPerformanceMetrics] = [:]
        
        for speciesType in species {
            let agent = createBirdAgent(species: speciesType)
            agents.append(agent)

            // Initialize performance metrics
            performanceMetrics[agent.id] = AgentPerformanceMetrics(
                agentId: agent.id,
                species: speciesType.name,
                tasksCompleted: 0,
                averageExecutionTime: 0.0,
                successRate: 1.0,
                ethicalViolations: 0,
                lastActive: Date()
            )

            // Pair with mentor if enabled
            if speciesType.name != "albatross" { // Albatross operates independently
                createMentorPairing(for: agent)
            }
        }
        
        return (agents, performanceMetrics)
    }

    func createBirdAgent(species: BirdSpecies) -> BirdAgent {
        let identityHash = generateIdentityHash(for: species)

        return BirdAgent(
            id: "\(species.name)-\(UUID().uuidString.prefix(8))",
            species: species,
            status: .active,
            identityHash: identityHash,
            currentTask: nil,
            memoryState: AgentMemoryState(),
            ethicalAlignment: EthicalAlignment(),
            createdAt: Date(),
            lastHeartbeat: Date()
        )
    }

    func generateIdentityHash(for species: BirdSpecies) -> String {
        let data = "\(species.name)-\(species.capabilities)-\(Date().timeIntervalSince1970)"
        return data.sha512()
    }

    func createMentorPairing(for agent: BirdAgent) {
        // Find appropriate mentor based on agent specialization
        let mentorId = selectMentorForSpecies(species: agent.species.name)
        _ = mentorRegistry.createPairing(mentorId: mentorId, agentId: agent.id)
    }

    func selectMentorForSpecies(species: String) -> String {
        switch species {
        case "sparrow", "falcon":
            return "deepseek-mentor"
        case "raven", "owl", "albatross":
            return "claude-mentor"
        case "kestrel", "heron", "swallow":
            return "phi-mentor"
        default:
            return "deepseek-mentor"
        }
    }
    
    // MARK: - Agent Management
    
    func updateAgentTask(agent: inout BirdAgent, task: String?) {
        agent.currentTask = task
        agent.lastHeartbeat = Date()
    }
}
