import Combine
import Foundation


// MARK: - Neuromesh Resonance Radar

/// Identifies weak echoes in data streams, pull requests, commits, and interactions
/// that may indicate future changes, needs, or improvements
class NeuroMeshResonanceRadar: ObservableObject {
    @Published private(set) var isScanning = false
    @Published private(set) var lastAnalysis: Date?
    @Published private(set) var correlationMap: CorrelationMap?
    @Published private(set) var hypothesisNodes: [HypothesisNode] = []
    @Published private(set) var causalityLinks: [CausalityLink] = []

    // Analysis components
    private let vectorEmbedder = ContinuousVectorEmbedder()
    private let trendAnalyzer = TemporalTrendAnalyzer()
    private let noveltyDetector = NoveltyDetector()

    // Data streams
    private var dataStreams: [String: DataStream] = [:]

    init() {
        setupDataStreams()
        startContinuousEmbedding()
    }

    // MARK: - Core Analysis Methods

    /// Perform daily comprehensive analysis
    func performDailyAnalysis() async {
        await MainActor.run {
            isScanning = true
        }

        do {
            // 1. Continuous vector embedding
            let embeddings = await vectorEmbedder.generateDailyEmbeddings()

            // 2. Temporal trend analysis
            let trends = await trendAnalyzer.analyzeTrends(embeddings)

            // 3. Novelty detection using KL divergence and cosine drift
            let novelSignals = await noveltyDetector.detectNovelty(embeddings, trends)

            // 4. Generate correlation map
            let correlations = await generateCorrelationMap(embeddings, trends, novelSignals)

            // 5. Create hypothesis nodes
            let hypotheses = await generateHypothesisNodes(correlations, novelSignals)

            // 6. Identify causality candidates
            let causalities = await identifyCausalityLinks(hypotheses, trends)

            await MainActor.run {
                self.correlationMap = correlations
                self.hypothesisNodes = hypotheses
                self.causalityLinks = causalities
                self.lastAnalysis = Date()
                self.isScanning = false
            }

            // 7. Generate visualization
            await generateRadarVisualization()

        } catch {
            await MainActor.run {
                self.isScanning = false
            }
            print("❌ Resonance radar analysis failed: \(error)")
        }
    }

    /// Process real-time memory events
    func processMemoryEvent(content: any NeuroMeshMemoryContent, context: NeuroMeshContext) async {
        let signal = ResonanceSignal(
            id: UUID().uuidString,
            content: content.searchableText,
            context: context.purpose.rawValue,
            timestamp: Date(),
            strength: calculateSignalStrength(content, context),
            source: .memoryEvent
        )

        await vectorEmbedder.processSignal(signal)
        await updateRealtimeAnalysis(signal)
    }

    /// Enhance memory results with resonance insights
    func enhanceWithResonanceInsights<T: NeuroMeshMemoryContent>(
        results: [NeuroMeshResult<T>],
        query: String,
        context: NeuroMeshContext
    ) async -> [NeuroMeshResult<T>] {
        guard let correlationMap = correlationMap else { return results }

        return results.map { result in
            let enhancedResonance = calculateEnhancedResonance(
                result: result,
                query: query,
                context: context,
                correlationMap: correlationMap
            )

            return NeuroMeshResult(
                content: result.content,
                similarity: result.similarity,
                timestamp: result.timestamp,
                source: result.source,
                emotionalResonance: enhancedResonance
            )
        }.sorted { $0.emotionalResonance > $1.emotionalResonance }
    }

    func getHealth() async -> RadarHealth {
        let isActive = !isScanning
        let signalStrength = await vectorEmbedder.getSignalStrength()
        let analysisAccuracy = await trendAnalyzer.getAccuracy()

        return RadarHealth(
            isActive: isActive,
            signalStrength: signalStrength,
            analysisAccuracy: analysisAccuracy,
            lastScan: lastAnalysis ?? Date.distantPast
        )
    }

    // MARK: - Private Analysis Methods

