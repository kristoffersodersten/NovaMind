import Foundation

//
//  Models.swift
//  NovaMindKit Services
//
//  Definierar kärnmodeller för NovaMindKit services: ChatContext, ChatResponse, Message.
//


public enum MessageRole: String, Codable, Hashable, Sendable {
    case user
    case assistant
    case system
}

public enum Models {
    public struct Message: Codable, Identifiable, Hashable, Sendable {
        public let id: UUID
        public let role: MessageRole
        public let content: String
        public let timestamp: Date
        public init(id: UUID = UUID(), role: Role, content: String, timestamp: Date = Date()) {
            self.id = id
            self.role = role
            self.content = content
            self.timestamp = timestamp
        }
    }
    public struct ChatContext: Codable, Hashable, Sendable {
        public var history: [Message]
        public var topic: String?
        public var participants: [String]?
        public init(history: [Message] = [], topic: String? = nil, participants: [String]? = nil) {
            self.history = history
            self.topic = topic
            self.participants = participants
        }
    }
    public struct ChatResponse: Codable, Hashable, Sendable {
        public let content: String
        public let model: String
        public let timestamp: Date
        public init(content: String, model: String, timestamp: Date = Date()) {
            self.content = content
            self.model = model
            self.timestamp = timestamp
        }
    }
}
