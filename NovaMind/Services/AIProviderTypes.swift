//
//  AIProviderTypes.swift
//  NovaMind
//
//  Created by Assistant on 2025-01-11.
//

import Foundation

// MARK: - Core AI Provider Types

public enum AIProvider: String, CaseIterable, Identifiable {
    case openai = "openai"
    case claude = "claude"
    case deepseek = "deepseek"
    case anthropic = "anthropic"
    case local = "local"
    
    public var id: String { self.rawValue }
    
    public var displayName: String {
        switch self {
        case .openai:
            return "OpenAI"
        case .claude:
            return "Claude"
        case .deepseek:
            return "DeepSeek"
        case .anthropic:
            return "Anthropic"
        case .local:
            return "Local"
        }
    }
}

// MARK: - Type Aliases
public typealias AIProviderType = AIProvider

public struct APIKey {
    public let value: String
    public let provider: AIProvider
    
    public init(value: String, provider: AIProvider) {
        self.value = value
        self.provider = provider
    }
}

public struct AIProviderConfig: Identifiable {
    public let id = UUID()
    public let provider: AIProvider
    public var name: String
    public var apiKey: String
    public var endpoint: String
    public let model: String?
    
    public init(provider: AIProvider, name: String, apiKey: String, endpoint: String, model: String? = nil) {
        self.provider = provider
        self.name = name
        self.apiKey = apiKey
        self.endpoint = endpoint
        self.model = model
    }
}

// MARK: - DeepSeek API Types

public struct DeepSeekMessage {
    public let role: String
    public let content: String
    
    public init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}

public struct DeepSeekRequest {
    public let model: String
    public let messages: [DeepSeekMessage]
    public let maxTokens: Int?
    public let temperature: Double?
    
    public init(model: String, messages: [DeepSeekMessage], maxTokens: Int? = nil, temperature: Double? = nil) {
        self.model = model
        self.messages = messages
        self.maxTokens = maxTokens
        self.temperature = temperature
    }
}

public struct DeepSeekChoice {
    public let index: Int
    public let message: DeepSeekMessage
    public let finishReason: String?
    
    public init(index: Int, message: DeepSeekMessage, finishReason: String? = nil) {
        self.index = index
        self.message = message
        self.finishReason = finishReason
    }
}

public struct DeepSeekUsage {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
    
    public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
}

public struct DeepSeekResponse {
    public let id: String
    public let object: String
    public let created: Int
    public let model: String
    public let choices: [DeepSeekChoice]
    public let usage: DeepSeekUsage?
    
    public init(id: String, object: String, created: Int, model: String, choices: [DeepSeekChoice], usage: DeepSeekUsage? = nil) {
        self.id = id
        self.object = object
        self.created = created
        self.model = model
        self.choices = choices
        self.usage = usage
    }
}

// MARK: - Codable Conformance

extension DeepSeekMessage: Codable {}
extension DeepSeekRequest: Codable {
    private enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens = "max_tokens"
        case temperature
    }
}
extension DeepSeekChoice: Codable {
    private enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}
extension DeepSeekUsage: Codable {
    private enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
extension DeepSeekResponse: Codable {}
