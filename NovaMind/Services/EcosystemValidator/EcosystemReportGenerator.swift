import Foundation

// MARK: - Ecosystem Validation Report Generator

class EcosystemReportGenerator {

    static func generateAllReports(
        context: ValidationContext,
        validationResults: [ValidationResult],
        ecosystemMap: EcosystemMap?
    ) async {
        await generateResonantValidationReport(
            validationResults: validationResults,
            ecosystemMap: ecosystemMap
        )

        await generateEntityMemoryMap(context: context, ecosystemMap: ecosystemMap)
        await generateMentorAgentPairings(context: context)
        await generateDriftLog(context: context)
    }

    // MARK: - Resonant Validation Report

    private static func generateResonantValidationReport(
        validationResults: [ValidationResult],
        ecosystemMap: EcosystemMap?
    ) async {
        let report = ResonantValidationReport(
            validationId: UUID().uuidString,
            timestamp: Date(),
            overallScore: ecosystemMap?.overallHealth ?? 0.0,
            componentScores: validationResults.reduce(into: [String: Double]()) { result, validation in
                result[validation.component] = validation.score
            },
            criticalFindings: validationResults.flatMap {
                $0.details.filter { !$0.passed && $0.importance == .high }
            },
            recommendations: generateRecommendations(from: validationResults),
            nextValidationDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        )

        await saveReportToFile(report, filename: "resonant_validation_report.json")
    }

    // MARK: - Entity Memory Map

    private static func generateEntityMemoryMap(
        context: ValidationContext,
        ecosystemMap: EcosystemMap?
    ) async {
        let allEntities = (ecosystemMap?.mentors ?? []) +
                         (ecosystemMap?.agents ?? []) +
                         (ecosystemMap?.coralNodes ?? [])

        let memoryMap = EntityMemoryMap(
            entities: allEntities,
            memoryConnections: EcosystemMapGenerator.generateMemoryConnections(context: context),
            memoryHealth: EcosystemMapGenerator.calculateMemoryHealth(context: context),
            lastUpdated: Date()
        )

        await saveMemoryMapToFile(memoryMap, filename: "entity_memory_map.json")
    }

    // MARK: - Mentor-Agent Pairings Report

    private static func generateMentorAgentPairings(context: ValidationContext) async {
        let pairingsContent = context.mentorRegistry.activePairings.map { pairing in
            """
            ## Pairing: \(pairing.id)
            - **Mentor:** \(pairing.mentorId)
            - **Agent:** \(pairing.agentId)
            - **Created:** \(pairing.createdAt)
            - **Resonance Score:** \(String(format: "%.2f", pairing.resonanceScore))
            - **Reflections:** \(pairing.reflectionLog.count)

            ### Recent Reflections:
            \(pairing.reflectionLog.suffix(3).map { "- \($0.content)" }.joined(separator: "\n"))

            ---
            """
        }.joined(separator: "\n\n")

        let fullContent = """
        # Mentor-Agent Pairings Report
        Generated: \(Date())

        \(pairingsContent)
        """

        await saveTextToFile(fullContent, filename: "mentor_agent_pairings.md")
    }

    // MARK: - Drift Log

    private static func generateDriftLog(context: ValidationContext) async {
        let driftEntries = context.resonanceRadar.resonanceHistory
            .filter { $0.resonanceScore < 0.7 }
            .map { event in
                let scoreText = String(format: "%.2f", event.resonanceScore)
                return "\(event.timestamp): Resonance drift detected for \(event.mentorId) - Score: \(scoreText)"
            }

        let driftContent = """
        Performance Drift Log
        Generated: \(Date())

        \(driftEntries.joined(separator: "\n"))
        """

        await saveTextToFile(driftContent, filename: "drift_log.txt")
    }

    // MARK: - Helper Methods

    private static func generateRecommendations(from results: [ValidationResult]) -> [String] {
        var recommendations: [String] = []

        let lowScoreResults = results.filter { $0.score < 0.8 }
        for result in lowScoreResults {
            let scoreText = String(format: "%.2f", result.score)
            recommendations.append("Improve \(result.component) - current score: \(scoreText)")
        }

        if recommendations.isEmpty {
            recommendations.append("All ecosystem components are performing well")
        }

        return recommendations
    }

    // MARK: - File Operations

    private static func saveReportToFile(_ report: ResonantValidationReport, filename: String) async {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        if let data = try? encoder.encode(report) {
            let reportPath = "/Volumes/kristoffersodersten/NovaMind/\(filename)"
            try? data.write(to: URL(fileURLWithPath: reportPath))
        }
    }

    private static func saveMemoryMapToFile(_ memoryMap: EntityMemoryMap, filename: String) async {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        if let data = try? encoder.encode(memoryMap) {
            let mapPath = "/Volumes/kristoffersodersten/NovaMind/\(filename)"
            try? data.write(to: URL(fileURLWithPath: mapPath))
        }
    }

    private static func saveTextToFile(_ content: String, filename: String) async {
        let filePath = "/Volumes/kristoffersodersten/NovaMind/\(filename)"
        try? content.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
    }
}
