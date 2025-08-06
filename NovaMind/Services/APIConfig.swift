import Foundation
import OSLog OSLog


// MARK: - Model types

/// Available DeepSeek models.
public enum DeepSeekModelType: String, CaseIterable {
    case chat    = "deepseek-chat"
    case coder   = "deepseek-coder"
    case reasoner = "deepseek-reasoner"
}

// MARK: - Configuration errors

/// Error type for missing or invalid configuration keys.
public enum ConfigurationError: Error, LocalizedError, Sendable {
    case missingKey(String)

    nonisolated public var errorDescription: String? {
        switch self {
        case .missingKey(let key):
            return "Missing required environment variable: \(key)"
        }
    }
}

// MARK: - API environment configuration

/// Central configuration for external APIs (DeepSeek, Azure).
public struct APIEnvironment {
    // MARK: Keys & settings

    public let deepSeekAPIKey: String
    public let azureSpeechKey: String
    public let azureSpeechRegion: String

    // MARK: Model & system settings

    public let deepSeekBaseURL: URL
    public let deepSeekModels: [DeepSeekModelType]
    public let ollamaBaseURL: URL
    public let lmStudioBaseURL: URL

    public let defaultTimeout: TimeInterval
    public let maxTokens: Int
    public let defaultTemperature: Double

    // MARK: Röstinställningar

    public let defaultVoice: String
    public let availableVoices: [String]

    // MARK: Initiering

    /// Initierar miljön med hjälp av miljövariabler.
    /// - Throws: `ConfigurationError.missingKey` vid avsaknad av obligatoriska nycklar.
    public init() throws {
        let env = ProcessInfo.processInfo.environment

        self.deepSeekAPIKey = try Self.requireKey(env, name: "DEEPSEEK_API_KEY")
        self.azureSpeechKey = try Self.requireKey(env, name: "AZURE_SPEECH_KEY")
        self.azureSpeechRegion = env["AZURE_SPEECH_REGION"] ?? "westeurope"

        self.deepSeekBaseURL = URL(string: "https://api.deepseek.com/v1")!
        self.deepSeekModels = []
        self.ollamaBaseURL = URL(string: "http://localhost:11434")!
        self.lmStudioBaseURL = URL(string: "http://localhost:1234/v1")!

        self.defaultTimeout = 30.0
        self.maxTokens = 4096
        self.defaultTemperature = 0.7

        self.defaultVoice = "sv-SE-MattiasNeural"
        self.availableVoices = [
            "sv-SE-MattiasNeural",
            "sv-SE-SofieNeural",
            "en-US-JennyNeural",
            "en-US-AriaNeural",
            "en-US-GuyNeural"
        ]
    }

    // MARK: Hjälpmetoder

    /// Hämtar och validerar en miljövariabel.
    private static func requireKey(_ env: [String: String], name: String) throws -> String {
        guard let value = env[name], !value.isEmpty else {
            throw ConfigurationError.missingKey(name)
        }
        return value
    }

    // MARK: Headers

    /// HTTP-headrar för Azure Speech API.
    public func azureHeaders() -> [String: String] {
        [
            "Ocp-Apim-Subscription-Key": azureSpeechKey,
            "Content-Type": "application/json"
        ]
    }

    /// HTTP-headrar för DeepSeek API.
    public func deepSeekHeaders() -> [String: String] {
        [
            "Authorization": "Bearer \(deepSeekAPIKey)",
            "Content-Type": "application/json"
        ]
    }

    // MARK: Endpoints

    /// Azure Speech-to-Text REST-endpoint.
    public var azureSTTEndpoint: String {
        "https://\(azureSpeechRegion).stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1"
    }

    /// Azure Text-to-Speech REST-endpoint.
    public var azureTTSEndpoint: String {
        "https://\(azureSpeechRegion).tts.speech.microsoft.com/cognitiveservices/v1"
    }

    /// Azure realtidsigenkänning via WebSocket.
    public var azureRealtimeEndpoint: String {
        "wss://\(azureSpeechRegion).stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1"
    }
}
