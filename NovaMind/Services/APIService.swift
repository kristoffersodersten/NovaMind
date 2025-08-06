import Combine
import Foundation


// MARK: - APIService Extension
// Note: APIServiceProtocol methods implemented below

extension APIService {
    public func sendChatMessage(
        content: String,
        model: String,
        context: Models.ChatContext
    ) async throws -> Models.ChatResponse {
        // Convert ChatContext.history (ChatMessage) to [Message] for internal method
        let messages = context.history.map { chatMessage in
            Models.Message(
                role: Models.Message.Role(rawValue: chatMessage.role.rawValue) ?? .user,
                content: chatMessage.content
            )
        }

        return try await withCheckedThrowingContinuation { continuation in
            sendMessage(content: content, model: model, context: messages)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { aiResponse in
                        let chatResponse = Models.ChatResponse(
                            content: aiResponse.content,
                            model: model
                        )
                        continuation.resume(returning: chatResponse)
                    }
                )
                .store(in: &self.cancellables)
        }
    }

    public func sendStreamingMessage(
        content: String,
        model: String,
        context: Models.ChatContext
    ) -> AsyncThrowingStream<String, Error> {
        // Placeholder implementation - would need proper streaming support
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    let response = try await sendChatMessage(content: content, model: model, context: context)
                    continuation.yield(response.content)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    public func getAvailableModels() async throws -> [String] {
        return [
            "deepseek-chat",
            "deepseek-coder",
            "deepseek-reasoner",
            "gpt-4",
            "gpt-3.5-turbo",
            "claude-3",
            "llama-2",
            "llama3",
            "ollama/llama3",
            "lm-studio"
        ]
    }
}

public protocol APIServiceProtocol {
    func sendChatMessage(
        content: String,
        model: String,
        context: Models.ChatContext
    ) async throws -> Models.ChatResponse
    func sendStreamingMessage(
        content: String,
        model: String,
        context: Models.ChatContext
    ) -> AsyncThrowingStream<String, Error>
    func getAvailableModels() async throws -> [String]
}

public class APIService: APIServiceProtocol {
    public var baseURL: URL?
    private let session: URLSession
    internal var cancellables = Set<AnyCancellable>()
    // Use ContiguousArray for performance
    private var responseArray = ContiguousArray<Models.ChatResponse>()

    public init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 120
        session = URLSession(configuration: config)
    }

    public func sendMessage(
        content: String,
        model: String,
        context: [Models.Message]
    ) -> AnyPublisher<Models.ChatResponse, Error> {
        guard let baseURL = baseURL else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request: URLRequest
        do {
            request = try makeRequest(baseURL: baseURL, model: model, context: context)
        } catch {
            print("Error creating request: \(error)")
            return Fail(error: APIError.encodingFailed).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                try self?.validateResponse(data: data, response: response) ?? data
            }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .tryMap { response in
                guard let content = response.choices.first?.message.content else {
                    throw APIError.emptyResponse
                }
                let chatResponse = Models.ChatResponse(content: content, model: model)
                self.responseArray.append(chatResponse)
                return chatResponse
            }
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.decodingError(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }

    private func makeRequest(baseURL: URL, model: String, context: [Models.Message]) throws -> URLRequest {
        let endpoint = baseURL.appendingPathComponent("/api/chat")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let messages = context.map { message in
            [
                "role": message.role.rawValue,
                "content": message.content
            ]
        }

        let requestBody: [String: Any] = [
            "model": model,
            "messages": messages,
            "stream": false
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        return request
    }

    private func validateResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let statusError = APIError.serverError(statusCode: httpResponse.statusCode)

            if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.apiError(message: errorResponse.error)
            }

            throw statusError
        }

        return data
    }
}

// MARK: - API Response Models (sammanslagna)
public struct APIResponse: Codable {
    public let id: String?
    public let object: String?
    public let created: Int?
    public let model: String?
    public let choices: [Choice]

    public init(
        id: String? = nil,
        object: String? = nil,
        created: Int? = nil,
        model: String? = nil,
        choices: [Choice] = []
    ) {
        self.id = id
        self.object = object
        self.created = created
        self.model = model
        self.choices = choices
    }
}

public struct Choice: Codable {
    public let message: MessageContent

    public init(message: MessageContent = MessageContent(content: "")) {
        self.message = message
    }
}

public struct MessageContent: Codable {
    public let content: String

    public init(content: String) {
        self.content = content
    }
}

public struct APIErrorResponse: Codable {
    public let error: String
}

// MARK: - API Error Handling
public enum APIError: Error, LocalizedError, Sendable {
    case invalidURL
    case encodingFailed
    case invalidResponse
    case serverError(statusCode: Int)
    case apiError(message: String)
    case decodingError(description: String)
    case emptyResponse
    case connectionFailed
    case missingAPIKey(String)
    case providerNotImplemented(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL. Please check your settings."
        case .encodingFailed:
            return "Failed to encode request data"
        case .invalidResponse:
            return "Received an invalid response from server"
        case .serverError(let statusCode):
            return "Server error: HTTP \(statusCode)"
        case .apiError(let message):
            return "API error: \(message)"
        case .decodingError(let description):
            return "Failed to decode response: \(description)"
        case .emptyResponse:
            return "Received an empty response from AI model"
        case .connectionFailed:
            return "Connection to server failed. Check your network."
        case .missingAPIKey(let message):
            return "Missing API Key: \(message)"
        case .providerNotImplemented(let message):
            return "Provider not implemented: \(message)"
        }
    }
}
