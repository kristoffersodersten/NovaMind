import Foundation

// MARK: - Core Emotional Data Structures

struct EmotionalState {
    let primaryEmotion: EmotionType
    let intensity: Double // 0.0 to 1.0
    let timestamp: Date

    static func neutral() -> EmotionalState {
        return EmotionalState(
            primaryEmotion: .neutral,
            intensity: 0.5,
            timestamp: Date()
        )
    }
}

enum EmotionType: String, CaseIterable {
    case curious
    case frustrated
    case joyful
    case doubtful
    case neutral
    case empathetic

    var description: String {
        return rawValue
    }

    static func curious(intensity: Double) -> EmotionType { .curious }
    static func joyful(intensity: Double) -> EmotionType { .joyful }
    static func reflective(intensity: Double) -> EmotionType { .doubtful }
}

struct EmotionalSignature {
    let type: EmotionType
    let intensity: Double
    let confidence: Double
    let source: String
}

struct EmotionalResponse {
    let primaryEmotion: EmotionType
    let intensity: Double
    let empathyLevel: Double
    let suggestedActions: [EmotionalAction]
    let processingInsights: [ProcessingInsight]
}

struct CollectiveEmotionalContext {
    let averageEmotion: EmotionType
    let empathyResonance: Double
    let emotionalDiversity: Double
    let collaborativeHarmony: Double
    let timestamp: Date

    init() {
        self.averageEmotion = .neutral
        self.empathyResonance = 0.5
        self.emotionalDiversity = 0.5
        self.collaborativeHarmony = 0.5
        self.timestamp = Date()
    }

    init(
        averageEmotion: EmotionType,
        empathyResonance: Double,
        emotionalDiversity: Double,
        collaborativeHarmony: Double,
        timestamp: Date
    ) {
        self.averageEmotion = averageEmotion
        self.empathyResonance = empathyResonance
        self.emotionalDiversity = emotionalDiversity
        self.collaborativeHarmony = collaborativeHarmony
        self.timestamp = timestamp
    }
}

struct EmpathyResonance {
    let level: Double
    let connections: [String]
    let mutualUnderstanding: Double

    init() {
        self.level = 0.5
        self.connections = []
        self.mutualUnderstanding = 0.5
    }

    init(level: Double, connections: [String], mutualUnderstanding: Double) {
        self.level = level
        self.connections = connections
        self.mutualUnderstanding = mutualUnderstanding
    }
}

struct EmpathyResponse {
    let level: Double
    let connections: [String]
    let mutualUnderstanding: Double
}

struct EmotionalStateTransition {
    let fromState: EmotionalState
    let targetState: EmotionalState
    let trigger: String
    let timestamp: Date
    let intensity: Double
}

struct EmotionalQuery {
    let targetEmotion: EmotionType
    let intensityRange: ClosedRange<Double>
    let context: String
}

struct EmotionalInsight {
    let type: String
    let description: String
    let confidence: Double
}

struct EmotionalPattern {
    let trigger: String
    let response: EmotionType
    let context: String
    let effectiveness: Double
}

struct AdaptationRule {
    let condition: String
    let action: String
    let priority: Priority
}

struct EmotionalHealth {
    let stability: Double
    let empathyCapacity: Double
    let learningRate: Double
    let currentState: EmotionalState
    let recentTransitions: [EmotionalStateTransition]
}

struct EmotionalIntegration {
    let coherence: Double
    let resonance: Double
    let stability: Double
}

struct ProcessingInsight {
    let category: String
    let insight: String
    let confidence: Double
}

// MARK: - Enhanced Result Types

struct EmotionallyEnhancedResult<T: NeuroMeshMemoryContent> {
    let originalResult: NeuroMeshResult<T>
    let emotionalRelevance: Double
    let empathyScore: Double
    let emotionalInsights: [EmotionalInsight]
    let suggestedEmotionalActions: [EmotionalAction]
}

struct EmotionallyIntegratedContent<T: NeuroMeshMemoryContent> {
    let content: T
    let emotionalContext: EmotionalResponse
    let integration: EmotionalIntegration
}

// MARK: - Priority Enum

enum Priority {
    case low
    case medium
    case high
}

// MARK: - Extensions

extension Array where Element == Double {
    func variance() -> Double {
        guard count > 1 else { return 0.0 }

        let mean = reduce(0, +) / Double(count)
        let squaredDifferences = map { pow($0 - mean, 2) }
        return squaredDifferences.reduce(0, +) / Double(count - 1)
    }
}
