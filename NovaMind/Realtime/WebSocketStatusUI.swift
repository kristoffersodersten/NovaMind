import Combine
import Foundation
import SwiftUI


// MARK: - Status View Extensions

/// Add WebSocket status UI components
public extension View {
    /// Add WebSocket status indicator to a view
    func webSocketStatus(_ webSocketManager: WebSocketManager) -> some View {
        HStack {
            self
            WebSocketStatusIndicator(webSocketManager: webSocketManager)
        }
    }
}

// MARK: - WebSocket Status View

/// Simple status view for WebSocket connections
public struct WebSocketStatusIndicator: View {
    let webSocketManager: WebSocketManager

    public init(webSocketManager: WebSocketManager) {
        self.webSocketManager = webSocketManager
    }
    public var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(connectionColor)
                .accessibilityLabel(connectionLabel)
                .frame(width: CGFloat(8), height: CGFloat(8))
                .scaleEffect(webSocketManager.connectionState == .connected ? 1.2 : 1.0)
                .animation(
                    .easeInOut(duration: 0.5)
                        .repeatForever(),
                    value: webSocketManager.connectionState == .connected
                )

            Text("\(webSocketManager.messagesSent)/\(webSocketManager.messagesReceived)")
                .systemFont(Font.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(.ultraThinMaterial)
        .cornerRadius(CGFloat(6))
        .accessibilityElement(children: .combine)
        .accessibilityHint("WebSocket-status och meddelanderäkning")
    }

    private var connectionColor: Color {
        switch webSocketManager.connectionState {
        case .connected: return .green
        case .connecting, .reconnecting, .disconnecting: return .orange
        case .disconnected: return .gray
        case .error: return .red
        }
    }

    private var connectionLabel: LocalizedStringKey {
        switch webSocketManager.connectionState {
        case .connected: return "Ansluten"
        case .connecting: return "Ansluter"
        case .reconnecting: return "Återansluter"
        case .disconnecting: return "Kopplar från"
        case .disconnected: return "Frånkopplad"
        case .error: return "Fel"
        }
    }
}
