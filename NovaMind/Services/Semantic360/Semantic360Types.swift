import Foundation
import SwiftUI

// MARK: - Core Data Structures

struct SemanticPing {
    let id: String
    let hypothesis: String
    let originContext: PingOriginContext
    let timestamp: Date
    let entropyLimit: Double
}

struct PingOriginContext {
    let agent: AgentContext
    let systemState: SystemState
}

struct AgentContext {
    let id: String
    let currentTask: String
    let emotionalState: String
    let recentInteractions: [String]
}

struct SystemState {
    let memoryUsage: Double
    let processingLoad: Double
    let activeConnections: Int
    let errorRate: Double
    let timestamp: Date
}

struct PingCycle {
    let ping: SemanticPing
    let startTime: Date
    let expectedEchoes: Int
}

struct SemanticEcho {
    let id: String
    let type: SignalType
    let content: String
    let source: String
    let strength: Double
    let timestamp: Date
}

enum SignalType: String, CaseIterable {
    case errorSilence = "error_silence"
    case undefinedResponse = "undefined_response"
    case overcorrection = "overcorrection"
    case driftFromSpec = "drift_from_spec"
    case surpriseCongruence = "surprise_congruence"
}

enum EchoClassification {
    case latentNeed
    case emergentPattern
    case inverseSilence
    case standardEcho
}

struct ExternalSignal {
    let type: SignalType
    let content: String
    let source: String
    let strength: Double
    let timestamp: Date
}

struct SemanticAnomaly {
    let id: String
    let echo: SemanticEcho
    let classification: EchoClassification
    let anomalyType: AnomalyType
    let confidence: Double
    let timestamp: Date
}

enum AnomalyType {
    case unexpectedSilence
    case behavioralAnomaly
    case responseAmplification
    case specificationDrift
    case unexpectedAlignment
}

struct IdentifiedNeed {
    let id: String
    let description: String
    let confidence: Double
    let echoSource: SemanticEcho
    let predictedTimeframe: TimeFrame
    let category: NeedCategory
}

enum TimeFrame {
    case immediate
    case shortTerm
    case mediumTerm
    case longTerm
}

enum NeedCategory {
    case functionality
    case performance
    case usability
    case reliability
    case security
}

struct PatternCluster {
    let id: String
    let type: SignalType
    let echoes: [SemanticEcho]
    let representativePattern: String
    let confidence: Double
    let timestamp: Date
}

struct ResonanceMap {
    let id: String
    let clusters: [PatternCluster]
    let insights: [ResonanceInsight]
    let averageResonance: Double
    let timestamp: Date
}

struct ResonanceInsight {
    let description: String
    let confidence: Double
    let category: SignalType
}

struct FutureNeedPrediction {
    let need: String
    let confidence: Double
    let timeframe: TimeFrame
    let impact: ImpactLevel
    let supportingEchoes: [SemanticEcho]
}

enum ImpactLevel {
    case low
    case medium
    case high
}

struct RadarInsights {
    let totalEchoes: Int
    let patternClusters: [PatternCluster]
    let identifiedAnomalies: [SemanticAnomaly]
    let predictedNeeds: [FutureNeedPrediction]
    let resonanceStrength: Double
}

struct PingCycleInsights {
    let pingId: String
    let hypothesis: String
    let echoCount: Int
    let anomaliesDetected: Int
    let newNeedsIdentified: Int
    let timestamp: Date
}

struct EchoPattern {
    let description: String
    let significance: Double
    let category: SignalType
}

struct MentorValidation {
    let mentor: String
    let confidence: Double
    let feedback: String
    let concerns: [String]
}

enum CollectiveMemoryTier {
    case golden
    case tweaks
    case errors
}

struct SemanticPattern {
    let fingerprint: [Double]
}

// MARK: - Configuration

struct Semantic360Config {
    let pingFrequency: TimeInterval = 300 // 5 minutes
    let bufferSize: Int = 4096
    let consensusThreshold: Double = 0.6
    let maxFutureNeeds: Int = 100
    let visualOutputPath = "./dashboards/future_heatmap.svg"
}

// MARK: - Extensions

extension DateFormatter {
    static let shortDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
