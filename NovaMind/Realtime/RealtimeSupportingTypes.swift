import Foundation
import SwiftUI

public enum ConnectionState: Equatable {
  case disconnected
  case connecting
  case connected
  case disconnecting
  case reconnecting
  case error(String)
  public var isConnected: Bool {
    if case .connected = self { return true }
    return false
  }
  public var displayTextKey: LocalizedStringKey {
    switch self {
    case .disconnected: return LocalizedStringKey("connection_disconnected")
    case .connecting: return LocalizedStringKey("connection_connecting")
    case .connected: return LocalizedStringKey("connection_connected")
    case .disconnecting: return LocalizedStringKey("connection_disconnecting")
    case .reconnecting: return LocalizedStringKey("connection_reconnecting")
    case .error: return LocalizedStringKey("connection_error")
    }
  }
  public var displayText: String {
    switch self {
    case .disconnected: return "Frånkopplad"
    case .connecting: return "Ansluter..."
    case .connected: return "Ansluten"
    case .disconnecting: return "Kopplar från..."
    case .reconnecting: return "Återansluter..."
    case .error(let message): return "Fel: \(message)"
    }
  }

  public var displayName: String {
    return displayText
  }
  public var systemImage: String {
    switch self {
    case .disconnected: return "wifi.slash"
    case .connecting: return "arrow.clockwise"
    case .connected: return "wifi"
    case .disconnecting: return "wifi.slash"
    case .reconnecting: return "arrow.triangle.2.circlepath"
    case .error: return "exclamationmark.triangle.fill"
    }
  }
  public var color: Color {
    switch self {
    case .disconnected: return .gray
    case .connecting: return .orange
    case .connected: return .green
    case .disconnecting: return .orange
    case .reconnecting: return .yellow
    case .error: return .red
    }
  }
}

// DeliveryStatus is now defined in Core/RealtimeTypes.swift for unified access
// MessagePriority is now defined in Core/RealtimeTypes.swift for unified access

#if DEBUG
  @MainActor
  public struct PreviewMock {
    @MainActor public static let allConnectionStates: [ConnectionState] = [
      .disconnected,
      .connecting,
      .connected,
      .disconnecting,
      .reconnecting,
      .error("Timeout")
    ]
    public static let allDeliveryStatuses = DeliveryStatus.allCases
    public static let allPriorities = MessagePriority.allCases
  }
#endif
