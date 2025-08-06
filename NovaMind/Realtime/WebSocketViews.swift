import AppKit
import OSLog
import SwiftUI


/// Visar aktuell status för en WebSocket-anslutning på ett icke-påträngande sätt
public struct WebSocketConnectionStatusView: View {
  public let state: ConnectionState
  private let logger = Logger(subsystem: "NovaMind", category: "WebSocketViews")

  public init(state: ConnectionState) {
    self.state = state
  }

  public var body: some View {
    HStack(spacing: 6) {
      statusIcon
        .accessibilityHidden(true)

      Text(statusText)
        .systemFont(Font.caption)
        .foregroundColor(.secondary)
        .accessibilityLabel("Anslutningsstatus: \(statusText)")
    }
    .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
    .background(
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(Color(NSColor.systemGray))
        .shadow(color: .black.opacity(0.05 as Double), radius: 2, x: 0, y: 1)
    )
    .opacity(0.9 as Double)
  }

  private var statusText: String {
    switch state {
    case .connected: return "Ansluten"
    case .connecting: return "Ansluter..."
    case .reconnecting: return "Återansluter..."
    case .disconnecting: return "Kopplar från..."
    case .disconnected: return "Frånkopplad"
    case .error(let reason): return "Fel: \(reason)"
    }
  }

  @ViewBuilder
  private var statusIcon: some View {
    switch state {
    case .connected:
      Image(systemName: "checkmark.circle")
        .foregroundColor(.green)
    case .connecting, .reconnecting:
      ProgressView()
        .scaleEffect(0.7)
    case .disconnecting:
      ProgressView()
        .scaleEffect(0.7)
    case .disconnected:
      Image(systemName: "bolt.slash")
        .foregroundColor(.orange)
    case .error:
      Image(systemName: "exclamationmark.triangle.fill")
        .foregroundColor(.red)
    }
  }
}
