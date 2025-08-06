import Foundation

// MARK: - Output Analyzer

class OutputAnalyzer {
    func clusterPatterns(_ echoes: [SemanticEcho]) async -> [PatternCluster] {
        // Group echoes into pattern clusters
        var clusters: [PatternCluster] = []

        // Simple clustering by echo type
        let groupedEchoes = Dictionary(grouping: echoes) { $0.type }

        for (type, echoGroup) in groupedEchoes where echoGroup.count >= 2 {
            let cluster = PatternCluster(
                id: UUID().uuidString,
                type: type,
                echoes: echoGroup,
                representativePattern: generateRepresentativePattern(echoGroup),
                confidence: calculateClusterConfidence(echoGroup),
                timestamp: Date()
            )
            clusters.append(cluster)
        }

        return clusters.sorted { $0.confidence > $1.confidence }
    }

    func generateResonanceMap(_ echoes: [SemanticEcho]) async -> ResonanceMap {
        let clusters = await clusterPatterns(echoes)
        let insights = generateResonanceInsights(clusters)

        return ResonanceMap(
            id: UUID().uuidString,
            clusters: clusters,
            insights: insights,
            averageResonance: calculateAverageResonance(echoes),
            timestamp: Date()
        )
    }

    func generateHeatmapSVG(_ map: ResonanceMap) async -> String {
        // Generate SVG visualization of resonance patterns
        return generateSemanticHeatmapSVG(map)
    }

    func isAnomalous(_ echo: SemanticEcho, _ classification: EchoClassification) async -> Bool {
        // Determine if echo represents an anomaly
        return echo.strength > 0.85 || classification == .inverseSilence
    }

    func calculateAnomalyConfidence(_ echo: SemanticEcho) async -> Double {
        return Double.random(in: 0.6...0.95)
    }

    func calculateNeedConfidence(_ echo: SemanticEcho) async -> Double {
        return Double.random(in: 0.5...0.9)
    }

    func estimateTimeframe(_ echo: SemanticEcho) async -> TimeFrame {
        let timeframes: [TimeFrame] = [.immediate, .shortTerm, .mediumTerm, .longTerm]
        return timeframes.randomElement() ?? .mediumTerm
    }

    func categorizeNeed(_ echo: SemanticEcho) async -> NeedCategory {
        let categories: [NeedCategory] = [.functionality, .performance, .usability, .reliability, .security]
        return categories.randomElement() ?? .functionality
    }

    func estimateClusterTimeframe(_ cluster: PatternCluster) async -> TimeFrame {
        return .mediumTerm
    }

    func estimateImpact(_ cluster: PatternCluster) async -> ImpactLevel {
        return cluster.confidence > 0.9 ? .high : (cluster.confidence > 0.7 ? .medium : .low)
    }

    func analyzeEchoPatterns(_ echo: SemanticEcho) async -> [EchoPattern] {
        // Real-time pattern analysis
        return [
            EchoPattern(
                description: "Echo pattern for \(echo.type.rawValue)",
                significance: echo.strength,
                category: echo.type
            )
        ]
    }

    private func generateRepresentativePattern(_ echoes: [SemanticEcho]) -> String {
        // Generate pattern description from echo group
        let contents = echoes.map { $0.content }
        return "Pattern from \(echoes.count) echoes: \(contents.first ?? "Unknown")"
    }

    private func calculateClusterConfidence(_ echoes: [SemanticEcho]) -> Double {
        // Calculate cluster confidence based on SEMANTIC DEPTH and DEVIATION, NOT popularity
        guard !echoes.isEmpty else { return 0.0 }

        // Average semantic depth of echoes in cluster
        let semanticDepths = echoes.map { echo in
            calculateSemanticDepthSync(echo)
        }
        let averageSemanticDepth = semanticDepths.reduce(0, +) / Double(semanticDepths.count)

        // Average deviation magnitude
        let deviationMagnitudes = echoes.map { echo in
            calculateDeviationMagnitudeSync(echo)
        }
        let averageDeviation = deviationMagnitudes.reduce(0, +) / Double(deviationMagnitudes.count)

        // Intrinsic signal strength (not consensus)
        let averageStrength = echoes.map { $0.strength }.reduce(0, +) / Double(echoes.count)

        // Diversity bonus (more diverse clusters are more valuable, not larger ones)
        let uniqueTypes = Set(echoes.map { $0.type }).count
        let diversityBonus = min(0.2, Double(uniqueTypes) * 0.05)

        // NO SIZE BONUS - we explicitly avoid popularity metrics
        let confidence = (averageSemanticDepth * 0.4) +
                        (averageDeviation * 0.3) +
                        (averageStrength * 0.2) +
                        diversityBonus

        return min(1.0, confidence)
    }

