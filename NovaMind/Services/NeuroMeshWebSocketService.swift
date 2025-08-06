import Combine
import Foundation


class NeuroMeshWebSocketService: ObservableObject {
    @Published var isConnected: Bool = false
    private var webSocketTask: URLSessionWebSocketTask?
    private let url = URL(string: "ws://localhost:8080/ws")!
    func connect() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        receiveMessages()
    }
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
    func sendMessage(_ message: NeuroMeshMessage) {
        do {
            let data = try JSONEncoder().encode(message)
            webSocketTask?.send(.data(data)) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                }
            }
        } catch {
            print("Error encoding message: \(error)")
        }
    }
    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
                self?.isConnected = false
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
                self?.receiveMessages()
            }
        }
    }
}
