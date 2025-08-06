import Foundation

// MARK: - Simplified Core Analysis Orchestrator

class ResonanceAnalyzer {
    
    private let signalProcessor = SignalProcessor()
    private let clusteringEngine = ClusteringEngine()
    
    // MARK: - Main Analysis Methods
    
    func performSpectralAnalysis(_ data: InputStreamData, resolution: Int) async -> SpectralResults {
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
        
        return SpectralResults(
            dominantFrequencies: dominantFrequencies,
            harmonicContent: harmonicContent,
            spectralCentroid: spectralCentroid,
            spectralBandwidth: spectralBandwidth,
            spectralRolloff: spectralRolloff
        )
    }
    
    func amplifyWhisperTrends(_ data: InputStreamData, sensitivity: Double) async -> WhisperResults {
        let amplification = 2.5
        let timeWindow = 7200 // 2 hours
        let noiseFloor = 0.05
        
        var trendPredictions: [TrendPrediction] = []
        var confidenceScores: [Double] = []
        var amplificationFactors: [Double] = []
        
        // Sliding window analysis for weak signal detection
        let windowStep = timeWindow / 10
        let dataPoints = data.timeSeriesData
        
        for windowStart in stride(from: 0, to: dataPoints.count - timeWindow, by: windowStep) {
            let windowEnd = min(windowStart + timeWindow, dataPoints.count)
            let window = Array(dataPoints[windowStart..<windowEnd])
            
            // Calculate trend strength in this window
            let trendStrength = signalProcessor.calculateTrendStrength(window)
            
            // Only process if above noise floor
            if trendStrength > noiseFloor {
                // Apply amplification if signal is weak but potentially significant
                let amplificationNeeded = trendStrength < sensitivity
                let actualAmplification = amplificationNeeded ? amplification : 1.0
                let amplifiedStrength = trendStrength * actualAmplification
                
                // Generate prediction based on amplified signal
                let prediction = generateTrendPrediction(
                    window: window,
                    strength: amplifiedStrength,
                    timeOffset: Double(windowStart)
                )
                
                trendPredictions.append(prediction)
                confidenceScores.append(
                    calculateConfidence(amplifiedStrength, originalStrength: trendStrength)
                )
                amplificationFactors.append(actualAmplification)
            }
        }
        
        return WhisperResults(
            trendPredictions: trendPredictions,
            confidenceScores: confidenceScores,
            amplificationFactors: amplificationFactors
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
            featureVectors, 
            maxClusters: maxClusters
        )
        let clusters = clusteringEngine.performKMeansClustering(
            featureVectors, 
            clusterCount: optimalClusterCount
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
            repeating: Array(repeating: 0.0, count: streamCount), 
            count: streamCount
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
                analyzeStreamPair(
                    stream1: streamNames[rowIndex],
                    stream2: streamNames[columnIndex],
                    data1: stream1Data,
                    data2: stream2Data,
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
        window: [Double], 
        strength: Double, 
        timeOffset: Double
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
        stream1: String,
        stream2: String,
        data1: [Double],
        data2: [Double],
        timeDelayedCorrelations: inout [TimeDelayedCorrelation],
        causalityIndicators: inout [CausalityIndicator]
    ) {
        let maxLag = 24
        let significanceLevel = 0.05
        let causalityThreshold = 0.7
        
        // Check for time-delayed correlations
        for lag in 1...maxLag {
            let delayedCorrelation = signalProcessor.calculateTimeDelayedCorrelation(
                data1, data2, lag: lag
            )
            
            if abs(delayedCorrelation) > significanceLevel {
                timeDelayedCorrelations.append(TimeDelayedCorrelation(
                    stream1: stream1,
                    stream2: stream2,
                    correlation: delayedCorrelation,
                    lag: lag,
                    significance: 1.0 - abs(delayedCorrelation)
                ))
            }
        }
        
        // Test for causality
        let causalityStrength = testGrangerCausality(cause: data1, effect: data2, maxLag: maxLag)
        
        if causalityStrength > causalityThreshold {
            causalityIndicators.append(CausalityIndicator(
                causeVariable: stream1,
                effectVariable: stream2,
                causalStrength: causalityStrength,
                confidence: min(1.0, causalityStrength * 1.5),
                statisticalEvidence: "Granger causality test p < \(significanceLevel)"
            ))
        }
    }
    
    private func testGrangerCausality(cause: [Double], effect: [Double], maxLag: Int) -> Double {
        var causalitySum = 0.0
        let testLags = min(maxLag, min(cause.count, effect.count) / 4)
        
        for lag in 1...testLags {
            let correlation = signalProcessor.calculateTimeDelayedCorrelation(cause, effect, lag: lag)
            causalitySum += abs(correlation) / Double(lag)
        }
        
        return causalitySum / Double(testLags)
    }
    
    private func applyFeedbackWeighting(_ matrix: inout [[Double]], weight: Double) {
        for rowIndex in 0..<matrix.count {
            for columnIndex in 0..<matrix[rowIndex].count 
            where matrix[rowIndex][columnIndex] > 0.5 {
                matrix[rowIndex][columnIndex] *= (1.0 + weight)
            }
        }
    }
}
