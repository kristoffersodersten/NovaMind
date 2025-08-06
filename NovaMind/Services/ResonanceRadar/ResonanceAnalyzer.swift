import Foundation

// MARK: - Simplified Core Analysis Orchestrator

class ResonanceAnalyzer {

    private let signalProcessor = SignalProcessor()
    private let clusteringEngine = ClusteringEngine()
    private let grangerAnalyzer = GrangerCausalityAnalyzer()
    private let whisperAnalyzer = WhisperTrendAnalyzer()

    // MARK: - Main Analysis Methods

    func performSpectralAnalysis(_ data: InputStreamData, resolution: Int) async -> SpectralResults {
        // Apply windowing function and compute FFT
        let spectralData = processSpectralData(data)

        // Calculate spectral metrics
        let metrics = calculateSpectralMetrics(spectralData, data: data)

        return SpectralResults(
            dominantFrequencies: metrics.dominantFrequencies,
            harmonicContent: metrics.harmonicContent,
            spectralCentroid: metrics.spectralCentroid,
            spectralBandwidth: metrics.spectralBandwidth,
            spectralRolloff: metrics.spectralRolloff
        )
    }

    private func processSpectralData(_ data: InputStreamData) -> (magnitudeSpectrum: [Double], frequencies: [Double]) {
        // Apply windowing function to the data
        let windowedData = signalProcessor.applyWindowFunction(data.timeSeriesData, function: .hamming)

        // Compute FFT
        let fftResult = signalProcessor.computeFFT(windowedData)

        // Extract magnitude spectrum
        let magnitudeSpectrum = fftResult.map {
            sqrt($0.real * $0.real + $0.imaginary * $0.imaginary)
        }

        // Calculate spectral centroid (brightness)
        let frequencies = (0..<magnitudeSpectrum.count).map {
            Double($0) * data.sampleRate / Double(magnitudeSpectrum.count)
        }

        return (magnitudeSpectrum, frequencies)
    }

    private func calculateSpectralMetrics(
        _ spectralData: (magnitudeSpectrum: [Double], frequencies: [Double]),
        data: InputStreamData
    ) -> SpectralMetrics {

        let magnitudeSpectrum = spectralData.magnitudeSpectrum
        let frequencies = spectralData.frequencies
        let totalMagnitude = magnitudeSpectrum.reduce(0, +)

        var spectralCentroid: Double = 0
        if totalMagnitude > 0 {
            spectralCentroid = zip(frequencies, magnitudeSpectrum)
                .map { $0.0 * $0.1 }
                .reduce(0, +) / totalMagnitude
        }

        // Calculate spectral bandwidth
        let centroidIndex = Int(spectralCentroid * Double(magnitudeSpectrum.count) / data.sampleRate)
        var bandwidthSum: Double = 0
        var magnitudeSum: Double = 0

        for (index, magnitude) in magnitudeSpectrum.enumerated() {
            let deviation = abs(Double(index) - Double(centroidIndex))
            bandwidthSum += deviation * magnitude
            magnitudeSum += magnitude
        }

        let spectralBandwidth = magnitudeSum > 0 ? bandwidthSum / magnitudeSum : 0

        // Calculate spectral rolloff (85% energy point)
        let totalEnergy = magnitudeSpectrum.map { $0 * $0 }.reduce(0, +)
        let rolloffThreshold = totalEnergy * 0.85
        var cumulativeEnergy: Double = 0
        var spectralRolloff: Double = 0

        for (index, magnitude) in magnitudeSpectrum.enumerated() {
            cumulativeEnergy += magnitude * magnitude
            if cumulativeEnergy >= rolloffThreshold {
                spectralRolloff = frequencies[index]
                break
            }
        }

        // Find dominant frequencies and harmonic content
        let dominantFrequencies = signalProcessor.findSpectralPeaks(
            magnitudeSpectrum,
            frequencies: frequencies
        )
        let harmonicContent = signalProcessor.calculateHarmonicContent(
            dominantFrequencies,
            spectrum: magnitudeSpectrum,
            allFreqs: frequencies
        )

        return SpectralMetrics(
            dominantFrequencies: dominantFrequencies,
            harmonicContent: harmonicContent,
            spectralCentroid: spectralCentroid,
            spectralBandwidth: spectralBandwidth,
            spectralRolloff: spectralRolloff
        )
    }

    func amplifyWhisperTrends(_ data: InputStreamData, sensitivity: Double) async -> WhisperResults {
        let amplification = 2.5

        // Use the dedicated whisper trend analyzer
        return whisperAnalyzer.performWhisperAnalysis(
            from: data,
            frequencies: [],
            amplification: amplification
        )
    }

    func clusterWeakSignals(_ data: InputStreamData, minClusterSize: Int) async -> ClusterResults {
        let maxClusters = 20

        // Extract weak signals and prepare feature vectors
        let weakSignals = extractWeakSignals(data)
        let featureVectors = weakSignals.map { signal in
            return FeatureVector(
                amplitude: signal.amplitude,
                frequency: signal.frequency,
                phase: signal.phase,
                duration: signal.duration,
                trend: signal.trend?.rawValue ?? 0
            )
        }

        guard featureVectors.count >= minClusterSize else {
            return ClusterResults(clusters: [], stability: [], characteristics: [])
        }

        // Perform clustering using the clustering engine
        let optimalClusterCount = clusteringEngine.findOptimalClusterCount(
            featureVectors, maxClusters: maxClusters
        )
        let clusters = clusteringEngine.performKMeansClustering(
            featureVectors, clusterCount: optimalClusterCount
        )

        // Calculate cluster metrics
        let stability = clusteringEngine.calculateClusterStability(clusters)
        let characteristics = clusteringEngine.analyzeClusterCharacteristics(clusters)

        return ClusterResults(
            clusters: clusters,
            stability: stability,
            characteristics: characteristics
        )
    }

