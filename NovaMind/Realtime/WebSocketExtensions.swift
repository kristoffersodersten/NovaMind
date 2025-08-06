import Foundation
import Network


enum WebSocketError: Error, LocalizedError, CustomDebugStringConvertible {
    case notConnected
    case connectionFailed(Error)
    case messageSendFailed(Error)
    case messageReceiveFailed(Error)
    case pingFailed(Error)
    case unexpectedMessage
    case invalidState

    public var errorDescription: String? {
        switch self {
        case .notConnected:
            return "Not connected to the WebSocket server."
        case .connectionFailed(let error):
            return "WebSocket connection failed: \(error.localizedDescription)"
        case .messageSendFailed(let error):
            return "Failed to send WebSocket message: \(error.localizedDescription)"
        case .messageReceiveFailed(let error):
            return "Failed to receive WebSocket message: \(error.localizedDescription)"
        case .pingFailed(let error):
            return "WebSocket ping failed: \(error.localizedDescription)"
        case .unexpectedMessage:
            return "Received an unexpected message type."
        case .invalidState:
            return "The WebSocket is in an invalid state for this operation."
        }
    }

    public var debugDescription: String {
        return "[WebSocketError] \(self.localizedDescription)"
    }
}

extension URLSessionWebSocketTask {
    func ping() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.sendPing { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
