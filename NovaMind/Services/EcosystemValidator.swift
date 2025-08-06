import Foundation
import SwiftUI

// MARK: - Ecosystem Validation Engine

/// Comprehensive validation of multi-agent ecosystem components
@MainActor
class EcosystemValidator: ObservableObject {
    static let shared = EcosystemValidator()

    @Published var validationStatus: ValidationStatus = .notStarted
    @Published var validationResults: [ValidationResult] = []
    @Published var ecosystemMap: EcosystemMap?

    private let context = ValidationContext()

    // MARK: - Main Validation Workflow

    func performFullEcosystemValidation() async {
        validationStatus = .inProgress
        validationResults.removeAll()

        // Validate all ecosystem layers
        await validateAllLayers()

        // Generate ecosystem map
        ecosystemMap = await EcosystemMapGenerator.generateEcosystemMap(
            context: context,
            validationResults: validationResults
        )

        // Generate comprehensive reports
        await EcosystemReportGenerator.generateAllReports(
            context: context,
            validationResults: validationResults,
            ecosystemMap: ecosystemMap
        )

        validationStatus = .completed
    }

    // MARK: - Layer Validation Orchestration

    private func validateAllLayers() async {
        // Validate mentorship layer
        await EcosystemComponentValidators.validateMentorshipLayer(
            context: context,
            results: &validationResults
        )

        // Validate resonance tracking
        await EcosystemComponentValidators.validateResonanceTracking(
            context: context,
            results: &validationResults
        )

        // Validate coral reef architecture
        await EcosystemComponentValidators.validateCoralReefArchitecture(
            context: context,
            results: &validationResults
        )

        // Validate constitutional interoperability
        await EcosystemComponentValidators.validateConstitutionalInteroperability(
            context: context,
            results: &validationResults
        )
    }

    // MARK: - Validation Status and Metrics

    var overallValidationScore: Double {
        guard !validationResults.isEmpty else { return 0.0 }

        let totalScore = validationResults.reduce(0.0) { sum, result in
            sum + result.score
        }

        return totalScore / Double(validationResults.count)
    }

    var criticalIssuesCount: Int {
        return validationResults.flatMap { $0.details }
            .filter { !$0.passed && $0.importance == .critical }
            .count
    }

    var hasPassedValidation: Bool {
        return overallValidationScore >= 0.7 && criticalIssuesCount == 0
    }

    // MARK: - Component-Specific Results

    func getResultsForCategory(_ category: ValidationCategory) -> ValidationResult? {
        return validationResults.first { $0.category == category }
    }

    func getFailedTestsForCategory(_ category: ValidationCategory) -> [ValidationDetail] {
        guard let result = getResultsForCategory(category) else { return [] }
        return result.details.filter { !$0.passed }
    }

    // MARK: - Reset and Cleanup

    func resetValidation() {
        validationStatus = .notStarted
        validationResults.removeAll()
        ecosystemMap = nil
    }
}
