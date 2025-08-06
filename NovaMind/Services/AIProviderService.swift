import Combine
import Foundation


// MARK: - AI Provider Models

enum AIProvider: String, CaseIterable {
    case openai
    case anthropic
    case deepseek
    case local

public struct APIKey {
    let rawValue: String

    public init(_ value: String) {
        self.rawValue = value
    }
}

public struct AIProviderConfig: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var type: AIProviderType
    public var endpoint: String
    public var apiKey: String
    public var model: String
    public var maxTokens: Int
    public var temperature: Double
    public var isEnabled: Bool

    public init(id: UUID = UUID(), name: String, type: AIProviderType, endpoint: String,
                apiKey: String, model: String, maxTokens: Int = 4096,
                temperature: Double = 0.7, isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.type = type
        self.endpoint = endpoint
        self.apiKey = apiKey
        self.model = model
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.isEnabled = isEnabled
    }
}

// MARK: - AI Provider Service för NovaMind AI-integration
@MainActor
public class AIProviderService: ObservableObject {
    @Published var providers: [AIProviderConfig] = []
    @Published var selectedProvider: AIProviderConfig?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var availableModels: [String] = []

    private var cancellables = Set<AnyCancellable>()

    public init() {
        loadProviders()
    }

    // MARK: - Public Methods
    public func loadProviders() {
        isLoading = true

        // Standard providers enligt NovaMind configuration
        let defaultProviders = [
            AIProviderConfig(
                id: UUID(),
                name: "OpenAI",
                type: .openai,
                endpoint: "https://api.openai.com/v1",
                apiKey: "",
                model: "gpt-4",
                maxTokens: 4096,
                temperature: 0.7,
                isEnabled: true
            ),
            AIProviderConfig(
                id: UUID(),
                name: "Anthropic Claude",
                type: .anthropic,
                endpoint: "https://api.anthropic.com/v1",
                apiKey: "",
                model: "claude-3-opus-20240229",
                maxTokens: 4096,
                temperature: 0.7,
                isEnabled: false
            )
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.providers = defaultProviders
            self.selectedProvider = defaultProviders.first
            self.availableModels = defaultProviders.map { $0.model }
            self.isLoading = false
        }
    }

    public func selectProvider(_ provider: AIProviderConfig) {
        selectedProvider = provider
    }

    public func updateProvider(_ provider: AIProviderConfig) {
        if let index = providers.firstIndex(where: { $0.id == provider.id }) {
            providers[index] = provider
            self.availableModels = providers.map { $0.model }
        }
    }

    public func addProvider(_ provider: AIProviderConfig) {
        providers.append(provider)
        self.availableModels = providers.map { $0.model }
    }

    public func removeProvider(_ provider: AIProviderConfig) {
        providers.removeAll { $0.id == provider.id }
        if selectedProvider?.id == provider.id {
            selectedProvider = providers.first
        }
    }
}
