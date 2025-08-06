import Foundation

// MARK: - Curiosity Response Handler

class CuriosityResponseHandler {
    
    func handleCuriosity(
        for query: String,
        context: NeuroMeshContext
    ) async -> CuriosityResponse {
        let curiosityFactors = await analyzeCuriosityFactors(query, context)
        let curiosityLevel = calculateCuriosityLevel(curiosityFactors)
        let explorationStrategy = determineExplorationStrategy(curiosityLevel, context)

        return CuriosityResponse(
            level: curiosityLevel,
            strategy: explorationStrategy,
            explorationPaths: generateExplorationPaths(query, curiosityFactors),
            learningPotential: assessLearningPotential(curiosityFactors)
        )
    }

    // MARK: - Private Methods

    private func analyzeCuriosityFactors(
        _ query: String,
        _ context: NeuroMeshContext
    ) async -> [CuriosityFactor] {
        var factors: [CuriosityFactor] = []

        // Novelty factor
        let noveltyScore = await assessNovelty(query, context)
        factors.append(CuriosityFactor(type: .novelty, score: noveltyScore))

        // Complexity factor
        let complexityScore = assessComplexity(query)
        factors.append(CuriosityFactor(type: .complexity, score: complexityScore))

        // Personal relevance factor
        let relevanceScore = await assessPersonalRelevance(query, context)
        factors.append(CuriosityFactor(type: .personalRelevance, score: relevanceScore))

        // Gap in knowledge factor
        let knowledgeGapScore = await assessKnowledgeGap(query, context)
        factors.append(CuriosityFactor(type: .knowledgeGap, score: knowledgeGapScore))

        return factors
    }

    private func calculateCuriosityLevel(_ factors: [CuriosityFactor]) -> Double {
        let weightedSum = factors.map { factor in
            factor.score * factor.type.weight
        }.reduce(0, +)

        let totalWeight = factors.map { $0.type.weight }.reduce(0, +)

        return totalWeight > 0 ? weightedSum / totalWeight : 0.0
    }

    private func determineExplorationStrategy(_ level: Double, _ context: NeuroMeshContext) -> ExplorationStrategy {
        switch level {
        case 0.8...: return .intuitive
        case 0.6...: return .collaborative
        case 0.4...: return .systematic
        default: return .reflective
        }
    }

    private func generateExplorationPaths(_ query: String, _ factors: [CuriosityFactor]) -> [String] {
        return ["conceptual_mapping", "pattern_analysis", "domain_bridging"]
    }

    private func assessLearningPotential(_ factors: [CuriosityFactor]) -> Double {
        return factors.map { $0.score }.reduce(0, +) / Double(factors.count)
    }

    private func assessNovelty(_ query: String, _ context: NeuroMeshContext) async -> Double {
        return Double.random(in: 0.3...0.9) // Mock implementation
    }

    private func assessComplexity(_ query: String) -> Double {
        let wordCount = query.components(separatedBy: .whitespacesAndNewlines).count
        let complexity = min(1.0, Double(wordCount) / 50.0) // Normalize to 0-1
        return complexity
    }

    private func assessPersonalRelevance(_ query: String, _ context: NeuroMeshContext) async -> Double {
        return 0.7 // Mock implementation
    }

    private func assessKnowledgeGap(_ query: String, _ context: NeuroMeshContext) async -> Double {
        return 0.6 // Mock implementation
    }
}

// MARK: - Frustration Response Handler

class FrustrationResponseHandler {
    
    func handleFrustration(
        from interaction: NeuroMeshInteraction,
        context: NeuroMeshContext
    ) async -> FrustrationResponse {
        let frustrationSources = await identifyFrustrationSources(interaction, context)
        let frustrationLevel = calculateFrustrationLevel(frustrationSources)

        // Swedish approach: Transform frustration into learning opportunity
        let constructiveActions = await generateConstructiveActions(frustrationSources, context)
        let mentoringOpportunity = await identifyMentoringOpportunity(frustrationSources)

        return FrustrationResponse(
            level: frustrationLevel,
            sources: frustrationSources,
            constructiveActions: constructiveActions,
            mentoringOpportunity: mentoringOpportunity,
            cooldownStrategy: generateCooldownStrategy(frustrationLevel)
        )
    }

    // MARK: - Private Methods

    private func identifyFrustrationSources(
        _ interaction: NeuroMeshInteraction,
        _ context: NeuroMeshContext
    ) async -> [String] {
        return ["complexity_overload", "unclear_expectations"]
    }

    private func calculateFrustrationLevel(_ sources: [String]) -> Double {
        return min(1.0, Double(sources.count) * 0.3)
    }