    private func setupDataStreams() {
        dataStreams = [
            "git_commits": DataStream(type: .gitCommits, endpoint: "/data/git/commits"),
            "pull_requests": DataStream(type: .pullRequests, endpoint: "/data/git/pulls"),
            "agent_interactions": DataStream(type: .agentInteractions, endpoint: "/data/interactions"),
            "build_results": DataStream(type: .buildResults, endpoint: "/data/builds"),
            "code_reviews": DataStream(type: .codeReviews, endpoint: "/data/reviews"),
            "error_logs": DataStream(type: .errorLogs, endpoint: "/data/errors"),
            "user_feedback": DataStream(type: .userFeedback, endpoint: "/data/feedback")
        ]
    }

    private func startContinuousEmbedding() {
        Timer.publish(every: 300, on: .main, in: .common) // Every 5 minutes
            .autoconnect()
            .sink { _ in
                Task {
                    await self.vectorEmbedder.processDataStreams(self.dataStreams)
                }
            }
            .store(in: &vectorEmbedder.cancellables)
    }

    private func generateCorrelationMap(
        _ embeddings: [VectorEmbedding],
        _ trends: [TrendPattern],
        _ signals: [NoveltySignal]
    ) async -> CorrelationMap {
        let correlations = await withTaskGroup(of: Correlation.self) { group in
            var correlations: [Correlation] = []

            // Cross-correlate embeddings
            for i in 0..<embeddings.count {
                for j in (i+1)..<embeddings.count {
                    group.addTask {
                        await self.calculateCorrelation(embeddings[i], embeddings[j])
                    }
                }
            }

            for await correlation in group {
                correlations.append(correlation)
            }

            return correlations
        }

        return CorrelationMap(
            correlations: correlations.filter { $0.strength > 0.3 },
            timestamp: Date(),
            dimensions: embeddings.first?.vector.count ?? 768
        )
    }

    private func generateHypothesisNodes(
        _ correlationMap: CorrelationMap,
        _ novelSignals: [NoveltySignal]
    ) async -> [HypothesisNode] {
        var nodes: [HypothesisNode] = []

        // Generate nodes from strong correlations
        for correlation in correlationMap.correlations.filter({ $0.strength > 0.7 }) {
            let hypothesis = await generateHypothesisFromCorrelation(correlation)
            nodes.append(hypothesis)
        }

        // Generate nodes from novel signals
        for signal in novelSignals.filter({ $0.noveltyScore > 0.8 }) {
            let hypothesis = await generateHypothesisFromNovelty(signal)
            nodes.append(hypothesis)
        }

        return nodes.sorted { $0.confidence > $1.confidence }
    }

    private func identifyCausalityLinks(
        _ hypotheses: [HypothesisNode],
        _ trends: [TrendPattern]
    ) async -> [CausalityLink] {
        var links: [CausalityLink] = []

        for i in 0..<hypotheses.count {
            for j in (i+1)..<hypotheses.count {
                let link = await analyzeCausalityBetween(hypotheses[i], hypotheses[j], trends)
                if link.strength > 0.5 {
                    links.append(link)
                }
            }
        }

        return links.sorted { $0.strength > $1.strength }
    }

    private func calculateSignalStrength(
        _ content: any NeuroMeshMemoryContent,
        _ context: NeuroMeshContext
    ) -> Double {
        var strength = 0.5 // Base strength

        // Increase strength based on context purpose
        switch context.purpose {
        case .selfReflection: strength += 0.2
        case .collaboration: strength += 0.3
        case .improvement: strength += 0.4
        case .errorLearning: strength += 0.3
        case .trustBuilding: strength += 0.2
        }

        // Increase strength based on ethical flags
        strength += Double(context.ethicalFlags.count) * 0.1

        return min(1.0, strength)
    }

    private func updateRealtimeAnalysis(_ signal: ResonanceSignal) async {
        // Update real-time analysis with new signal
        await trendAnalyzer.incorporateRealtimeSignal(signal)
        await noveltyDetector.checkForInstantNovelty(signal)
    }

