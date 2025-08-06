import Combine
import Foundation
import SwiftUI
import os.log

// APIClient.swift
// API client with modular design


public enum APIClientError: Error {
    case invalidURL
    case noData
    case connectionFailed
    case invalidResponse
    case unauthorized
    case authenticationFailed
    case rateLimitExceeded
    case networkError(Error)
    case encodingError
    case decodingError
    case invalidProvider
}

protocol APIClientProtocol {
    var isConnected: Bool { get }
    var connectionStatus: [AIProviderType: Bool] { get }
    var lastMessageTimestamp: Date? { get }
    var availableModels: [AIProviderType: [String]] { get }
}

// MARK: - API Configuration
struct APIConfiguration {
    static let lmStudioEndpoint = URL(string: "http://localhost:1234/v1/chat/completions")!
    static let ollamaEndpoint = URL(string: "http://localhost:11434/api/chat")!
    static let deepSeekEndpoint = URL(string: "https://api.deepseek.com/chat/completions")!
    static let requestTimeout: TimeInterval = 30.0
    static let resourceTimeout: TimeInterval = 60.0
}

@MainActor
public class APIClient: ObservableObject, APIClientProtocol {
    public static let shared = APIClient(settings: SettingsStore())

    @Published public var isConnected = false
    @Published private(set) var connectionStatus: [AIProviderType: Bool] = [:]
    @Published public var lastMessageTimestamp: Date?
    @Published public var availableModels: [AIProviderType: [String]] = [:]

    private var lastResponseCache: [AIProviderType: String] = [:]
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let settings: SettingsStore
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "APIClient", category: "APIClient")

    public init(settings: SettingsStore) {
        self.settings = settings
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfiguration.requestTimeout
        config.timeoutIntervalForResource = APIConfiguration.resourceTimeout
        self.session = URLSession(configuration: config)

        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - Connection Management
    public func testConnection(to provider: AIProviderType) async -> Bool {
        do {
            _ = try await sendMessage("test", to: provider, model: .chat)
            await updateConnectionStatus(provider: provider, isConnected: true)
            availableModels[provider] = ["chat", "code", "reasoning", "vision"]
            return true
        } catch {
            logger.error("Connection test failed for \(provider.rawValue): \(error.localizedDescription)")
            await updateConnectionStatus(provider: provider, isConnected: false)
            availableModels[provider] = []
            return false
        }
    }

    public func getConnectionStatus(for provider: AIProviderType) -> Bool {
        return connectionStatus[provider] ?? false
    }

    private func updateConnectionStatus(provider: AIProviderType, isConnected: Bool) async {
        connectionStatus[provider] = isConnected
        self.isConnected = connectionStatus.values.contains(true)
    }

    // MARK: - Message Sending (Simplified)
    public func sendMessage(_ content: String,
                            to provider: AIProviderType,
                            model: DeepSeekModelType = .chat) async throws -> String {
        logger.info("Sending message to \(provider.rawValue) with model \(model.rawValue)")

        let result = try await performRequest(content: content, provider: provider, model: model)

        lastResponseCache[provider] = result
        lastMessageTimestamp = Date()

        return result
    }

    // MARK: - Request Routing
    private func performRequest(content: String,
                                provider: AIProviderType,
                                model: DeepSeekModelType) async throws -> String {
        switch provider {
        case .deepseek:
            return try await sendToDeepSeek(content: content, model: model)
        case .openai:
            return try await sendToOpenAI(content: content, model: model)
        case .anthropic:
            return try await sendToAnthropic(content: content, model: model)
        case .local:
            let messages = [Models.Message(role: .user, content: content)]
            return try await sendToLocal(messages: messages)
        }
    }

    // MARK: - Provider-Specific Methods
    private func sendToDeepSeek(content: String, model: DeepSeekModelType) async throws -> String {
        let apiKey = settings.apiKey
        guard !apiKey.isEmpty else {
            throw APIClientError.invalidProvider
        }

        let messages = [Models.Message(role: .user, content: content)]
        let deepSeekMessages = messages.map { message in
            let role = DeepSeekChatMessage.Role(rawValue: message.role.rawValue) ?? .user
            return DeepSeekChatMessage(role: role, content: message.content)
        }
        let request = ChatRequest(model: model.rawValue, messages: deepSeekMessages)

        let url = URL(string: "https://api.deepseek.com/v1/chat/completions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try encoder.encode(request)
        } catch {
            throw APIClientError.encodingError
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIClientError.invalidResponse
        }

        // Simplified response parsing
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let choices = jsonObject["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            return content
        }

        throw APIClientError.decodingError
    }

    private func sendToOllama(content: String, model: DeepSeekModelType) async throws -> String {
        let requestBody = [
            "model": model.rawValue,
            "prompt": content,
            "stream": false
        ] as [String: Any]

        var urlRequest = URLRequest(url: APIConfiguration.ollamaEndpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw APIClientError.encodingError
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIClientError.invalidResponse
        }

        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let responseText = jsonObject["response"] as? String {
            return responseText
        }

        throw APIClientError.decodingError
    }

    private func sendToLMStudio(content: String, model: DeepSeekModelType) async throws -> String {
        let messages = [Models.Message(role: .user, content: content)]
        let deepSeekMessages = messages.map { message in
            let role = DeepSeekChatMessage.Role(rawValue: message.role.rawValue) ?? .user
            return DeepSeekChatMessage(role: role, content: message.content)
        }
        let request = ChatRequest(model: model.rawValue, messages: deepSeekMessages)

        var urlRequest = URLRequest(url: APIConfiguration.lmStudioEndpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try encoder.encode(request)
        } catch {
            throw APIClientError.encodingError
        }

        let (data, _) = try await session.data(for: urlRequest)

        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let choices = jsonObject["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            return content
        }

        throw APIClientError.decodingError
    }

    // Placeholder implementations for other providers
    private func sendToOpenAI(content: String, model: DeepSeekModelType) async throws -> String {
        throw APIClientError.connectionFailed // Not implemented
    }

    private func sendToAzure(content: String, model: DeepSeekModelType) async throws -> String {
        throw APIClientError.connectionFailed // Not implemented
    }

    private func sendToGemini(content: String, model: DeepSeekModelType) async throws -> String {
        throw APIClientError.connectionFailed // Not implemented
    }

    private func sendToAnthropic(content: String, model: DeepSeekModelType) async throws -> String {
        throw APIClientError.connectionFailed // Not implemented
    }

    private func sendToLocal(messages: [Models.Message]) async throws -> String {
        // Placeholder implementation for local AI processing
        // This would connect to a local model endpoint
        return "Local response placeholder: \(messages.last?.content ?? "")"
    }
}
