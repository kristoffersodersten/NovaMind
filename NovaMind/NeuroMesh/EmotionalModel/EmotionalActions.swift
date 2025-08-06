import Foundation

// MARK: - Emotional Actions and Related Enums

enum EmotionalAction {
    case exploreDeeper(paths: [String])
    case seekConnections(domains: [String])
    case seekSupport(type: SupportType)
    case takeBreak(duration: BreakDuration)
    case reframeChallenge(perspective: ReframePerspective)
    case shareSuccess(with: SharingTarget)
    case reinforceLearning(method: ReinforcementMethod)
    case inspireCuriosity(within: InspirationTarget)
    case seekClarification(sources: [String])
    case reflectDeeply(focus: ReflectionFocus)
    case collaborateForInsight(approach: CollaborationApproach)
    case maintainOpenness(towards: OpennessTarget)
    case offerSupport(towards: SupportTarget)
    case facilitateConnection(between: ConnectionTarget)
}

enum SupportType {
    case mentoring
    case peer
    case technical
}

enum BreakDuration {
    case short
    case medium
    case long
}

enum ReframePerspective {
    case learningOpportunity
    case growthChallenge
    case creativePuzzle
}

enum SharingTarget {
    case collective
    case mentors
    case peers
}

enum ReinforcementMethod {
    case positiveAssociation
    case patternRecognition
    case celebration
}

enum InspirationTarget {
    case relatedAreas
    case unexploredDomains
    case collaborativeProjects
}

enum ReflectionFocus {
    case understandingGaps
    case assumptionChecking
    case perspectiveExpansion
}

enum CollaborationApproach {
    case guidedExploration
    case peerDiscussion
    case mentorConsultation
}

enum OpennessTarget {
    case newPossibilities
    case alternativeApproaches
    case unexpectedConnections
}

enum SupportTarget {
    case strugglingAgents
    case newParticipants
    case confusedContexts
}

enum ConnectionTarget {
    case complementaryAgents
    case similarChallenges
    case diversePerspectives
}

// MARK: - Response Types

struct CuriosityResponse {
    let level: Double
    let strategy: ExplorationStrategy
    let explorationPaths: [String]
    let learningPotential: Double
}

struct FrustrationResponse {
    let level: Double
    let sources: [String]
    let constructiveActions: [String]
    let mentoringOpportunity: MentoringOpportunity?
    let cooldownStrategy: CooldownStrategy
}

struct CelebrationResponse {
    let joyLevel: Double
    let sharedCelebration: SharedCelebration
    let learningInsights: [String]
    let inspirationPotential: Double
    let reinforcementActions: [String]
}

struct DoubtResponse {
    let level: Double
    let reflectionPrompts: [String]
    let clarificationPaths: [String]
    let collaborativeSupport: [String]
    let growthOpportunities: [String]
}

// MARK: - Supporting Types

struct CuriosityFactor {
    let type: CuriosityFactorType
    let score: Double
}

enum CuriosityFactorType {
    case novelty
    case complexity
    case personalRelevance
    case knowledgeGap

    var weight: Double {
        switch self {
        case .novelty: return 0.3
        case .complexity: return 0.2
        case .personalRelevance: return 0.3
        case .knowledgeGap: return 0.2
        }
    }
}

enum ExplorationStrategy {
    case systematic
    case intuitive
    case collaborative
    case reflective
}

struct MentoringOpportunity {
    let mentorType: String
    let topic: String
    let urgency: Priority
}

struct CooldownStrategy {
    let duration: TimeInterval
    let activities: [String]
    let checkInFrequency: TimeInterval
}

struct SharedCelebration {
    let participants: [String]
    let format: CelebrationFormat
    let message: String
}

enum CelebrationFormat {
    case announcement
    case storySharing
    case insightHighlight
    case collectiveReflection
}

struct Achievement {
    let type: String
    let description: String
    let impact: Double
    let timestamp: Date
}

struct Uncertainty {
    let area: String
    let description: String
    let confidence: Double
    let importance: Double
}