    private func calculateEnhancedResonance<T: NeuroMeshMemoryContent>(
        result: NeuroMeshResult<T>,
        query: String,
        context: NeuroMeshContext,
        correlationMap: CorrelationMap
    ) -> Double {
        var baseResonance = result.emotionalResonance

        // Check if result matches any strong correlations
        for correlation in correlationMap.correlations.filter({ $0.strength > 0.6 }) {
            if correlation.matches(query: query, content: result.content.searchableText) {
                baseResonance += correlation.strength * 0.3
            }
        }

        // Check hypothesis relevance
        for hypothesis in hypothesisNodes {
            if hypothesis.isRelevantTo(query: query, context: context) {
                baseResonance += hypothesis.confidence * 0.2
            }
        }

        return min(1.0, baseResonance)
    }

    private func calculateCorrelation(_ embeddingA: VectorEmbedding, _ embeddingB: VectorEmbedding) async -> Correlation {
        let similarity = cosineSimilarity(embeddingA.vector, embeddingB.vector)
        let temporalAlignment = calculateTemporalAlignment(embeddingA.timestamp, embeddingB.timestamp)

        return Correlation(
            sourceA: embeddingA.source,
            sourceB: embeddingB.source,
            strength: similarity * temporalAlignment,
            type: .vectorSimilarity,
            timestamp: Date()
        )
    }

