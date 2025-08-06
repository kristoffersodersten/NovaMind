import Foundation
import SwiftUI

//
//  Project.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


struct Project: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var description: String
    var instructions: String?
    var path: URL?
    var isActive: Bool
    var color: ProjectColor
    var tags: [String]
    var createdAt: Date
    var lastModified: Date
    var chatThreads: [String] // Thread IDs
    var agentConfiguration: AgentConfig?

    init(
        name: String,
        description: String = "",
        instructions: String? = nil,
        path: URL? = nil,
        isActive: Bool = false,
        color: ProjectColor = .gray,
        tags: [String] = []
    ) {
        self.name = name
        self.description = description
        self.instructions = instructions
        self.path = path
        self.isActive = isActive
        self.color = color
        self.tags = tags
        self.createdAt = Date()
        self.lastModified = Date()
        self.chatThreads = []
        self.agentConfiguration = nil
    }

    mutating func updateLastModified() {
        lastModified = Date()
    }

    mutating func addChatThread(_ threadId: String) {
        if !chatThreads.contains(threadId) {
            chatThreads.append(threadId)
        }
    }
}
