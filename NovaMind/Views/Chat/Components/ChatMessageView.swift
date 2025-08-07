import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage
    @State private var showActions = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                messageBubble
                timestamp
                
                if showActions && !message.isUser {
                    actionButtons
                }
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                showActions = hovering && !message.isUser
            }
        }
    }
    
    private var messageBubble: some View {
        Text(message.content)
            .systemFont(Font.custom("SF Pro", size: 15, relativeTo: .body))
            .foregroundColor(.foregroundPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(message.isUser ? Color.glow.opacity(0.2) : Color.novaGray.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        message.isUser ? Color.glow.opacity(0.3) : Color.separator,
                        lineWidth: 1
                    )
            )
    }
    
    private var timestamp: some View {
        Text(timeString(from: message.timestamp))
            .systemFont(Font.custom("SF Pro", size: 11, relativeTo: .caption2))
            .foregroundColor(.foregroundSecondary)
            .padding(.horizontal, 4)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 8) {
            Button(action: saveToMemory) {
                Image(systemName: "tray.full")
                    .systemFont(Font.system(size: 12))
                    .foregroundColor(.foregroundSecondary)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: copyMessage) {
                Image(systemName: "doc.on.doc")
                    .systemFont(Font.system(size: 12))
                    .foregroundColor(.foregroundSecondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .transition(.opacity.combined(with: .scale))
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func saveToMemory() {
        print("Saving message to memory canvas: \(message.content)")
    }
    
    private func copyMessage() {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(message.content, forType: .string)
        #endif
    }
}