    private func cosineSimilarity(_ vectorA: [Double], _ vectorB: [Double]) -> Double {
        guard vectorA.count == vectorB.count else { return 0.0 }

        let dotProduct = zip(vectorA, vectorB).map(*).reduce(0, +)
        let magnitudeA = sqrt(vectorA.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(vectorB.map { $0 * $0 }.reduce(0, +))

        guard magnitudeA > 0 && magnitudeB > 0 else { return 0.0 }

        return dotProduct / (magnitudeA * magnitudeB)
    }

    private func calculateTemporalAlignment(_ timeA: Date, _ timeB: Date) -> Double {
        let timeDiff = abs(timeA.timeIntervalSince(timeB))
        let maxAlignment = 3600.0 // 1 hour
        return max(0.0, 1.0 - (timeDiff / maxAlignment))
    }

    private func generateHypothesisFromCorrelation(_ correlation: Correlation) async -> HypothesisNode {
        return HypothesisNode(
            id: UUID().uuidString,
            hypothesis: "Strong correlation detected between \(correlation.sourceA) and \(correlation.sourceB)",
            confidence: correlation.strength,
            evidence: [correlation.description],
            domain: "correlation_analysis",
            timestamp: Date()
        )
    }

    private func generateHypothesisFromNovelty(_ signal: NoveltySignal) async -> HypothesisNode {
        return HypothesisNode(
            id: UUID().uuidString,
            hypothesis: "Novel pattern detected: \(signal.description)",
            confidence: signal.noveltyScore,
            evidence: [signal.evidence],
            domain: signal.domain,
            timestamp: Date()
        )
    }

    private func analyzeCausalityBetween(
        _ hypothesisA: HypothesisNode,
        _ hypothesisB: HypothesisNode,
        _ trends: [TrendPattern]
    ) async -> CausalityLink {
        // Simplified causality analysis
        let temporalOrder = hypothesisA.timestamp < hypothesisB.timestamp
        let domainSimilarity = calculateDomainSimilarity(hypothesisA.domain, hypothesisB.domain)
        let trendSupport = calculateTrendSupport(hypothesisA, hypothesisB, trends)

        let strength = (domainSimilarity + trendSupport) / 2.0 * (temporalOrder ? 1.0 : 0.5)

        return CausalityLink(
            cause: hypothesisA.id,
            effect: hypothesisB.id,
            strength: strength,
            confidence: min(hypothesisA.confidence, hypothesisB.confidence),
            timestamp: Date()
        )
    }

    private func calculateDomainSimilarity(_ domainA: String, _ domainB: String) -> Double {
        return domainA == domainB ? 1.0 : 0.3
    }

    private func calculateTrendSupport(
        _ hypothesisA: HypothesisNode,
        _ hypothesisB: HypothesisNode,
        _ trends: [TrendPattern]
    ) -> Double {
        // Check if trends support the causality
        return 0.6 // Simplified
    }

    private func generateRadarVisualization() async {
        guard let correlationMap = correlationMap else { return }

        let svg = generateSVGVisualization(
            correlationMap: correlationMap,
            hypotheses: hypothesisNodes,
            causalities: causalityLinks
        )

        // Save to dashboard/radar_insights.svg
        try? svg.write(to: URL(fileURLWithPath: "/dashboard/radar_insights.svg"), atomically: true, encoding: .utf8)
    }

    private func generateSVGVisualization(
        correlationMap: CorrelationMap,
        hypotheses: [HypothesisNode],
        causalities: [CausalityLink]
    ) -> String {
        var svg = """
        <svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <radialGradient id="radarGradient" cx="50%" cy="50%" r="50%">
                <stop offset="0%" stop-color="#4CAF50" stop-opacity="0.8"/>
                <stop offset="100%" stop-color="#1976D2" stop-opacity="0.3"/>
            </radialGradient>
        </defs>

        <!-- Radar background -->
        <circle cx="400" cy="300" r="250" fill="url(#radarGradient)" stroke="#2196F3" stroke-width="2"/>

        <!-- Grid lines -->
        <line x1="150" y1="300" x2="650" y2="300" stroke="#2196F3" stroke-width="1" opacity="0.5"/>
        <line x1="400" y1="50" x2="400" y2="550" stroke="#2196F3" stroke-width="1" opacity="0.5"/>

        """

        // Add hypothesis nodes
        for (index, hypothesis) in hypotheses.prefix(10).enumerated() {
            let angle = Double(index) * 2 * .pi / 10
            let radius = 150 + hypothesis.confidence * 80
            let x = 400 + cos(angle) * radius
            let y = 300 + sin(angle) * radius

            svg += """
            <circle cx="\(x)" cy="\(y)" r="\(hypothesis.confidence * 8 + 3)" fill="#FF9800" opacity="0.8"/>
            <text x="\(x)" y="\(y - 15)" font-family="Arial" font-size="10" fill="#333" text-anchor="middle">\(hypothesis.domain)</text>

            """
        }

        // Add correlation lines
        for correlation in correlationMap.correlations.prefix(15).filter({ $0.strength > 0.5 }) {
            let opacity = correlation.strength
            let strokeWidth = correlation.strength * 3 + 1

            svg += """
            <line x1="\(200 + correlation.strength * 100)" y1="\(100)" x2="\(600 - correlation.strength * 100)" y2="\(500)"
                  stroke="#E91E63" stroke-width="\(strokeWidth)" opacity="\(opacity)"/>

            """
        }

        svg += """

        <!-- Center point -->
        <circle cx="400" cy="300" r="5" fill="#F44336"/>
        <text x="400" y="320" font-family="Arial" font-size="12" fill="#333" text-anchor="middle">Resonance Center</text>

        <!-- Legend -->
        <text x="50" y="30" font-family="Arial" font-size="14" fill="#333" font-weight="bold">Neuromesh Resonance Radar</text>
        <text x="50" y="50" font-family="Arial" font-size="10" fill="#666">Generated: \(DateFormatter().string(from: Date()))</text>

        </svg>
        """

        return svg
    }
}

// MARK: - Supporting Classes

class ContinuousVectorEmbedder: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    private var signalBuffer: [ResonanceSignal] = []

    func generateDailyEmbeddings() async -> [VectorEmbedding] {
        // Generate embeddings for accumulated signals
        return signalBuffer.map { signal in
            VectorEmbedding(
                id: signal.id,
                vector: generateVector(for: signal.content),
                source: signal.source.rawValue,
                timestamp: signal.timestamp
            )
        }
    }

    func processSignal(_ signal: ResonanceSignal) async {
        signalBuffer.append(signal)

        // Keep buffer manageable
        if signalBuffer.count > 1000 {
            signalBuffer = Array(signalBuffer.suffix(1000))
        }
    }

    func processDataStreams(_ streams: [String: DataStream]) async {
        for (name, stream) in streams {
            let data = await fetchStreamData(stream)
            for dataPoint in data {
                let signal = ResonanceSignal(
                    id: UUID().uuidString,
                    content: dataPoint.content,
                    context: name,
                    timestamp: dataPoint.timestamp,
                    strength: dataPoint.strength,
                    source: stream.type
                )
                await processSignal(signal)
            }
        }
    }

