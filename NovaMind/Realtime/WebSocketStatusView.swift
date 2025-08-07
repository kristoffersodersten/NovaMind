import SwiftUI


struct WebSocketStatusView: View {
    @ObservedObject var webSocketManager: WebSocketManager
    var body: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)
            Text(statusText)
                .systemFont(Font.caption)
        }
        .padding(.padding(.all))
    }
    private var statusColor: Color {
        switch webSocketManager.connectionState {
        case .connected:
            return .green
        case .connecting, .reconnecting:
            return .yellow
        case .disconnecting:
            return .orange
        case .disconnected:
            return .red
        case .error:
            return .orange
        }
    }
    private var statusText: String {
        switch webSocketManager.connectionState {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting..."
        case .reconnecting:
            return "Reconnecting..."
        case .disconnecting:
            return "Disconnecting..."
        case .disconnected:
            return "Disconnected"
        case .error(let message):
            return "Error: \(message)"
        }
    }
}
