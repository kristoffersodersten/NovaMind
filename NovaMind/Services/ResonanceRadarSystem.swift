import Foundation
import Combine
import SwiftUI

// MARK: - Main Resonance Radar System Orchestrator

final class ResonanceRadarSystem: ObservableObject {
    @Published var isActive = false
    @Published var currentSignals: [ResonanceSignal] = []
    @Published var trends: [TrendNode] = []
    @Published var correlations: [FutureCorrelation] = []
    @Published var anomalies: [Anomaly] = []
    
    private let inputManager = InputStreamManager()
    private let resonanceAnalyzer = ResonanceAnalyzer()
    private let resultsProcessor = ResonanceResultsProcessor()
    private let outputGenerator = OutputGenerator()
    private let anomalyDetector = AnomalyDetector()
    
    private var cancellables = Set<AnyCancellable>()
    private var radarTimer: Timer?
    
    // MARK: - Configuration
    
    private let configuration = RadarConfiguration(
        scanInterval: 5.0,
        spectralResolution: 1024,
        whisperSensitivity: 0.7,
        clusterMinSize: 5,
        correlationThreshold: 0.6
    )
    
    // MARK: - Public Interface
    
    func start() {
        guard !isActive else { return }
        
        isActive = true
        setupRealtimeProcessing()
        startRadarScanning()
    }
    
    func stop() {
        isActive = false
        radarTimer?.invalidate()
        radarTimer = nil
        cancellables.removeAll()
    }
    
    func processData(_ data: InputStreamData) async {
        // Perform spectral analysis
        let spectralResults = await resonanceAnalyzer.performSpectralAnalysis(
            data,
            resolution: configuration.spectralResolution
        )
        
        // Amplify whisper trends
        let whisperResults = await resonanceAnalyzer.amplifyWhisperTrends(
            data,
            sensitivity: configuration.whisperSensitivity
        )
        
        // Cluster weak signals
        let clusterResults = await resonanceAnalyzer.clusterWeakSignals(
            data,
            minClusterSize: configuration.clusterMinSize
        )
        
        // Analyze correlations
        let correlationResults = await resonanceAnalyzer.analyzeCorrelations(
            data,
            threshold: configuration.correlationThreshold
        )
        
        // Process results
        let processedResults = resultsProcessor.processResonanceResults(
            spectral: spectralResults,
            whisper: whisperResults,
            cluster: clusterResults,
            correlation: correlationResults
        )
        
        // Update state on main thread
        await MainActor.run {
            updateState(with: processedResults)
        }
        
        // Detect anomalies
        let detectedAnomalies = anomalyDetector.detectAnomalies(processedResults.resonanceSignals)
        
        await MainActor.run {
            self.anomalies = detectedAnomalies
        }
    }
    
    // MARK: - Private Methods
    
    private func setupRealtimeProcessing() {
        inputManager.dataStreamPublisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] data in
                Task {
                    await self?.processData(data)
                }
            }
            .store(in: &cancellables)
    }
    
    private func startRadarScanning() {
        radarTimer = Timer.scheduledTimer(
            withTimeInterval: configuration.scanInterval,
            repeats: true
        ) { [weak self] _ in
            Task {
                await self?.performPeriodicScan()
            }
        }
    }

    private func performPeriodicScan() async {
        let currentData = await inputManager.collectCurrentData()
        await processData(currentData)
    }

    private func updateState(with results: ProcessedResults) {
        self.currentSignals = results.resonanceSignals
        self.trends = results.trendNodes
        self.correlations = results.futureCorrelations
    }

    // MARK: - Public Output Methods

    func exportTrendNodes() async -> TrendNodesOutput {
        return await outputGenerator.generateTrendNodesOutput(trends)
    }

    func exportCorrelations() async -> Data {
        return await outputGenerator.generateFutureCorrelationsOutput(correlations)
    }
    
    func exportCausalityCandidates() async -> String {
        let processedResults = resultsProcessor.processResonanceResults(
            spectral: SpectralResults.empty,
            whisper: WhisperResults.empty,
            cluster: ClusterResults.empty,
            correlation: CorrelationResults.empty
        )
        return await outputGenerator.generateCausalityCandidatesOutput(
            processedResults.causalityCandidates
        )
    }
    
    func performFactorAnalysis(_ data: InputStreamData) async -> [Factor] {
        return anomalyDetector.performFactorAnalysis(data)
    }
}

// MARK: - Configuration

struct RadarConfiguration {
    let scanInterval: TimeInterval
    let spectralResolution: Int
    let whisperSensitivity: Double
    let clusterMinSize: Int
    let correlationThreshold: Double
}
