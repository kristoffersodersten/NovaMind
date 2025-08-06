import Combine
import SwiftUI


/// Central store för appens inställningar, används som EnvironmentObject i SettingsView.
@MainActor
public class SettingsStore: ObservableObject {
    // API-inställningar
    @Published public var apiKey: String = ""
    @Published public var hasAPIKey: Bool = false

    // Chat-inställningar
    @Published public var temperature: Double = 1.0
    @Published public var maxTokens: Int = 1024

    // Modellinställningar
    @Published public var selectedModel: String = "deepseek-chat"
    @Published public var availableModels: [String] = [
        "deepseek-chat", "deepseek-coder", "gpt-4", "gpt-3.5-turbo", "claude-3-opus"
    ]

    // Tema/utseende
    @Published public var theme: String = "system"
    @Published public var fontSize: Double = 15.0
    @Published public var selectedTheme: String = "system"
    @Published public var availableThemes: [String] = ["system", "light", "dark"]

    // Övriga inställningar (lägg till efter behov)
    // ...

    public init() {}

    // Hjälpmetoder
    public func updateAPIKey(_ key: String) {
        apiKey = key
        hasAPIKey = !key.isEmpty
    }
}
