import Combine
import Foundation


// MARK: - API Client Protocol
protocol APIClientProtocol {
    var isConnected: Bool { get }
}

// MARK: - AI Provider Protocol
public protocol AIProviderProtocol {
    var providerName: String { get }
    var modelName: String { get }

    func getCompletion(for messages: [Models.Message], maxTokens: Int?) async throws -> String
}
