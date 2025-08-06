import SwiftUI


struct ChatBubble: View {
    var message: Models.Message
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2 as Double))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .cornerRadius(CGFloat(16))
                Text(message.timestamp, style: .time)
                    .font(Font.caption2)
                    .foregroundColor(.secondary)
            }
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}