    private func generateConstructiveActions(
        _ sources: [String],
        _ context: NeuroMeshContext
    ) async -> [String] {
        return ["break_down_complexity", "seek_clarification"]
    }

    private func identifyMentoringOpportunity(_ sources: [String]) async -> MentoringOpportunity? {
        return MentoringOpportunity(
            mentorType: "technical",
            topic: "complexity_management",
            urgency: .medium
        )
    }

    private func generateCooldownStrategy(_ level: Double) -> CooldownStrategy {
        let duration = level > 0.7 ? 900.0 : 300.0 // 15 or 5 minutes
        return CooldownStrategy(
            duration: duration,
            activities: ["deep_breathing", "perspective_shift"],
            checkInFrequency: duration / 3
        )
    }
}

// MARK: - Celebration Response Handler

class CelebrationResponseHandler {
    
    func handleCelebration(
        from interaction: NeuroMeshInteraction,
        achievements: [Achievement],
        context: NeuroMeshContext
    ) async -> CelebrationResponse {
        let joyLevel = calculateJoyLevel(achievements)
        let sharedCelebration = await generateSharedCelebration(achievements, context)

        // Swedish approach: Collective celebration and shared learning
        let learningInsights = await extractLearningInsights(achievements)
        let inspirationPotential = assessInspirationPotential(achievements, context)

        return CelebrationResponse(
            joyLevel: joyLevel,
            sharedCelebration: sharedCelebration,
            learningInsights: learningInsights,
            inspirationPotential: inspirationPotential,
            reinforcementActions: generateReinforcementActions(achievements)
        )
    }

    // MARK: - Private Methods

    private func calculateJoyLevel(_ achievements: [Achievement]) -> Double {
        return min(1.0, achievements.map { $0.impact }.reduce(0, +) / Double(achievements.count))
    }

    private func generateSharedCelebration(
        _ achievements: [Achievement],
        _ context: NeuroMeshContext
    ) async -> SharedCelebration {
        return SharedCelebration(
            participants: ["team", "mentors"],
            format: .storySharing,
            message: "Celebrating collaborative achievement"
        )
    }

    private func extractLearningInsights(_ achievements: [Achievement]) async -> [String] {
        return achievements.map { "Learned: \($0.description)" }
    }

    private func assessInspirationPotential(
        _ achievements: [Achievement],
        _ context: NeuroMeshContext
    ) -> Double {
        return 0.8
    }

    private func generateReinforcementActions(_ achievements: [Achievement]) -> [String] {
        return ["document_pattern", "share_insights"]
    }
}

// MARK: - Doubt Response Handler

class DoubtResponseHandler {
    
    func handleDoubt(
        from interaction: NeuroMeshInteraction,
        uncertainties: [Uncertainty],
        context: NeuroMeshContext
    ) async -> DoubtResponse {
        let doubtLevel = calculateDoubtLevel(uncertainties)
        let reflectionPrompts = await generateReflectionPrompts(uncertainties, context)

        // Swedish approach: Doubt as gateway to deeper understanding
        let clarificationPaths = await identifyClarificationPaths(uncertainties)
        let collaborativeSupport = await findCollaborativeSupport(uncertainties, context)

        return DoubtResponse(
            level: doubtLevel,
            reflectionPrompts: reflectionPrompts,
            clarificationPaths: clarificationPaths,
            collaborativeSupport: collaborativeSupport,
            growthOpportunities: identifyGrowthOpportunities(uncertainties)
        )
    }

    // MARK: - Private Methods

    private func calculateDoubtLevel(_ uncertainties: [Uncertainty]) -> Double {
        return min(1.0, uncertainties.map { 1.0 - $0.confidence }.reduce(0, +) / Double(uncertainties.count))
    }

    private func generateReflectionPrompts(
        _ uncertainties: [Uncertainty],
        _ context: NeuroMeshContext
    ) async -> [String] {
        return uncertainties.map { "What assumptions underlie \($0.area)?" }
    }

    private func identifyClarificationPaths(_ uncertainties: [Uncertainty]) async -> [String] {
        return ["expert_consultation", "research_investigation"]
    }

    private func findCollaborativeSupport(
        _ uncertainties: [Uncertainty],
        _ context: NeuroMeshContext
    ) async -> [String] {
        return ["peer_review", "mentor_guidance"]
    }

    private func identifyGrowthOpportunities(_ uncertainties: [Uncertainty]) -> [String] {
        return uncertainties.map { "Growth opportunity in \($0.area)" }
    }
}
