import SwiftUI


struct MessageRow: View {
    var message: Models.Message
    var isLast: Bool
    var onResend: () -> Void
    var onEdit: (Models.Message) -> Void
    var onDelete: () -> Void
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .cornerRadius(16)
                if isLast {
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            if message.role == .assistant {
                Spacer()
            }
        }
        .contextMenu {
            Button("Copy", action: copyToClipboard)
            Button("Edit", action: { onEdit(message) })
            Button("Delete", action: onDelete)
        }
    }
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(message.content, forType: .string)
    }
}
struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageRow(
                message: .init(
                    role: .user,
                    content: "Hello, this is a test message.",
                    timestamp: Date()
                ),
                isLast: true,
                onResend: {},
                onEdit: { _ in },
                onDelete: {}
            )
            MessageRow(
                message: .init(
                    role: .assistant,
                    content: "And this is a response.",
                    timestamp: Date()
                ),
                isLast: false,
                onResend: {},
                onEdit: { _ in },
                onDelete: {}
            )
        }
        .padding()
    }
}
