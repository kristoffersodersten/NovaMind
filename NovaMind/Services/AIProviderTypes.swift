import Foundation


// MARK: - DeepSeek API Types
struct DeepSeekRequest: Codable {
    let model: String
    let messages: [DeepSeekMessage]
    let stream: Bool?
    let temperature: Double?
    let maxTokens: Int?

    enum CodingKeys: String, CodingKey {
        case model, messages, stream, temperature
        case maxTokens = "max_tokens"
    }
}

struct DeepSeekMessage: Codable {
    let role: String
    let content: String
}

struct DeepSeekResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [DeepSeekChoice]
    let usage: DeepSeekUsage?
}

struct DeepSeekChoice: Codable {
    let index: Int
    let message: DeepSeekMessage
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct DeepSeekUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct DeepSeekStreamedResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [DeepSeekStreamChoice]
}

struct DeepSeekStreamChoice: Codable {
    let index: Int
    let delta: DeepSeekDelta
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index, delta
        case finishReason = "finish_reason"
    }
}

struct DeepSeekDelta: Codable {
    let role: String?
    let content: String?
}
