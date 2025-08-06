import SwiftUI

/// View for displaying a scrollable list of chat messages
struct MessageListView: View {
    let messages: [ChatMessage]
    let isLoading: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        ChatMessageView(message: message)
                            .id(message.id)
                    }
                    
                    if isLoading {
                        HStack {
                            TypingIndicator()
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color.backgroundPrimary)
            .onChange(of: messages.count) { _ in
                scrollToBottom(proxy)
            }
        }
    }
    
    /// Scrolls to the bottom of the message list
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let lastMessage = messages.last else { return }
        
        withAnimation(.easeInOut) {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

// MARK: - Color Extensions
private extension Color {
    static let backgroundPrimary = Color(NSColor.controlBackgroundColor)
}

// MARK: - Preview
#Preview {
    MessageListView(
        messages: ChatMessage.sampleMessages,
        isLoading: false
    )
    .frame(height: 400)
}
