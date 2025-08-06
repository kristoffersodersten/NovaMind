import Foundation

// MARK: - Mentor Classes

class HawkMentor {
    func validateSpeculation(_ map: ResonanceMap) async -> MentorValidation {
        // Hawk: Focus on speculative validation - can these patterns be trusted?
        let speculativePatterns = map.clusters.filter { $0.confidence > 0.6 }
        let validationScore = await assessSpeculativeValidity(speculativePatterns)

        return MentorValidation(
            mentor: "Hawk",
            confidence: validationScore,
            feedback: "Speculative analysis: \(speculativePatterns.count) patterns validated",
            concerns: validationScore < 0.7 ? ["Low confidence in speculative patterns"] : []
        )
    }

    private func assessSpeculativeValidity(_ patterns: [PatternCluster]) async -> Double {
        // Assess how well these patterns predict future needs
        let totalConfidence = patterns.map { $0.confidence }.reduce(0, +)
        let averageConfidence = patterns.isEmpty ? 0.0 : totalConfidence / Double(patterns.count)

        return averageConfidence * 0.9 // Hawk is naturally cautious
    }
}

class DoveMentor {
    func reduceBias(_ map: ResonanceMap) async -> MentorValidation {
        // Dove: Focus on bias reduction - are we being fair and inclusive?
        let biasScore = await assessBias(map.clusters)
        let reducedBiasScore = 1.0 - biasScore // Higher is better

        return MentorValidation(
            mentor: "Dove",
            confidence: reducedBiasScore,
            feedback: "Bias analysis: \(String(format: "%.1f", biasScore * 100))% bias detected",
            concerns: biasScore > 0.3 ? ["Potential bias in pattern recognition"] : []
        )
    }

    private func assessBias(_ clusters: [PatternCluster]) async -> Double {
        // Check for bias in pattern recognition
        let typeDistribution = Dictionary(grouping: clusters) { $0.type }
        let maxTypeCount = typeDistribution.values.map { $0.count }.max() ?? 0
        let totalClusters = clusters.count

        // If one type dominates, there might be bias
        let dominanceRatio = totalClusters > 0 ? Double(maxTypeCount) / Double(totalClusters) : 0.0

        return dominanceRatio > 0.6 ? 0.4 : 0.1 // Bias score (lower is better)
    }
}
