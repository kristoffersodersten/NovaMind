import Foundation

// MARK: - Ethics Validator

class EthicsValidator {
    func validateEcho(_ echo: SemanticEcho, _ classification: EchoClassification) async -> Bool {
        // Ethics validation based on Swedish principles

        // 1. Noise protection - filter out low-quality signals
        if echo.strength < 0.3 {
            return false
        }

        // 2. EXPLICITLY AVOID popularity metrics
        // We do NOT check how many others have similar echoes
        // We do NOT weight by consensus or frequency

        // 3. Respect as constant - ensure echo doesn't violate respect principles
        if await containsDisrespectfulContent(echo) {
            return false
        }

        // 4. FOCUS EXCLUSIVELY on semantic depth and deviation magnitude
        let semanticDepth = await calculateSemanticDepth(echo)
        let deviationMagnitude = await calculateDeviationMagnitude(echo)

        // Quality gate: Both semantic depth AND deviation must meet thresholds
        let semanticThreshold = 0.4  // Meaningful content
        let deviationThreshold = 0.3 // Sufficient novelty

        let isSemanticallySufficient = semanticDepth > semanticThreshold
        let isNovelEnough = deviationMagnitude > deviationThreshold

        // Additional check: Prevent echo chambers by rejecting similar content
        let isNotEchoChambering = await checkAgainstEchoChamber(echo)

        return isSemanticallySufficient && isNovelEnough && isNotEchoChambering
    }

    private func containsDisrespectfulContent(_ echo: SemanticEcho) async -> Bool {
        // Check for content that violates respect principles
        let disrespectfulPatterns = ["bias", "discrimination", "harmful", "offensive", "dismissive"]
        return disrespectfulPatterns.contains { pattern in
            echo.content.lowercased().contains(pattern)
        }
    }

    private func calculateSemanticDepth(_ echo: SemanticEcho) async -> Double {
        // SEMANTIC DEPTH calculation - measures conceptual richness, NOT popularity
        let words = echo.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        guard !words.isEmpty else { return 0.0 }

        let uniqueWords = Set(words.map { $0.lowercased() })
        let diversity = Double(uniqueWords.count) / Double(words.count)

        // Measure conceptual complexity through linguistic markers
        let conceptualMarkers = [
            "because", "therefore", "however", "although", "considering",
            "implies", "suggests", "indicates", "reveals", "demonstrates",
            "potential", "underlying", "fundamental", "systematic"
        ]

        let conceptualCount = words.filter { word in
            conceptualMarkers.contains(word.lowercased())
        }.count

        let complexityScore = min(1.0, Double(conceptualCount) / 3.0)
        let semanticScore = (diversity * 0.6) + (complexityScore * 0.4)

        return min(1.0, semanticScore * 1.3) // Boost genuine semantic content
    }

    private func calculateDeviationMagnitude(_ echo: SemanticEcho) async -> Double {
        // DEVIATION MAGNITUDE - measures novelty from patterns, NOT popularity
        let baselinePatterns = await getBaselineSemanticPatterns()

        let echoFingerprint = generateSemanticFingerprint(echo.content)
        var totalDeviation = 0.0

        for baseline in baselinePatterns {
            let deviation = calculateSemanticDistance(echoFingerprint, baseline)
            totalDeviation += deviation
        }

        let averageDeviation = baselinePatterns.isEmpty ? 0.5 : totalDeviation / Double(baselinePatterns.count)

        // Weight by signal intrinsic strength, not external validation
        let intrinsicWeight = echo.strength * 0.9
        let timeRelevance = calculateTimeRelevance(echo.timestamp)

        return min(1.0, averageDeviation * intrinsicWeight * timeRelevance)
    }

    private func checkAgainstEchoChamber(_ echo: SemanticEcho) async -> Bool {
        // Prevent echo chamber effects - reject if too similar to recent echoes
        // This is NOT about popularity, but about ensuring diversity
        let recentEchoes = await getRecentEchoes(limit: 50)

        for recentEcho in recentEchoes {
            let similarity = calculateContentSimilarity(echo.content, recentEcho.content)
            if similarity > 0.85 { // Too similar to recent content
                return false
            }
        }

        return true
    }

    // HELPER METHODS for semantic analysis (NOT popularity)

    private func getBaselineSemanticPatterns() async -> [SemanticPattern] {
        // Get established semantic patterns for deviation comparison
        return [
            SemanticPattern(fingerprint: [0.3, 0.7, 0.2, 0.8, 0.5]),
            SemanticPattern(fingerprint: [0.6, 0.4, 0.9, 0.1, 0.7]),
            SemanticPattern(fingerprint: [0.2, 0.8, 0.3, 0.6, 0.4])
        ]
    }

    private func generateSemanticFingerprint(_ content: String) -> [Double] {
        // Generate semantic fingerprint based on content structure, not frequency
        let words = content.components(separatedBy: .whitespacesAndNewlines)
        let sentenceCount = content.components(separatedBy: .punctuationCharacters).count
        let questionWords = words.filter { ["what", "why", "how", "when", "where"].contains($0.lowercased()) }.count
        let actionWords = words.filter { word in word.hasSuffix("ing") || word.hasSuffix("ed") }.count
        let abstractConcepts = words.filter { word in word.count > 7 }.count

        return [
            Double(questionWords) / Double(words.count),
            Double(actionWords) / Double(words.count),
            Double(abstractConcepts) / Double(words.count),
            Double(sentenceCount) / Double(words.count) * 10,
            Double(content.count) / 200.0 // Normalized length
        ]
    }

    private func calculateSemanticDistance(_ fingerprint1: [Double], _ fingerprint2: [Double]) -> Double {
        guard fingerprint1.count == fingerprint2.count else { return 1.0 }

        let squaredDifferences = zip(fingerprint1, fingerprint2).map { pow($0 - $1, 2) }
        let euclideanDistance = sqrt(squaredDifferences.reduce(0, +))

        return min(1.0, euclideanDistance)
    }

    private func calculateTimeRelevance(_ timestamp: Date) -> Double {
        let timeSinceEcho = Date().timeIntervalSince(timestamp)
        let hoursSince = timeSinceEcho / 3600.0

        // Fresher echoes are more relevant, but not based on popularity
        return max(0.3, 1.0 - (hoursSince / 24.0)) // Decay over 24 hours
    }

    private func getRecentEchoes(limit: Int) async -> [SemanticEcho] {
        // Mock implementation - would fetch from actual echo buffer
        return []
    }

    private func calculateContentSimilarity(_ content1: String, _ content2: String) -> Double {
        let words1 = Set(content1.lowercased().components(separatedBy: .whitespacesAndNewlines))
        let words2 = Set(content2.lowercased().components(separatedBy: .whitespacesAndNewlines))

        let intersection = words1.intersection(words2)
        let union = words1.union(words2)

        return union.isEmpty ? 0.0 : Double(intersection.count) / Double(union.count)
    }
}
