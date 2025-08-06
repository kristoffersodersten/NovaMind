import Foundation

// MARK: - Results Processing and Generation

class ResonanceResultsProcessor {
    
    func processResonanceResults(
        spectral: SpectralResults,
        whisper: WhisperResults,
        cluster: ClusterResults,
        correlation: CorrelationResults
    ) -> ProcessedResults {
        // Generate trend nodes from spectral analysis
        let spectralTrends = generateTrendNodesFromSpectral(spectral)

        // Generate future correlations from whisper trends
        let whisperCorrelations = generateCorrelationsFromWhisper(whisper)

        // Generate causality candidates from clustering
        let clusterCausality = generateCausalityFromClusters(cluster)

        // Merge correlation results
        let correlationCausality = generateCausalityFromCorrelations(correlation)

        // Generate overall resonance signals
        let resonanceSignals = synthesizeResonanceSignals(
            spectral: spectral,
            whisper: whisper,
            cluster: cluster,
            correlation: correlation
        )

        return ProcessedResults(
            trendNodes: spectralTrends,
            futureCorrelations: whisperCorrelations,
            causalityCandidates: clusterCausality + correlationCausality,
            resonanceSignals: resonanceSignals
        )
    }

    // MARK: - Generation Methods

    private func generateTrendNodesFromSpectral(_ spectral: SpectralResults) -> [TrendNode] {
        return spectral.dominantFrequencies.enumerated().map { index, frequency in
            TrendNode(
                id: "spectral-\(index)",
                frequency: frequency,
                amplitude: spectral.harmonicContent[safe: index] ?? 0.0,
                phase: Double.random(in: 0...(2 * .pi)),
                trend: .emerging,
                confidence: calculateFrequencyConfidence(frequency),
                timestamp: Date()
            )
        }
    }

    private func generateCorrelationsFromWhisper(_ whisper: WhisperResults) -> [FutureCorrelation] {
        return whisper.trendPredictions.enumerated().map { index, prediction in
            FutureCorrelation(
                id: "whisper-\(index)",
                sourceSignal: "whisper_trend_\(index)",
                targetSignal: "future_outcome_\(index)",
                strength: whisper.confidenceScores[safe: index] ?? 0.0,
                timeHorizon: TimeInterval.random(in: 3600...259200), // 1 hour to 3 days
                probability: prediction.probability,
                description: prediction.description
            )
        }
    }

    private func generateCausalityFromClusters(_ cluster: ClusterResults) -> [CausalityCandidate] {
        return cluster.clusters.enumerated().map { index, clusterData in
            CausalityCandidate(
                id: "cluster-\(index)",
                cause: clusterData.centroid.description,
                effect: "cluster_outcome_\(index)",
                strength: cluster.stability[safe: index] ?? 0.0,
                evidence: clusterData.points.map { $0.description },
                confidence: cluster.characteristics[safe: index]?.confidence ?? 0.0
            )
        }
    }

    private func generateCausalityFromCorrelations(_ correlation: CorrelationResults) -> [CausalityCandidate] {
        return correlation.causalityIndicators.enumerated().map { index, indicator in
            CausalityCandidate(
                id: "correlation-\(index)",
                cause: indicator.causeVariable,
                effect: indicator.effectVariable,
                strength: indicator.causalStrength,
                evidence: [indicator.statisticalEvidence],
                confidence: indicator.confidence
            )
        }
    }

