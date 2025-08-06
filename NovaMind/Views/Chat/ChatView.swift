import SwiftUI

/// Main chat interface view using MVVM architecture
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            MessageListView(messages: viewModel.messages, isLoading: viewModel.isLoading)
            InputBarView(text: $viewModel.inputText, onSend: viewModel.sendMessage)
        }
        .navigationTitle("Chat")
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Preview
#Preview {
    ChatView()
        .frame(height: 600)
}
