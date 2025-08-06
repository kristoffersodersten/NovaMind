import Foundation

// DeepSeekTypes.swift
// Data types and models for DeepSeek API integration


// MARK: - DeepSeek Models
public struct DeepSeekModel: Codable, Identifiable {
  public let id: String
  public let object: String
  public let ownedBy: String
  public let created: Int?

  public init(id: String, object: String, ownedBy: String, created: Int? = nil) {
    self.id = id
    self.object = object
    self.ownedBy = ownedBy
    self.created = created
  }
}

public struct DeepSeekModelsResponse: Codable {
  public let object: String
  public let data: [DeepSeekModel]

  /// A description
  enum CodingKeys: String, CodingKey {
    case object
    case data
  }
}
/// A description
public struct ChatCompletionRequest: Codable {
  public var model: String = "deepseekChat"
  public let messages: [DeepSeekChatMessage]
  public let temperature: Double?
  public let maxTokens: Int?
  public let stream: Bool?

  /// A description
  /// - Parameters:
  ///   - model:
  ///   - messages:
  ///   - temperature:
  ///   - maxTokens:
  ///   - stream:
  ///
  public init(
    model: String = "deepseekChat",
    messages: [DeepSeekChatMessage],
    temperature: Double? = nil,
    maxTokens: Int? = nil,
    stream: Bool? = nil
  ) {
    self.model = model
    self.messages = messages
    self.temperature = temperature
    self.maxTokens = maxTokens
    self.stream = stream
  }
}
/// A description
public struct DeepSeekChatMessage: Codable {
  public var id = UUID()
  public enum Role: String, Codable {
    case user, assistant, system
  }

  /// A description
  public let role: Role
  public let content: String

  public init(role: Role, content: String) {
    self.role = role
    self.content = content
  }
}

public struct ChatCompletionResponse: Codable {
  public let id: String
  public let object: String
  public let created: Int
  public let model: String
  public let choices: [ChatChoice]
  public let usage: DeepSeekUsage?
}

public struct ChatChoice: Codable {
  public let index: Int
  public let message: DeepSeekChatMessage
  public let finishReason: String?

  enum CodingKeys: String, CodingKey {
    case index, message
    case finishReason = "finish_reason"
  }
}

public struct DeepSeekUsage: Codable {
  public let promptTokens: Int
  public let completionTokens: Int
  public let totalTokens: Int

  enum CodingKeys: String, CodingKey {
    case promptTokens = "prompt_tokens"
    case completionTokens = "completion_tokens"
    case totalTokens = "total_tokens"
  }
}

// MARK: - Streaming Types
public struct StreamDelta: Codable, Identifiable {
  public var id = UUID()
  public let role: String?
  public let content: String?
}

public struct StreamChoice: Codable, Identifiable {
  public let id = UUID()
  public let index: Int
  public let delta: StreamDelta
  public let finishReason: String?

  enum CodingKeys: String, CodingKey {
    case index, delta
    case finishReason = "finish_reason"
  }
}

public struct StreamResponse: Codable {
  public let id: String
  public let object: String
  public let created: Int
  public let model: String
  public let choices: [StreamChoice]
}

// MARK: - Completion Types
public struct CompletionRequest: Codable {
  public let model: String
  public let prompt: String
  public let maxTokens: Int?
  public let temperature: Double?
  public let stream: Bool?

  enum CodingKeys: String, CodingKey {
    case model, prompt, temperature, stream
    case maxTokens = "max_tokens"
  }

  public init(
    model: String,
    prompt: String,
    maxTokens: Int? = nil,
    temperature: Double? = nil,
    stream: Bool? = nil
  ) {
    self.model = model
    self.prompt = prompt
    self.maxTokens = maxTokens
    self.temperature = temperature
    self.stream = stream
  }
}

public struct CompletionResponse: Codable {
  public let id: String
  public let object: String
  public let created: Int
  public let model: String
  public let choices: [CompletionChoice]
  public let usage: DeepSeekUsage?
}

public struct CompletionChoice: Codable {
  public let text: String
  public let index: Int
  public let finishReason: String?

  enum CodingKeys: String, CodingKey {
    case text, index
    case finishReason = "finish_reason"
  }
}

// MARK: - Error Types
public struct DeepSeekAPIError: Codable {
  public let error: DeepSeekErrorDetail

  public struct DeepSeekErrorDetail: Codable {
    public let message: String
    public let type: String
    public let code: String?
  }
}

public enum DeepSeekError: LocalizedError {
  case missingAPIKey
  case notConnected
  case invalidResponse
  case httpError(Int)
  case apiError(String)
  case networkError(String)

  public var errorDescription: String? {
    switch self {
    case .missingAPIKey:
      return "DeepSeek API key is missing"
    case .notConnected:
      return "Not connected to DeepSeek API"
    case .invalidResponse:
      return "Invalid response from DeepSeek API"
    case .httpError(let statusCode):
      return "HTTP error: \(statusCode)"
    case .apiError(let message):
      return "DeepSeek API error: \(message)"
    case .networkError(let message):
      return "Network error: \(message)"
    }
  }
}

public struct ChatRequest: Codable {
  public let model: String
  public let messages: [DeepSeekChatMessage]  // Use DeepSeekChatMessage instead
  public let temperature: Double?
  public let maxTokens: Int?
  public let stream: Bool?

  /// A description
  /// - Parameters:
  ///   - model:
  ///   - messages:
  ///   - temperature:
  ///   - maxTokens:
  ///   - stream:
  ///
  public init(
    model: String = "deepseek-chat",
    messages: [DeepSeekChatMessage],  // Use DeepSeekChatMessage instead
    temperature: Double? = nil,
    maxTokens: Int? = nil,
    stream: Bool? = nil
  ) {
    self.model = model
    self.messages = messages
    self.temperature = temperature
    self.maxTokens = maxTokens
    self.stream = stream
  }
}