    // Synchronous versions for use in non-async contexts
    private func calculateSemanticDepthSync(_ echo: SemanticEcho) -> Double {
        let words = echo.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        guard !words.isEmpty else { return 0.0 }

        let uniqueWords = Set(words.map { $0.lowercased() })
        let diversity = Double(uniqueWords.count) / Double(words.count)

        let conceptualMarkers = ["because", "therefore", "however", "although", "considering", "implies", "suggests"]
        let conceptualDepth = words.filter { word in
            conceptualMarkers.contains(word.lowercased())
        }.count

        let complexityScore = min(1.0, Double(conceptualDepth) / 5.0)
        let semanticScore = (diversity * 0.7) + (complexityScore * 0.3)

        return min(1.0, semanticScore * 1.2)
    }

    private func calculateDeviationMagnitudeSync(_ echo: SemanticEcho) -> Double {
        // Simplified sync version for clustering
        let timeRelevance = max(0.3, 1.0 - (Date().timeIntervalSince(echo.timestamp) / 86400.0))
        return echo.strength * 0.8 * timeRelevance
    }

    private func generateResonanceInsights(_ clusters: [PatternCluster]) -> [ResonanceInsight] {
        return clusters.compactMap { cluster in
            if cluster.confidence > 0.7 {
                return ResonanceInsight(
                    description: "Strong resonance in \(cluster.type.rawValue) patterns",
                    confidence: cluster.confidence,
                    category: cluster.type
                )
            }
            return nil
        }
    }

    private func calculateAverageResonance(_ echoes: [SemanticEcho]) -> Double {
        guard !echoes.isEmpty else { return 0.0 }
        return echoes.map { $0.strength }.reduce(0, +) / Double(echoes.count)
    }

    private func generateSemanticHeatmapSVG(_ map: ResonanceMap) -> String {
        return """
        <svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <radialGradient id="resonanceGradient" cx="50%" cy="50%" r="50%">
                <stop offset="0%" stop-color="#FF6B6B" stop-opacity="0.8"/>
                <stop offset="50%" stop-color="#4ECDC4" stop-opacity="0.6"/>
                <stop offset="100%" stop-color="#45B7D1" stop-opacity="0.4"/>
            </radialGradient>
        </defs>

        <!-- Background -->
        <rect width="800" height="600" fill="#1a1a1a"/>

        <!-- Title -->
        <text x="400" y="30" font-family="Arial" font-size="18" fill="#ffffff" text-anchor="middle">
            Semantic360 Future Needs Heatmap
        </text>

        <!-- Resonance clusters -->
        \(generateClusterVisuals(map.clusters))

        <!-- Insights legend -->
        <text x="50" y="550" font-family="Arial" font-size="12" fill="#cccccc">
            Generated: \(DateFormatter.shortDateTime.string(from: map.timestamp))
        </text>
        <text x="50" y="570" font-family="Arial" font-size="12" fill="#cccccc">
            Average Resonance: \(String(format: "%.2f", map.averageResonance))
        </text>

        </svg>
        """
    }

    private func generateClusterVisuals(_ clusters: [PatternCluster]) -> String {
        var visuals = ""
        let centerX = 400
        let centerY = 300
        let maxRadius = 200

        for (index, cluster) in clusters.enumerated() {
            let angle = Double(index) * 2 * .pi / Double(clusters.count)
            let radius = cluster.confidence * Double(maxRadius)
            let xPosition = centerX + Int(cos(angle) * radius * 0.7)
            let yPosition = centerY + Int(sin(angle) * radius * 0.7)
            let size = cluster.confidence * 20 + 5

            visuals += """
            <circle cx="\(xPosition)" cy="\(yPosition)" r="\(size)"
                    fill="url(#resonanceGradient)" opacity="\(cluster.confidence)"/>
            <text x="\(xPosition)" y="\(yPosition - Int(size) - 5)"
                  font-family="Arial" font-size="10" fill="#ffffff"
                  text-anchor="middle">
                \(cluster.type.rawValue)
            </text>

            """
        }

        return visuals
    }
}
