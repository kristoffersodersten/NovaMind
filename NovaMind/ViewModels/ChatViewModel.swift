import Foundation

/// ViewModel for managing chat state and logic
@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    init() {
        loadSampleMessages()
    }
    
    /// Sends a new message to the chat
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = ChatMessage(
            content: inputText,
            isUser: true,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        inputText = ""
        
        // Simulate AI response
        simulateAIResponse()
    }
    
    /// Loads sample messages for development
    private func loadSampleMessages() {
        messages = [
            ChatMessage(
                content: "Hello! How can I help you today?",
                isUser: false,
                timestamp: Date().addingTimeInterval(-300)
            ),
            ChatMessage(
                content: "I'm working on a SwiftUI project and need help with layout design.",
                isUser: true,
                timestamp: Date().addingTimeInterval(-240)
            ),
            ChatMessage(
                content: "I'd be happy to help with your SwiftUI layout! What specific aspect are you working on?",
                isUser: false,
                timestamp: Date().addingTimeInterval(-180)
            )
        ]
    }
    
    /// Simulates an AI response with random delay
    private func simulateAIResponse() {
        isLoading = true
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            let responses = [
                "That's a great question! Let me help you with that.",
                "I understand what you're looking for. Here's my suggestion:",
                "Interesting! I can definitely assist you with this.",
                "Let me break this down for you step by step."
            ]
            
            let aiMessage = ChatMessage(
                content: responses.randomElement() ?? "I'm here to help!",
                isUser: false,
                timestamp: Date()
            )
            
            messages.append(aiMessage)
            isLoading = false
        }
    }
}
