import Combine
import Network
import OSLog


// MARK: - WebSocketManager Helper Functions
// NOTE: These extensions are currently disabled due to API incompatibility
// They need to be refactored to match the actual WebSocketManager implementation

/*
extension WebSocketManager {

  // MARK: - Connection Management Helpers

  /// Helper to establish connection with retry logic
  func establishConnection() async throws {
    var attemptCount = 0
    let maxAttempts = 3

    while attemptCount < maxAttempts {
      do {
        try await connect()
        return
      } catch {
        attemptCount += 1
        if attemptCount == maxAttempts {
          throw error
        }

        // Exponential backoff
        let delay = pow(2.0, Double(attemptCount))
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
      }
    }
  }

  /// Helper to gracefully disconnect
  func gracefulDisconnect() async {
    await withCheckedContinuation { continuation in
      DispatchQueue.main.async { [weak self] in
        self?.disconnect()
        continuation.resume()
      }
    }
  }

  // MARK: - Message Handling Helpers

  /// Helper to send message with retry
  func sendWithRetry<T: Codable>(_ message: T, type: RealtimeMessageType, maxRetries: Int = 3) async throws {
    var attempts = 0

    while attempts < maxRetries {
      do {
        try await send(message, type: type)
        return
      } catch {
        attempts += 1
        if attempts == maxRetries {
          throw error
        }

        // Check if we need to reconnect
        if !isConnected {
          try await establishConnection()
        }

        // Small delay before retry
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
      }
    }
  }

  /// Helper to handle incoming messages by type
  func handleIncomingMessage(_ data: Data) {
    do {
      if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
         let typeString = json["type"] as? String,
         let type = RealtimeMessageType(rawValue: typeString) {
        handleMessageType(type, data: data, json: json)
      }
    } catch {
      logger.error("Failed to handle incoming message: \(error)")
    }
  }

  private func handleMessageType(_ type: RealtimeMessageType, data: Data, json: [String: Any]) {
    switch type {
    case .chatMessage:
      do {
        let message = try JSONDecoder().decode(RealtimeMessage.self, from: data)
        DispatchQueue.main.async { [weak self] in
          self?.messageSubject.send(message)
        }
      } catch {
        logger.error("Failed to decode chat message: \(error)")
      }
    case .typingStart, .typingStop:
      do {
        let indicator = try JSONDecoder().decode(TypingIndicatorMessage.self, from: data)
        DispatchQueue.main.async { [weak self] in
          self?.typingUsersSubject.send(indicator.users)
        }
      } catch {
        logger.error("Failed to decode typing indicator: \(error)")
      }
    case .presence, .userJoined, .userLeft:
      do {
        let presence = try JSONDecoder().decode(PresenceMessage.self, from: data)
        DispatchQueue.main.async { [weak self] in
          self?.presenceSubject.send(presence.users)
        }
      } catch {
        logger.error("Failed to decode presence update: \(error)")
      }
    case .connectionAck:
      handleConnectionAck()
    case .error:
      handleServerErrorIfPossible(json)
    default:
      logger.debug("Unknown message type: \(type.rawValue)")
    }
  }

  private func handleServerErrorIfPossible(_ json: [String: Any]) {
    if let errorMsg = json["message"] as? String {
      handleServerError(errorMsg)
    }
  }

  private func handleConnectionAck() {
    DispatchQueue.main.async { [weak self] in
      self?.connectionStateSubject.send(.connected)
    }
  }

  private func handleServerError(_ message: String) {
    logger.error("Server error: \(message)")
    DispatchQueue.main.async { [weak self] in
      self?.errorSubject.send(RealtimeError.serverError(message))
    }
  }

  // MARK: - Connection Health Helpers

  /// Helper to check connection health
  func performHealthCheck() async -> Bool {
    guard isConnected else { return false }

    do {
      // Send a ping and wait for response
      try await webSocketTask?.ping()
      return true
    } catch {
      logger.warning("Health check failed: \(error)")
      return false
    }
  }

  /// Helper to start periodic health checks
  func startHealthChecks() {
    healthCheckTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
      Task { [weak self] in
        let isHealthy = await self?.performHealthCheck() ?? false
        if !isHealthy {
          await self?.handleConnectionFailure()
        }
      }
    }
  }

  /// Helper to stop health checks
  func stopHealthChecks() {
    healthCheckTimer?.invalidate()
    healthCheckTimer = nil
  }

  // MARK: - Reconnection Helpers

  private func handleConnectionFailure() async {
    logger.warning("Connection failure detected, attempting reconnection")

    DispatchQueue.main.async { [weak self] in
      self?.connectionStateSubject.send(.disconnected)
    }

    // Attempt to reconnect
    do {
      try await establishConnection()
    } catch {
      logger.error("Reconnection failed: \(error)")
      DispatchQueue.main.async { [weak self] in
        self?.errorSubject.send(RealtimeError.connectionFailed)
      }
    }
  }

  // MARK: - Message Queue Helpers

  /// Helper to flush pending messages
  func flushPendingMessages() async {
    guard isConnected else { return }

    while !pendingMessages.isEmpty {
      if let messageData = pendingMessages.removeFirst() {
        do {
          try await webSocketTask?.send(.data(messageData))
        } catch {
          logger.error("Failed to send queued message: \(error)")
          // Re-queue the message for later
          pendingMessages.insert(messageData, at: 0)
          break
        }
      }
    }
  }

  /// Helper to queue message when offline
  func queueMessage<T: Codable>(_ message: T) {
    do {
      let data = try JSONEncoder().encode(message)
      pendingMessages.append(data)

      // Limit queue size
      while pendingMessages.count > maxQueueSize {
        pendingMessages.removeFirst()
      }
    } catch {
      logger.error("Failed to queue message: \(error)")
    }
  }
}

// MARK: - Message Types for Helpers

struct TypingIndicatorMessage: Codable {
  let type: String = "typing_indicator"
  let users: [String]
}

struct PresenceMessage: Codable {
  let type: String = "presence_update"
  let users: [String]
}

// MARK: - Private Extensions

extension WebSocketManager {
  fileprivate var maxQueueSize: Int { 100 }

  fileprivate var logger: Logger {
    Logger(subsystem: "com.swiftwebui.realtime", category: "WebSocketManager")
  }
}
*/
