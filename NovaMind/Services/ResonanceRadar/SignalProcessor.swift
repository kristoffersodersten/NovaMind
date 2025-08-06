import Foundation

// MARK: - Signal Processing Utilities

class SignalProcessor {
    
    // MARK: - FFT and Spectral Analysis
    
    func computeFFT(_ data: [Double]) -> [ComplexNumber] {
        // Simplified FFT implementation - in production, use Accelerate framework
        let dataCount = data.count
        var result: [ComplexNumber] = []
        
        for frequency in 0..<dataCount {
            var real: Double = 0
            var imaginary: Double = 0
            
            for time in 0..<dataCount {
                let angle = -2 * .pi * Double(frequency) * Double(time) / Double(dataCount)
                real += data[time] * cos(angle)
                imaginary += data[time] * sin(angle)
            }
            
            result.append(ComplexNumber(real: real, imaginary: imaginary))
        }
        
        return result
    }
    
    func applyWindowFunction(_ data: [Double], function: WindowFunction) -> [Double] {
        switch function {
        case .hamming:
            return data.enumerated().map { index, value in
                let windowValue = 0.54 - 0.46 * cos(2 * .pi * Double(index) / Double(data.count - 1))
                return value * windowValue
            }
        case .hanning:
            return data.enumerated().map { index, value in
                let windowValue = 0.5 * (1 - cos(2 * .pi * Double(index) / Double(data.count - 1)))
                return value * windowValue
            }
        case .blackman:
            return data.enumerated().map { index, value in
                let alpha = 0.16
                let alpha0 = (1 - alpha) / 2
                let alpha1 = 0.5
                let alpha2 = alpha / 2
                let windowValue = alpha0 - alpha1 * cos(2 * .pi * Double(index) / Double(data.count - 1)) +
                                 alpha2 * cos(4 * .pi * Double(index) / Double(data.count - 1))
                return value * windowValue
            }
        }
    }
    
    func findSpectralPeaks(_ spectrum: [Double], frequencies: [Double]) -> [Double] {
        var peaks: [Double] = []
        let threshold = (spectrum.max() ?? 0) * 0.1 // 10% of max amplitude
        
        for index in 1..<(spectrum.count - 1) {
            if spectrum[index] > threshold &&
               spectrum[index] > spectrum[index - 1] &&
               spectrum[index] > spectrum[index + 1] {
                peaks.append(frequencies[index])
            }
        }
        
        return peaks
    }
    
    func calculateHarmonicContent(_ frequencies: [Double], spectrum: [Double], allFreqs: [Double]) -> [Double] {
        return frequencies.map { frequency in
            // Find corresponding index in spectrum
            let index = allFreqs.firstIndex { abs($0 - frequency) < 0.1 } ?? 0
            return index < spectrum.count ? spectrum[index] : 0.0
        }
    }
    
    // MARK: - Statistical Analysis
    
    func calculatePearsonCorrelation(_ data1: [Double], _ data2: [Double]) -> Double {
        let length = min(data1.count, data2.count)
        guard length > 1 else { return 0 }
        
        let truncatedData1 = Array(data1.prefix(length))
        let truncatedData2 = Array(data2.prefix(length))
        
        let mean1 = truncatedData1.reduce(0, +) / Double(length)
        let mean2 = truncatedData2.reduce(0, +) / Double(length)
        
        let numerator = zip(truncatedData1, truncatedData2)
            .map { ($0.0 - mean1) * ($0.1 - mean2) }
            .reduce(0, +)
        
        let sumSquares1 = truncatedData1.map { pow($0 - mean1, 2) }.reduce(0, +)
        let sumSquares2 = truncatedData2.map { pow($0 - mean2, 2) }.reduce(0, +)
        
        let denominator = sqrt(sumSquares1 * sumSquares2)
        
        return denominator > 0 ? numerator / denominator : 0
    }
    
    func calculateTrendStrength(_ window: [Double]) -> Double {
        guard window.count > 1 else { return 0 }
        
        // Simple linear regression slope as trend strength
        let dataCount = window.count
        let xValues = (0..<dataCount).map { Double($0) }
        let xMean = xValues.reduce(0, +) / Double(dataCount)
        let yMean = window.reduce(0, +) / Double(dataCount)
        
        let numerator = zip(xValues, window).map { ($0.0 - xMean) * ($0.1 - yMean) }.reduce(0, +)
        let denominator = xValues.map { pow($0 - xMean, 2) }.reduce(0, +)
        
        return denominator > 0 ? abs(numerator / denominator) : 0
    }
    
    func calculateTimeDelayedCorrelation(_ data1: [Double], _ data2: [Double], lag: Int) -> Double {
        guard lag < data1.count && lag < data2.count else { return 0 }
        
        let shifted1 = Array(data1.dropFirst(lag))
        let shifted2 = Array(data2.dropLast(lag))
        
        return calculatePearsonCorrelation(shifted1, shifted2)
    }
}
