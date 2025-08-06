import Foundation

// MARK: - Extensions for Empty Results

extension SpectralResults {
    static let empty = SpectralResults(
        dominantFrequencies: [],
        harmonicContent: [],
        spectralCentroid: 0.0,
        spectralBandwidth: 0.0,
        spectralRolloff: 0.0
    )
}

extension WhisperResults {
    static let empty = WhisperResults(
        trendPredictions: [],
        confidenceScores: [],
        amplificationFactors: []
    )
}

extension ClusterResults {
    static let empty = ClusterResults(
        clusters: [],
        stability: [],
        characteristics: []
    )
}

extension CorrelationResults {
    static let empty = CorrelationResults(
        correlationMatrix: [],
        timeDelayedCorrelations: [],
        causalityIndicators: []
    )
}
