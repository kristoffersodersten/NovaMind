import Combine
import Foundation
import OSLog
import SwiftUI


// MARK: - Payload Types

public struct TypingStartPayload: Codable {
  public let userId: String
  public let userName: String
  public let chatId: String
  public let timestamp: Date
}

public struct TypingStopPayload: Codable {
  public let userId: String
  public let userName: String
  public let chatId: String
  public let timestamp: Date
}

// MARK: - Typing Indicator Manager Protocol

@MainActor
public protocol TypingIndicatorManagerProtocol {
  var typingUsers: Set<TypingUser> { get }
  var isCurrentUserTyping: Bool { get }
  func startTyping(in chatId: String)
  func stopTyping(in chatId: String?, immediate: Bool)
  func getTypingText(for chatId: String?) -> String
  func hasTypingUsers(in chatId: String?) -> Bool
}

// MARK: - Typing Indicator Manager

@MainActor
public final class TypingIndicatorManager: ObservableObject, TypingIndicatorManagerProtocol {

  private struct Constants {
    static let typingTimeout: TimeInterval = 3.0
    static let debounceInterval: TimeInterval = 0.5
    static let stopTypingDelay: TimeInterval = 1.0
    static let maxTypingUsers = 3
  }

  @Published public private(set) var typingUsers: Set<TypingUser> = []
  @Published public private(set) var isCurrentUserTyping = false

  private let webSocketManager: WebSocketManager
  private let logger = Logger(subsystem: "SwiftWebUI", category: "TypingIndicator")

  private var typingTimer: Timer?
  private var typingTimeouts: [String: Timer] = [:]
  private var typingDebounceWorkItem: DispatchWorkItem?

  private let currentUserId: String
  private let currentUserName: String

  internal init(
    webSocketManager: WebSocketManager,
    currentUserId: String = "current-user",
    currentUserName: String = "You"
  ) {
    self.webSocketManager = webSocketManager
    self.currentUserId = currentUserId
    self.currentUserName = currentUserName
    setupWebSocketHandlers()
  }

  deinit {
    typingTimer?.invalidate()
    typingDebounceWorkItem?.cancel()
    typingTimeouts.values.forEach { $0.invalidate() }
  }

