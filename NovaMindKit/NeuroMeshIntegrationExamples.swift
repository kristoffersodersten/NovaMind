import Foundation
import Combine

// MARK: - Neuromesh Integration Examples

/// Demonstrates the three core Swedish design principles in action:
/// - Självreflektion (Self-Reflection): Personal growth and awareness
/// - Samarbete (Collaboration): Meaningful participation and mutual respect
/// - Kollektiv Förbättring (Collective Improvement): Shared learning and progress

class NeuroMeshIntegrationExamples: ObservableObject {
    private let neuromeshSystem: NeuroMeshMemorySystem
    private let emotionalModel: NeuroMeshEmotionalModel
    private let resonanceRadar: NeuroMeshResonanceRadar
    private let exampleExecutor: NeuroMeshExampleExecutor

    @Published var exampleResults: [IntegrationExampleResult] = []
    @Published var isRunningExamples = false

    init(
        neuromeshSystem: NeuroMeshMemorySystem,
        emotionalModel: NeuroMeshEmotionalModel,
        resonanceRadar: NeuroMeshResonanceRadar
    ) {
        self.neuromeshSystem = neuromeshSystem
        self.emotionalModel = emotionalModel
        self.resonanceRadar = resonanceRadar
        self.exampleExecutor = NeuroMeshExampleExecutor(
            neuromeshSystem: neuromeshSystem,
            emotionalModel: emotionalModel,
            resonanceRadar: resonanceRadar
        )
    }

    // MARK: - Public Interface

    func demonstrateSelfReflectionLearning() async {
        await executeExample(exampleExecutor.demonstrateSelfReflectionLearning)
    }

    func demonstrateEmotionalSelfAwareness() async {
        await executeExample(exampleExecutor.demonstrateEmotionalSelfAwareness)
    }

    func demonstrateMutualConsentCollaboration() async {
        await executeExample(exampleExecutor.demonstrateMutualConsentCollaboration)
    }

    func demonstrateCrossAgentLearning() async {
        await executeExample(exampleExecutor.demonstrateCrossAgentLearning)
    }

    func demonstrateEmergentPatternRecognition() async {
        await executeExample(exampleExecutor.demonstrateEmergentPatternRecognition)
    }

    func demonstrateErrorLearningAndPrevention() async {
        await executeExample(exampleExecutor.demonstrateErrorLearningAndPrevention)
    }

    // MARK: - Private Methods

    private func executeExample(_ example: @escaping () async -> IntegrationExampleResult) async {
        await MainActor.run { isRunningExamples = true }
        let result = await example()
        await addExampleResult(result)
        await MainActor.run { isRunningExamples = false }
    }

    private func addExampleResult(_ result: IntegrationExampleResult) async {
        await MainActor.run {
            exampleResults.append(result)
        }
    }
}