    private func synthesizeResonanceSignals(
        spectral: SpectralResults,
        whisper: WhisperResults,
        cluster: ClusterResults,
        correlation: CorrelationResults
    ) -> [ResonanceSignal] {
        var signals: [ResonanceSignal] = []

        // High-amplitude spectral signals
        for (index, frequency) in spectral.dominantFrequencies.enumerated() {
            if let amplitude = spectral.harmonicContent[safe: index], amplitude > 0.7 {
                signals.append(ResonanceSignal(
                    id: "spectral-resonance-\(index)",
                    type: .spectral,
                    strength: amplitude,
                    frequency: frequency,
                    source: "spectral_analysis",
                    metadata: [
                        "spectral_centroid": String(spectral.spectralCentroid),
                        "bandwidth": String(spectral.spectralBandwidth)
                    ],
                    timestamp: Date()
                ))
            }
        }

        // Strong whisper predictions
        for (index, prediction) in whisper.trendPredictions.enumerated()
        where prediction.probability > 0.8 {
            signals.append(ResonanceSignal(
                id: "whisper-resonance-\(index)",
                type: .whisper,
                strength: prediction.probability,
                frequency: 0.0, // Whisper signals don't have frequency
                source: "whisper_amplification",
                metadata: [
                    "prediction": prediction.description,
                    "confidence": String(whisper.confidenceScores[safe: index] ?? 0.0)
                ],
                timestamp: Date()
            ))
        }

        return signals
    }

    // MARK: - Helper Methods

    private func calculateFrequencyConfidence(_ frequency: Double) -> Double {
        // Calculate confidence based on frequency characteristics
        return min(1.0, frequency * 0.8 + 0.2)
    }
}

// MARK: - Output Generation

class OutputGenerator {
    
    func generateTrendNodesOutput(_ trendNodes: [TrendNode]) async -> TrendNodesOutput {
        return TrendNodesOutput(
            nodes: trendNodes,
            generatedAt: Date(),
            metadata: [
                "algorithm_version": "1.0",
                "node_count": String(trendNodes.count),
                "generation_method": "spectral_analysis"
            ]
        )
    }

    func generateFutureCorrelationsOutput(_ correlations: [FutureCorrelation]) async -> Data {
        // Convert to JSON data
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let outputData = FutureCorrelationsOutput(
            correlations: correlations,
            generatedAt: Date(),
            metadata: [
                "correlation_count": String(correlations.count),
                "method": "whisper_trend_amplification"
            ]
        )
        
        return (try? encoder.encode(outputData)) ?? Data()
    }

    func generateCausalityCandidatesOutput(_ candidates: [CausalityCandidate]) async -> String {
        var csvContent = "id,cause,effect,strength,confidence,evidence_count\n"
        
        for candidate in candidates {
            csvContent += "\(candidate.id),\(candidate.cause),\(candidate.effect)," +
                         "\(candidate.strength),\(candidate.confidence),\(candidate.evidence.count)\n"
        }
        
        return csvContent
    }
}

// MARK: - Anomaly Detection

class AnomalyDetector {
    
    func detectAnomalies(_ signals: [ResonanceSignal]) -> [Anomaly] {
        var anomalies: [Anomaly] = []
        
        for signal in signals {
            // Check for unusually high strength
            if signal.strength > 0.9 {
                anomalies.append(Anomaly(
                    signalId: signal.id,
                    type: .unusuallyHighStrength,
                    severity: .high,
                    description: "Signal strength \(signal.strength) exceeds normal threshold"
                ))
            }
            
            // Check for frequency spikes
            if signal.frequency > 0.8 {
                anomalies.append(Anomaly(
                    signalId: signal.id,
                    type: .frequencySpike,
                    severity: .medium,
                    description: "Frequency spike detected at \(signal.frequency)"
                ))
            }
        }
        
        return anomalies
    }
    
    func performFactorAnalysis(_ data: InputStreamData) -> [Factor] {
        // Simplified factor analysis
        return [
            Factor(id: "factor-1", loading: 0.8, variance: 0.6),
            Factor(id: "factor-2", loading: 0.7, variance: 0.4),
            Factor(id: "factor-3", loading: 0.6, variance: 0.3)
        ]
    }
}

// MARK: - Supporting Types

struct ProcessedResults {
    let trendNodes: [TrendNode]
    let futureCorrelations: [FutureCorrelation]
    let causalityCandidates: [CausalityCandidate]
    let resonanceSignals: [ResonanceSignal]
}

struct FutureCorrelationsOutput: Codable {
    let correlations: [FutureCorrelation]
    let generatedAt: Date
    let metadata: [String: String]
}

// MARK: - Extensions for Codable Support

extension FutureCorrelation: Codable {}
extension TrendNode: Codable {}
extension TrendDirection: Codable {}
