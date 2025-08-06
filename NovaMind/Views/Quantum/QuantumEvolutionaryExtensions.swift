import SwiftUI


// MARK: - Extensions for QuantumEvolutionaryView Types

extension UsagePattern {
    var displayName: String {
        switch self {
        case .visualCognitionStrain: return "Visual Strain"
        case .navigationComplexity: return "Navigation Issues"
        case .frequentErrors: return "Frequent Errors"
        case .performanceIssues: return "Performance Issues"
        }
    }
}

extension MutationType {
    var displayName: String {
        switch self {
        case .visualEnhancement: return "Visual Enhancement"
        case .navigationEnhancement: return "Navigation Enhancement"
        case .performanceOptimization: return "Performance Optimization"
        case .accessibilityEnhancement: return "Accessibility Enhancement"
        }
    }

    var iconName: String {
        switch self {
        case .visualEnhancement: return "eye.fill"
        case .navigationOptimization: return "location.fill"
        case .performanceOptimization: return "speedometer"
        case .accessibilityEnhancement: return "accessibility"
        }
    }
}

extension UIComponent {
    var displayName: String {
        switch self {
        case .memoryCanvas: return "Memory Canvas"
        case .inputBar: return "Input Bar"
        case .chatBubble: return "Chat Bubble"
        case .navigationBar: return "Navigation Bar"
        }
    }
}

extension RiskLevel {
    var displayName: String {
        switch self {
        case .low: return "Low Risk"
        case .medium: return "Medium Risk"
        case .high: return "High Risk"
        }
    }

    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

extension ExpectedBenefit {
    var displayName: String {
        switch self {
        case .cognitiveLoadReduction: return "Cognitive Load Reduction"
        case .navigationEfficiency: return "Navigation Efficiency"
        case .visualClarity: return "Visual Clarity"
        case .performanceGain: return "Performance Gain"
        }
    }
}

extension GeneticChange {
    var displayName: String {
        switch self {
        case .colorContrastAdjustment(let factor):
            return "Color Contrast ×\(factor, specifier: "%.2f")"
        case .fontSizeOptimization(let delta):
            return "Font Size \(delta > 0 ? "+" : "")\(delta, specifier: "%.1f")pt"
        case .spacingRefinement(let multiplier):
            return "Spacing ×\(multiplier, specifier: "%.2f")"
        case .gestureSimplification:
            return "Gesture Simplification"
        case .affordanceEnhancement:
            return "Affordance Enhancement"
        case .contextualAdaptation:
            return "Contextual Adaptation"
        }
    }
}
