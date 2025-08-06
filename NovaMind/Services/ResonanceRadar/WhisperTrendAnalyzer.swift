import Foundation

// MARK: - Whisper Trend Analysis Helper
class WhisperTrendAnalyzer {
    
    func performWhisperAnalysis(
        from data: InputStreamData,
        frequencies: [Double],
        amplification: Double
    ) -> WhisperResults {
        let trendResults = extractWhisperTrends(data, amplification: amplification)
        let weakSignals = detectWeakSignals(data, threshold: 0.1)
        
        return WhisperResults(
            emergingSignals: trendResults.signals,
            weakSignals: weakSignals,
            trendStrength: trendResults.strength,
            confidence: calculateConfidence(trendResults.strength),
            metadata: ["amplification": amplification, "signal_count": Double(weakSignals.count)]
        )
    }
    
    private func extractWhisperTrends(
        _ data: InputStreamData,
        amplification: Double
    ) -> (signals: [EmergingSignal], strength: Double) {
        var emergingSignals: [EmergingSignal] = []
        let trendWindow = min(20, data.timeSeriesData.count / 4)
        
        // Sliding window analysis for trend detection
        for windowStart in stride(from: 0, to: data.timeSeriesData.count - trendWindow, by: trendWindow / 2) {
            let windowEnd = min(windowStart + trendWindow, data.timeSeriesData.count)
            let windowData = Array(data.timeSeriesData[windowStart..<windowEnd])
            
            let trend = calculateTrendStrength(windowData)
            if trend > 0.3 {
                let signal = EmergingSignal(
                    signalType: "whisper_trend",
                    strength: trend * amplification,
                    frequency: Double(windowStart) / Double(data.timeSeriesData.count),
                    confidence: min(1.0, trend * 2.0),
                    metadata: ["window_start": Double(windowStart), "trend": trend]
                )
                emergingSignals.append(signal)
            }
        }
        
        let averageStrength = emergingSignals.isEmpty ? 0.0 :
            emergingSignals.map { $0.strength }.reduce(0, +) / Double(emergingSignals.count)
        
        return (signals: emergingSignals, strength: averageStrength)
    }
    
    private func detectWeakSignals(_ data: InputStreamData, threshold: Double) -> [WeakSignal] {
        var weakSignals: [WeakSignal] = []
        let signalWindow = 10
        
        for index in stride(from: 0, to: data.timeSeriesData.count - signalWindow, by: signalWindow) {
            let windowEnd = min(index + signalWindow, data.timeSeriesData.count)
            let segment = Array(data.timeSeriesData[index..<windowEnd])
            
            let variance = calculateVariance(segment)
            if variance > threshold && variance < threshold * 3 {
                let weakSignal = WeakSignal(
                    signalId: "weak_\(index)",
                    amplitude: variance,
                    frequency: Double(index) / Double(data.timeSeriesData.count),
                    phase: calculatePhase(segment),
                    confidence: min(1.0, variance / threshold)
                )
                weakSignals.append(weakSignal)
            }
        }
        
        return weakSignals
    }
    
    private func calculateTrendStrength(_ data: [Double]) -> Double {
        guard data.count > 1 else { return 0.0 }
        
        let indexedData = data.enumerated().map { (Double($0.offset), $0.element) }
        let xMean = indexedData.map { $0.0 }.reduce(0, +) / Double(data.count)
        let yMean = indexedData.map { $0.1 }.reduce(0, +) / Double(data.count)
        
        let numerator = indexedData.map { ($0.0 - xMean) * ($0.1 - yMean) }.reduce(0, +)
        let denominator = indexedData.map { pow($0.0 - xMean, 2) }.reduce(0, +)
        
        guard denominator > 0 else { return 0.0 }
        
        let slope = numerator / denominator
        return min(1.0, abs(slope) / data.count)
    }
    
    private func calculateVariance(_ data: [Double]) -> Double {
        guard !data.isEmpty else { return 0.0 }
        
        let mean = data.reduce(0, +) / Double(data.count)
        let variance = data.map { pow($0 - mean, 2) }.reduce(0, +) / Double(data.count)
        return variance
    }
    
    private func calculatePhase(_ data: [Double]) -> Double {
        guard data.count > 1 else { return 0.0 }
        
        // Simple phase calculation based on zero crossings
        var zeroCrossings = 0
        for index in 1..<data.count where (data[index-1] >= 0) != (data[index] >= 0) {
            zeroCrossings += 1
        }
        
        return Double(zeroCrossings) / Double(data.count)
    }
    
    private func calculateConfidence(_ strength: Double) -> Double {
        return min(1.0, max(0.0, strength * 1.2))
    }
}