    func analyzeCorrelations(_ data: InputStreamData, threshold: Double) async -> CorrelationResults {
        let streamNames = ["social", "economic", "technology", "cultural", "environment"]
        let streamCount = streamNames.count

        // Initialize correlation matrix
        var correlationMatrix = Array(
            repeating: Array(repeating: 0.0, count: streamCount), count: streamCount
        )

        var timeDelayedCorrelations: [TimeDelayedCorrelation] = []
        var causalityIndicators: [CausalityIndicator] = []

        // Calculate correlations between all stream pairs
        for rowIndex in 0..<streamCount {
            for columnIndex in 0..<streamCount {
                let stream1Data = getStreamData(streamNames[rowIndex], from: data)
                let stream2Data = getStreamData(streamNames[columnIndex], from: data)

                let correlation = signalProcessor.calculatePearsonCorrelation(stream1Data, stream2Data)
                correlationMatrix[rowIndex][columnIndex] = correlation

                // Analyze time-delayed correlations and causality
                let context = StreamAnalysisContext(
                    stream1: streamNames[rowIndex],
                    stream2: streamNames[columnIndex],
                    data1: stream1Data,
                    data2: stream2Data,
                    maxLag: 24,
                    significanceLevel: 0.05,
                    causalityThreshold: 0.7
                )

                analyzeStreamPair(
                    context: context,
                    timeDelayedCorrelations: &timeDelayedCorrelations,
                    causalityIndicators: &causalityIndicators
                )
            }
        }

        // Apply feedback weighting
        applyFeedbackWeighting(&correlationMatrix, weight: 0.8)

        return CorrelationResults(
            correlationMatrix: correlationMatrix,
            timeDelayedCorrelations: timeDelayedCorrelations,
            causalityIndicators: causalityIndicators
        )
    }

    // MARK: - Helper Methods

    private func generateTrendPrediction(
        window: [Double], strength: Double, timeOffset: Double
    ) -> TrendPrediction {
        let trend: TrendDirection = strength > 0.5 ? .rising : (strength < -0.5 ? .falling : .stable)

        return TrendPrediction(
            direction: trend,
            strength: abs(strength),
            probability: min(1.0, abs(strength) * 2),
            timeHorizon: TimeInterval(3600 + strength * 86400),
            description: "Trend \(trend.rawValue) with strength \(String(format: "%.2f", strength))"
        )
    }

    private func calculateConfidence(_ amplifiedStrength: Double, originalStrength: Double) -> Double {
        let amplificationRatio = amplifiedStrength / max(originalStrength, 0.001)
        return max(0.1, 1.0 / amplificationRatio)
    }

    private func extractWeakSignals(_ data: InputStreamData) -> [WeakSignal] {
        let threshold = 0.3

        return data.timeSeriesData.enumerated().compactMap { index, value in
            if abs(value) < threshold && abs(value) > 0.05 {
                return WeakSignal(
                    amplitude: abs(value),
                    frequency: Double(index) / Double(data.timeSeriesData.count),
                    phase: atan2(value, 1.0),
                    duration: 1.0,
                    trend: value > 0 ? .rising : .falling
                )
            }
            return nil
        }
    }

    private func getStreamData(_ streamName: String, from data: InputStreamData) -> [Double] {
        let streamIndex = ["social", "economic", "technology", "cultural", "environment"]
            .firstIndex(of: streamName) ?? 0
        let chunkSize = data.timeSeriesData.count / 5
        let startIndex = streamIndex * chunkSize
        let endIndex = min(startIndex + chunkSize, data.timeSeriesData.count)
        return Array(data.timeSeriesData[startIndex..<endIndex])
    }

    private func analyzeStreamPair(
        context: StreamAnalysisContext,
        timeDelayedCorrelations: inout [TimeDelayedCorrelation],
        causalityIndicators: inout [CausalityIndicator]
    ) {
        // Check for time-delayed correlations
        for lag in 1...context.maxLag {
            let delayedCorrelation = signalProcessor.calculateTimeDelayedCorrelation(
                context.data1, context.data2, lag: lag
            )

            if abs(delayedCorrelation) > context.significanceLevel {
                timeDelayedCorrelations.append(TimeDelayedCorrelation(
                    stream1: context.stream1,
                    stream2: context.stream2,
                    correlation: delayedCorrelation,
                    lag: lag,
                    significance: 1.0 - abs(delayedCorrelation)
                ))
            }
        }

        // Test for causality
        let causalityStrength = grangerAnalyzer.testGrangerCausality(
            cause: context.data1,
            effect: context.data2,
            maxLag: context.maxLag
        )

        if causalityStrength > context.causalityThreshold {
            causalityIndicators.append(CausalityIndicator(
                causeVariable: context.stream1,
                effectVariable: context.stream2,
                causalStrength: causalityStrength,
                confidence: min(1.0, causalityStrength * 1.5),
                statisticalEvidence: "Granger causality test p < \(context.significanceLevel)"
            ))
        }
    }

    private func applyFeedbackWeighting(_ matrix: inout [[Double]], weight: Double) {
        for rowIndex in 0..<matrix.count {
            for columnIndex in 0..<matrix[rowIndex].count where matrix[rowIndex][columnIndex] > 0.5 {
                matrix[rowIndex][columnIndex] *= (1.0 + weight)
            }
        }
    }
}