    func getSignalStrength() async -> Double {
        let recentSignals = signalBuffer.filter { $0.timestamp.timeIntervalSinceNow > -3600 }
        guard !recentSignals.isEmpty else { return 0.0 }

        return recentSignals.map { $0.strength }.reduce(0, +) / Double(recentSignals.count)
    }

    private func generateVector(for content: String) -> [Double] {
        // Mock vector generation - in production would use actual embedding model
        return Array(repeating: Double.random(in: -1...1), count: 768)
    }

    private func fetchStreamData(_ stream: DataStream) async -> [StreamDataPoint] {
        // Mock data fetching - in production would fetch from actual endpoints
        return [
            StreamDataPoint(content: "Sample data from \(stream.type.rawValue)", timestamp: Date(), strength: Double.random(in: 0.1...1.0))
        ]
    }
}

class TemporalTrendAnalyzer: ObservableObject {
    private var trendHistory: [TrendPattern] = []

    func analyzeTrends(_ embeddings: [VectorEmbedding]) async -> [TrendPattern] {
        // Analyze temporal trends in embeddings
        let timeWindows = groupByTimeWindows(embeddings)

        return timeWindows.compactMap { window in
            analyzeTrendInWindow(window)
        }
    }

    func incorporateRealtimeSignal(_ signal: ResonanceSignal) async {
        // Update real-time trend analysis
    }

    func getAccuracy() async -> Double {
        // Calculate trend analysis accuracy
        return 0.85 // Mock accuracy
    }

    private func groupByTimeWindows(_ embeddings: [VectorEmbedding]) -> [[VectorEmbedding]] {
        // Group embeddings by time windows (e.g., hourly)
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: embeddings) { embedding in
            calendar.dateInterval(of: .hour, for: embedding.timestamp)?.start ?? embedding.timestamp
        }

        return Array(grouped.values)
    }

    private func analyzeTrendInWindow(_ embeddings: [VectorEmbedding]) -> TrendPattern? {
        guard embeddings.count >= 3 else { return nil }

        // Simplified trend analysis
        return TrendPattern(
            direction: .increasing,
            strength: Double.random(in: 0.3...0.9),
            domain: "general",
            timeWindow: embeddings.first?.timestamp ?? Date(),
            confidence: Double.random(in: 0.5...0.95)
        )
    }
}

class NoveltyDetector: ObservableObject {
    private var baselineDistribution: VectorDistribution?

    func detectNovelty(_ embeddings: [VectorEmbedding], _ trends: [TrendPattern]) async -> [NoveltySignal] {
        var novelSignals: [NoveltySignal] = []

        // Establish baseline if not exists
        if baselineDistribution == nil {
            baselineDistribution = establishBaseline(embeddings)
        }

        guard let baseline = baselineDistribution else { return [] }

        for embedding in embeddings {
            let klDivergence = calculateKLDivergence(embedding.vector, baseline.mean)
            let cosineDrift = calculateCosineDrift(embedding.vector, baseline.reference)

            if klDivergence > 0.7 || cosineDrift > 0.6 {
                let novelty = NoveltySignal(
                    id: embedding.id,
                    description: "Novel pattern detected in \(embedding.source)",
                    noveltyScore: max(klDivergence, cosineDrift),
                    domain: embedding.source,
                    evidence: "KL: \(String(format: "%.3f", klDivergence)), Drift: \(String(format: "%.3f", cosineDrift))",
                    timestamp: embedding.timestamp
                )
                novelSignals.append(novelty)
            }
        }

        return novelSignals
    }

    func checkForInstantNovelty(_ signal: ResonanceSignal) async {
        // Check for instant novelty in real-time signals
    }

    private func establishBaseline(_ embeddings: [VectorEmbedding]) -> VectorDistribution {
        let vectors = embeddings.map { $0.vector }
        let dimensions = vectors.first?.count ?? 768

        // Calculate mean vector
        let mean = (0..<dimensions).map { dimension in
            vectors.map { $0[dimension] }.reduce(0, +) / Double(vectors.count)
        }

        return VectorDistribution(
            mean: mean,
            reference: vectors.first ?? Array(repeating: 0.0, count: dimensions)
        )
    }

