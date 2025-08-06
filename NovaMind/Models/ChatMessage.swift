import Foundation

/// Represents a single chat message in the conversation
struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date

    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

// MARK: - Sample Data Extension
extension ChatMessage {
    /// Sample messages for development and testing
    static let sampleMessages: [ChatMessage] = [
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
