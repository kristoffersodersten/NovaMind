import Combine
import Foundation
import Network
import SwiftUI


public protocol AzureRealtimeAPIProtocol {
  func connect() async throws
  func disconnect()
  func startRecording() async throws
  func stopRecording() async throws
  func speak(text: String, voice: String) async throws
  func stopSpeaking()
  func sendMessage(_ message: String) async throws
}

// Split AzureRealtimeAPI into smaller extensions to resolve type_body_length warning
public class AzureRealtimeAPI: NSObject, ObservableObject, AzureRealtimeAPIProtocol {
  @Published public var isConnected: Bool = false
  @Published public var currentResponse: String = ""
  @Published public var isRecording = false
  @Published public var isSpeaking = false
  @Published public var transcribedText = ""
  @Published public var connectionError: String?
  @Published public var conversationId: String?

  private let subscriptionKey: String
  private let region: String
  private var webSocketTask: URLSessionWebSocketTask?
  private var urlSession: URLSession?
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "azure-realtime-api")

  public init(subscriptionKey: String, region: String) {
    self.subscriptionKey = subscriptionKey
    self.region = region
    super.init()
    // setupNetworkMonitoring() // Commented out until implemented
  }

  deinit {
    disconnect()
    monitor.cancel()
  }

  // MARK: - Networking methods are implemented in extensions below
  // All protocol methods are implemented in the extensions below.
}

/// Extension for AzureRealtimeAPI containing networking and audio interaction methods.
/// This extension provides methods to manage the WebSocket connection, send and receive messages,
/// handle audio recording, and text-to-speech operations for Azure Speech services.
extension AzureRealtimeAPI {
  /// Establishes a WebSocket connection to the Azure Speech service.
  /// Throws an error if the API key is missing or the endpoint URL is invalid.
  public func connect() async throws {
    guard !subscriptionKey.isEmpty else {
      throw AzureRealtimeError.missingAPIKey
    }
    let endpoint =
      "wss://\(region).stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1"
    guard let url = URL(string: endpoint) else {
      throw AzureRealtimeError.invalidURL
    }
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = [
      "Ocp-Apim-Subscription-Key": subscriptionKey,
      "X-ConnectionId": UUID().uuidString
    ]
    urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    webSocketTask = urlSession?.webSocketTask(with: url)
    webSocketTask?.resume()
    receiveMessages()
  }

  /// Disconnects from the Azure Speech service and cleans up resources.
  public func disconnect() {
    webSocketTask?.cancel(with: .goingAway, reason: nil)
    webSocketTask = nil
    urlSession = nil
    Task { @MainActor in
      self.isConnected = false
    }
  }

  /// Sends a string message over the WebSocket connection.
  /// Throws an error if not connected.
  public func sendMessage(_ message: String) async throws {
    guard let webSocketTask = webSocketTask else {
      throw AzureRealtimeError.notConnected
    }
    let wsMessage = URLSessionWebSocketTask.Message.string(message)
    webSocketTask.send(wsMessage) { error in
      if let error = error {
        Task { @MainActor in
          self.connectionError = error.localizedDescription
        }
      }
    }
  }

  /// Receives messages from the WebSocket and updates the current response.
  private func receiveMessages() {
    webSocketTask?.receive { [weak self] result in
      switch result {
      case .failure(let error):
        Task { @MainActor in
          self?.connectionError = error.localizedDescription
        }
      case .success(let message):
        switch message {
        case .string(let text):
          Task { @MainActor in
            self?.currentResponse = text
          }
        case .data:
          // Handle binary data if needed
          break
        @unknown default:
          break
        }
        self?.receiveMessages()
      }
    }
  }

  /// Starts audio recording for speech recognition.
  public func startRecording() async throws {
    // Implement audio recording logic here
    Task { @MainActor in
      self.isRecording = true
    }
  }

  /// Stops audio recording.
  public func stopRecording() async throws {
    // Implement stop recording logic here
    Task { @MainActor in
      self.isRecording = false
    }
  }

  /// Initiates text-to-speech playback using the specified voice.
  public func speak(text: String, voice: String) async throws {
    // Implement TTS logic here
    Task { @MainActor in
      self.isSpeaking = true
    }
  }

  /// Stops text-to-speech playback.
  public func stopSpeaking() {
    // Implement stop speaking logic here
    Task { @MainActor in
      self.isSpeaking = false
    }
  }
}

extension AzureRealtimeAPI: URLSessionDelegate {
  // Implementation for URLSessionDelegate
  public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    Task { @MainActor in
      self.connectionError = error?.localizedDescription
      self.isConnected = false
    }
  }

  public func urlSession(
    _ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?
  ) {
    Task { @MainActor in
      if let error = error {
        self.connectionError = error.localizedDescription
      }
      self.isConnected = false
    }
  }

  // Handle authentication challenges if required by Azure
  public func urlSession(
    _ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    // For Azure endpoints, typically use default handling
    completionHandler(.performDefaultHandling, nil)
  }
}

// Move these to file scope
extension AzureRealtimeAPI: URLSessionWebSocketDelegate {
  public func urlSession(
    _ session: URLSession, webSocketTask: URLSessionWebSocketTask,
    didOpenWithProtocol protocol: String?
  ) {
    Task { @MainActor in
      self.isConnected = true
      self.connectionError = nil
    }
  }

  public func urlSession(
    _ session: URLSession, webSocketTask: URLSessionWebSocketTask,
    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?
  ) {
    Task { @MainActor in
      self.isConnected = false
    }
  }
}

public enum AzureRealtimeError: LocalizedError {
  case missingAPIKey
  case invalidURL
  case notConnected
  case networkError(String)

  public var errorDescription: String? {
    switch self {
    case .missingAPIKey:
      return "Azure Speech API key is missing"
    case .invalidURL:
      return "Invalid Azure endpoint URL"
    case .notConnected:
      return "Not connected to Azure Speech service"
    case .networkError(let message):
      return "Network error: \(message)"
    }
  }
}

extension Notification.Name {
  static let fallbackToLocalSTT = Notification.Name("fallbackToLocalSTT")
}
