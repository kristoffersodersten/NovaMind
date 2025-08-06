import Foundation

// MARK: - Ecosystem Mapping Engine

class EcosystemMapGenerator {
    
    static func generateEcosystemMap(
        context: ValidationContext,
        validationResults: [ValidationResult]
    ) async -> EcosystemMap {
        let mentorEntities = await createMentorEntities(context: context)
        let agentEntities = await createAgentEntities(context: context)
        let coralNodeEntities = await createCoralNodeEntities(context: context)
        let lawEntities = await createLawEntities(context: context)
        
        return EcosystemMap(
            mentors: mentorEntities,
            agents: agentEntities,
            coralNodes: coralNodeEntities,
            laws: lawEntities,
            overallHealth: calculateOverallEcosystemHealth(from: validationResults),
            generatedAt: Date()
        )
    }
    
    // MARK: - Entity Creation
    
    private static func createMentorEntities(context: ValidationContext) async -> [EcosystemEntity] {
        return context.mentorRegistry.registeredMentors.map { mentor in
            EcosystemEntity(
                id: mentor.id,
                type: .mentor,
                status: .active,
                connections: context.mentorRegistry.activePairings
                    .filter { $0.mentorId == mentor.id }
                    .map { $0.agentId },
                health: 1.0,
                metadata: [
                    "specialty": mentor.specialty.rawValue,
                    "traits": mentor.traits.map { $0.rawValue }.joined(separator: ", ")
                ]
            )
        }
    }
    
    private static func createAgentEntities(context: ValidationContext) async -> [EcosystemEntity] {
        return context.resonanceRadar.pingMap.keys.map { agentId in
            EcosystemEntity(
                id: agentId,
                type: .agent,
                status: context.resonanceRadar.pingMap[agentId]?.isActive == true ? .active : .inactive,
                connections: context.mentorRegistry.activePairings
                    .filter { $0.agentId == agentId }
                    .map { $0.mentorId },
                health: context.resonanceRadar.pingMap[agentId]?.healthScore ?? 0.0,
                metadata: [
                    "responseTime": String(context.resonanceRadar.pingMap[agentId]?.responseTime ?? 0.0)
                ]
            )
        }
    }
    
    private static func createCoralNodeEntities(context: ValidationContext) async -> [EcosystemEntity] {
        return context.coralEngine.coralNodes.map { node in
            EcosystemEntity(
                id: node.id,
                type: .coralNode,
                status: node.health > 0.7 ? .active : .degraded,
                connections: node.connectedNodes,
                health: node.health,
                metadata: [
                    "type": node.type.rawValue,
                    "capacity": String(node.capacity),
                    "currentLoad": String(node.currentLoad)
                ]
            )
        }
    }
    
    private static func createLawEntities(context: ValidationContext) async -> [EcosystemEntity] {
        return context.lawEnforcer.constitutionalLaws.map { law in
            EcosystemEntity(
                id: law.id,
                type: .law,
                status: .active,
                connections: [],
                health: 1.0,
                metadata: [
                    "title": law.title,
                    "enforcementLevel": law.enforcementLevel.rawValue,
                    "scope": law.scope.rawValue
                ]
            )
        }
    }
    
    // MARK: - Health Calculation
    
    private static func calculateOverallEcosystemHealth(from results: [ValidationResult]) -> Double {
        let mentorshipScore = results.first { $0.category == .mentorship }?.score ?? 0.0
        let resonanceScore = results.first { $0.category == .resonance }?.score ?? 0.0
        let coralScore = results.first { $0.category == .coralReef }?.score ?? 0.0
        let constitutionalScore = results.first { $0.category == .constitutional }?.score ?? 0.0
        
        return (mentorshipScore + resonanceScore + coralScore + constitutionalScore) / 4.0
    }
    
    // MARK: - Memory Connection Generation
    
    static func generateMemoryConnections(context: ValidationContext) -> [MemoryConnection] {
        return context.mentorRegistry.activePairings.map { pairing in
            MemoryConnection(
                sourceId: pairing.mentorId,
                targetId: pairing.agentId,
                connectionType: .mentorAgent,
                strength: pairing.resonanceScore,
                lastActive: Date()
            )
        }
    }
    
    static func calculateMemoryHealth(context: ValidationContext) -> Double {
        let totalConnections = context.mentorRegistry.activePairings.count
        if totalConnections == 0 { return 1.0 }
        
        let healthyConnections = context.mentorRegistry.activePairings
            .filter { $0.resonanceScore > 0.7 }
            .count
        
        return Double(healthyConnections) / Double(totalConnections)
    }
}