    private func calculateKLDivergence(_ vector: [Double], _ baseline: [Double]) -> Double {
        // Simplified KL divergence calculation
        guard vector.count == baseline.count else { return 0.0 }

        let kl = zip(vector, baseline).map { (p, q) in
            let pNorm = abs(p) + 1e-10
            let qNorm = abs(q) + 1e-10
            return pNorm * log(pNorm / qNorm)
        }.reduce(0, +)

        return min(1.0, abs(kl) / 10.0) // Normalize to 0-1
    }

    private func calculateCosineDrift(_ vector: [Double], _ reference: [Double]) -> Double {
        // Calculate cosine similarity and convert to drift
        let similarity = cosineSimilarity(vector, reference)
        return 1.0 - similarity
    }

    private func cosineSimilarity(_ vectorA: [Double], _ vectorB: [Double]) -> Double {
        guard vectorA.count == vectorB.count else { return 0.0 }

        let dotProduct = zip(vectorA, vectorB).map(*).reduce(0, +)
        let magnitudeA = sqrt(vectorA.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(vectorB.map { $0 * $0 }.reduce(0, +))

        guard magnitudeA > 0 && magnitudeB > 0 else { return 0.0 }

        return dotProduct / (magnitudeA * magnitudeB)
    }
}

// MARK: - Data Structures

struct VectorEmbedding {
    let id: String
    let vector: [Double]
    let source: String
    let timestamp: Date
}

struct TrendPattern {
    let direction: TrendDirection
    let strength: Double
    let domain: String
    let timeWindow: Date
    let confidence: Double
}

enum TrendDirection {
    case increasing
    case decreasing
    case stable
    case oscillating
}

struct NoveltySignal {
    let id: String
    let description: String
    let noveltyScore: Double
    let domain: String
    let evidence: String
    let timestamp: Date
}

struct VectorDistribution {
    let mean: [Double]
    let reference: [Double]
}

struct CorrelationMap {
    let correlations: [Correlation]
    let timestamp: Date
    let dimensions: Int
}

struct Correlation {
    let sourceA: String
    let sourceB: String
    let strength: Double
    let type: CorrelationType
    let timestamp: Date

    var description: String {
        return "Correlation between \(sourceA) and \(sourceB) (strength: \(String(format: "%.3f", strength)))"
    }

    func matches(query: String, content: String) -> Bool {
        return content.lowercased().contains(query.lowercased()) ||
               sourceA.lowercased().contains(query.lowercased()) ||
               sourceB.lowercased().contains(query.lowercased())
    }
}

enum CorrelationType {
    case vectorSimilarity
    case temporalAlignment
    case causality
    case semantic
}

struct HypothesisNode {
    let id: String
    let hypothesis: String
    let confidence: Double
    let evidence: [String]
    let domain: String
    let timestamp: Date

    func isRelevantTo(query: String, context: NeuroMeshContext) -> Bool {
        return hypothesis.lowercased().contains(query.lowercased()) ||
               domain.lowercased().contains(query.lowercased()) ||
               context.purpose.rawValue.contains(domain.lowercased())
    }
}

struct CausalityLink {
    let cause: String
    let effect: String
    let strength: Double
    let confidence: Double
    let timestamp: Date
}

struct ResonanceSignal {
    let id: String
    let content: String
    let context: String
    let timestamp: Date
    let strength: Double
    let source: SignalSource
}

enum SignalSource: String {
    case memoryEvent = "memory_event"
    case gitCommits = "git_commits"
    case pullRequests = "pull_requests"
    case agentInteractions = "agent_interactions"
    case buildResults = "build_results"
    case codeReviews = "code_reviews"
    case errorLogs = "error_logs"
    case userFeedback = "user_feedback"
}

struct DataStream {
    let type: SignalSource
    let endpoint: String
}

struct StreamDataPoint {
    let content: String
    let timestamp: Date
    let strength: Double
}
