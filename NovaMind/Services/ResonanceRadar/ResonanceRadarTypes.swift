import Foundation

// MARK: - Core Data Types

struct ResonanceSignal: Identifiable {
    let id: String
    let type: ResonanceType
    let strength: Double
    let frequency: Double
    let source: String
    let metadata: [String: String]
    let timestamp: Date
}

enum ResonanceType: String, CaseIterable {
    case spectral
    case whisper
    case cluster
    case correlation
}

struct TrendNode: Identifiable {
    let id: String
    let frequency: Double
    let amplitude: Double
    let phase: Double
    let trend: TrendDirection
    let confidence: Double
    let timestamp: Date
}

enum TrendDirection: String, CaseIterable {
    case emerging
    case declining
    case stable
    case volatile
}

struct FutureCorrelation: Identifiable {
    let id: String
    let sourceSignal: String
    let targetSignal: String
    let strength: Double
    let timeHorizon: TimeInterval
    let probability: Double
    let description: String
}

struct CausalityCandidate: Identifiable {
    let id: String
    let cause: String
    let effect: String
    let strength: Double
    let evidence: [String]
    let confidence: Double
}

enum RadarStatus: String, CaseIterable {
    case idle
    case scanning
    case processing
    case completed
    case error
}

// MARK: - Input Stream Data

struct InputStreamData {
    let userBehavior: [UserBehaviorTrace]
    let chatReflections: [ChatReflection]
    let latentTags: [LatentTag]
    let failedPaths: [FailedPath]
    let visualAnomalies: [VisualAnomaly]
    let timestamp: Date
}

struct UserBehaviorTrace {
    let id: String
    let action: String
    let timestamp: Date
    let context: [String: String]
    let intensity: Double
}

struct ChatReflection {
    let id: String
    let content: String
    let sentiment: Double
    let topics: [String]
    let timestamp: Date
}

struct LatentTag {
    let id: String
    let tag: String
    let weight: Double
    let associations: [String]
    let confidence: Double
}

struct FailedPath {
    let id: String
    let attemptedAction: String
    let failureReason: String
    let timestamp: Date
    let context: [String: String]
}

struct VisualAnomaly {
    let id: String
    let anomalyType: String
    let location: CGPoint
    let severity: Double
    let timestamp: Date
}

// MARK: - Analysis Results

struct SpectralResults {
    let dominantFrequencies: [Double]
    let harmonicContent: [Double]
    let spectralCentroid: Double
    let spectralBandwidth: Double
}

struct WhisperResults {
    let weakSignals: [WeakSignal]
    let amplifiedSignals: [AmplifiedSignal]
    let trendPredictions: [TrendPrediction]
    let confidenceScores: [Double]
}

struct ClusterResults {
    let clusters: [Cluster]
    let clusterCenters: [ClusterCenter]
    let characteristics: [ClusterCharacteristic]
    let stability: [Double]
}

struct CorrelationResults {
    let correlationMatrix: CorrelationMatrix
    let strongCorrelations: [StrongCorrelation]
    let emergentPatterns: [EmergentPattern]
    let causalityIndicators: [CausalityIndicator]
}

// MARK: - Supporting Types

struct SpectralMetrics {
    let dominantFrequencies: [Double]
    let harmonicContent: [Double]
    let spectralCentroid: Double
    let spectralBandwidth: Double
    let spectralRolloff: Double
}

struct StreamAnalysisContext {
    let stream1: String
    let stream2: String
    let data1: [Double]
    let data2: [Double]
    let maxLag: Int
    let significanceLevel: Double
    let causalityThreshold: Double
}

// MARK: - Main Types

struct WeakSignal {
    let id: String
    let pattern: String
    let strength: Double
    let frequency: Double
}

struct AmplifiedSignal {
    let originalSignal: WeakSignal
    let amplificationFactor: Double
    let amplifiedStrength: Double
}

struct TrendPrediction {
    let id: String
    let description: String
    let probability: Double
    let timeFrame: TimeInterval
}

struct DataPoint {
    let id: String
    let features: [Double]
    let value: Double
    let timestamp: Date
    
    var description: String {
        return "DataPoint(id: \(id), features: \(features.count), value: \(value))"
    }
}

struct Cluster {
    let id: String
    let points: [DataPoint]
    let centroid: ClusterCenter
}

struct ClusterCenter {
    let coordinates: [Double]
    let id: String
    
    var description: String {
        return "ClusterCenter(id: \(id), dimensions: \(coordinates.count))"
    }
}

struct ClusterCharacteristic {
    let clusterId: String
    let size: Int
    let density: Double
    let confidence: Double
}

struct CorrelationMatrix {
    let matrix: [[Double]]
    let variables: [String]
}

struct StrongCorrelation {
    let variable1: String
    let variable2: String
    let correlation: Double
    let significance: Double
}

struct EmergentPattern {
    let id: String
    let pattern: String
    let strength: Double
    let variables: [String]
}

struct CausalityIndicator {
    let causeVariable: String
    let effectVariable: String
    let causalStrength: Double
    let confidence: Double
    let statisticalEvidence: String
}

// MARK: - Output Types

struct TrendNodesOutput: Codable {
    let nodes: [TrendNode]
    let generatedAt: Date
    let metadata: [String: String]
}

struct Factor {
    let id: String
    let loading: Double
    let variance: Double
}

struct Anomaly {
    let signalId: String
    let type: AnomalyType
    let severity: AnomalySeverity
    let description: String
}

enum AnomalyType: String, CaseIterable {
    case unusuallyHighStrength
    case frequencySpike
    case patternBreak
    case correlationAnomaly
}

enum AnomalySeverity: String, CaseIterable {
    case low
    case medium
    case high
    case critical
}

// MARK: - Extensions

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - CGPoint Import

import SwiftUI
