import Combine
import Foundation


@MainActor
class LocalModelOrchestrator: ObservableObject {
    @Published var availableModels: [String] = []
    @Published var currentModel: String?
    @Published var isModelRunning: Bool = false
    private var modelProcess: Process?
    func startModel(named modelName: String) {
        guard let path = Bundle.main.path(forResource: modelName, ofType: nil) else {
            print("Model not found.")
            return
        }
        modelProcess = Process()
        modelProcess?.executableURL = URL(fileURLWithPath: path)
        do {
            try modelProcess?.run()
            isModelRunning = true
            currentModel = modelName
        } catch {
            print("Failed to start model: \(error)")
        }
    }
    func stopModel() {
        modelProcess?.terminate()
        isModelRunning = false
        currentModel = nil
    }
}