  public func startTyping(in chatId: String) {
    typingDebounceWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      self?.sendTypingStart(chatId: chatId)
    }
    typingDebounceWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.debounceInterval, execute: workItem)
  }

  public func stopTyping(in chatId: String? = nil, immediate: Bool = false) {
    typingDebounceWorkItem?.cancel()
    typingDebounceWorkItem = nil

    if immediate {
      isCurrentUserTyping = false
      typingTimer?.invalidate()
      typingTimer = nil
      if let chatId = chatId { sendTypingStop(chatId: chatId) }
    } else {
      typingTimer?.invalidate()
      typingTimer = Timer.scheduledTimer(
        withTimeInterval: Constants.stopTypingDelay,
        repeats: false
      ) { [weak self] _ in
        Task { @MainActor in
          self?.isCurrentUserTyping = false
          if let chatId = chatId { self?.sendTypingStop(chatId: chatId) }
        }
      }
    }
  }

  public func getTypingText(for chatId: String? = nil) -> String {
    let users = chatId == nil ? typingUsers : getTypingUsers(for: chatId!)
    let activeUsers = Array(users.prefix(Constants.maxTypingUsers))

    switch activeUsers.count {
    case 0: return ""
    case 1: return "\(activeUsers[0].name) skriver..."
    case 2: return "\(activeUsers[0].name) och \(activeUsers[1].name) skriver..."
    default: return "\(activeUsers.count) personer skriver..."
    }
  }

  public func hasTypingUsers(in chatId: String? = nil) -> Bool {
    if let chatId = chatId {
      // Set har inte contains(where:), byt till filter
      return typingUsers.filter { $0.chatId == chatId }.count > 0
    }
    return !typingUsers.isEmpty
  }

  private func setupWebSocketHandlers() {
    // WebSocketManager interface temporary removed for compilation
    // TODO: Implement proper WebSocketManager integration
    logger.info("TypingIndicatorManager initialized - WebSocket handlers setup skipped")
  }

  private func sendTypingStart(chatId: String) {
    guard !isCurrentUserTyping else { return }
    isCurrentUserTyping = true
    let payload = TypingStartPayload(
      userId: currentUserId,
      userName: currentUserName,
      chatId: chatId,
      timestamp: Date()
    )
    Task {
      do {
        // try await webSocketManager.send(payload, type: .typingStart)
        logger.info("sendTypingStart temporarily disabled")
      } catch {
        logger.error("Failed to send typing start: \(error.localizedDescription)")
        isCurrentUserTyping = false
      }
    }
    typingTimer?.invalidate()
    typingTimer = Timer.scheduledTimer(withTimeInterval: Constants.typingTimeout, repeats: false) { [weak self] _ in
      Task { @MainActor in
        self?.stopTyping(in: chatId, immediate: true)
      }
    }
  }

  private func sendTypingStop(chatId: String) {
    guard isCurrentUserTyping else { return }
    let payload = TypingStopPayload(
      userId: currentUserId,
      userName: currentUserName,
      chatId: chatId,
      timestamp: Date()
    )
    Task {
      do {
        // try await webSocketManager.send(payload, type: .typingStop)
        logger.info("sendTypingStop temporarily disabled")
      } catch {
        logger.error("Failed to send typing stop: \(error.localizedDescription)")
      }
    }
  }

  private func handleTypingStart(_ payload: TypingStartPayload) {
    guard payload.userId != currentUserId else { return }
    let user = TypingUser(
      id: payload.userId,
      name: payload.userName,
      chatId: payload.chatId,
      startTime: payload.timestamp
    )
    typingUsers.insert(user)
    setTypingTimeout(for: payload.userId)
  }

  private func handleTypingStop(_ payload: TypingStopPayload) {
    // Set har inte removeAll(where:), byt till filter
    typingUsers = typingUsers.filter { $0.id != payload.userId }
    typingTimeouts[payload.userId]?.invalidate()
    typingTimeouts.removeValue(forKey: payload.userId)
  }

  private func setTypingTimeout(for userId: String) {
    typingTimeouts[userId]?.invalidate()
    typingTimeouts[userId] = Timer.scheduledTimer(
      withTimeInterval: Constants.typingTimeout,
      repeats: false
    ) { [weak self] _ in
      Task { @MainActor in
        self?.removeTypingUser(userId: userId)
      }
    }
  }

  private func removeTypingUser(userId: String) {
    // Set har inte removeAll(where:), byt till filter
    typingUsers = typingUsers.filter { $0.id != userId }
  }

  public func getTypingUsers(for chatId: String) -> Set<TypingUser> {
    Set(typingUsers.filter { $0.chatId == chatId })
  }
}

// MARK: - Supporting Types & Views

public struct TypingUser: Hashable, Identifiable {
  public let id: String
  public let name: String
  public let chatId: String
  public let startTime: Date
}

public struct TypingIndicatorModifier: ViewModifier {
  @ObservedObject private var typingManager: TypingIndicatorManager
  private let chatId: String?

  public init(typingManager: TypingIndicatorManager, chatId: String? = nil) {
    self.typingManager = typingManager
    self.chatId = chatId
  }

  public func body(content: Content) -> some View {
    VStack(spacing: 0) {
      content
      if typingManager.hasTypingUsers(in: chatId) {
        TypingIndicatorView(text: typingManager.getTypingText(for: chatId))
          .transition(.move(edge: .bottom).combined(with: .opacity))
      }
    }
    .animation(.easeInOut(duration: 0.2), value: typingManager.hasTypingUsers(in: chatId))
  }
}

public struct TypingIndicatorView: View {
  let text: String
  @State private var animatingDots = false

  public var body: some View {
    HStack(spacing: 8) {
      HStack(spacing: 2) {
        ForEach(0..<3) { index in
          Circle()
            .fill(Color.secondary)
            .frame(width: CGFloat(4), height: CGFloat(4))
            .scaleEffect(animatingDots ? 1.2 : 0.8)
            .animation(
              .easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.2),
              value: animatingDots
            )
        }
      }
      Text(text).systemFont(Font.caption).foregroundColor(.secondary)
    }
    .padding(.horizontal, 12).padding(.vertical, 6)
    .background(Color.secondary.opacity(0.1 as Double)).cornerRadius(CGFloat(12))
    .onAppear { animatingDots = true }
    .onDisappear { animatingDots = false }
  }
}
