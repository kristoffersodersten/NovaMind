import Foundation
import SwiftUI

//
//  ChatThread.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


struct ChatThread: Identifiable, Codable, Hashable {
    let id = UUID()
    var title: String
    var messages: [ChatThreadMessage]
    var projectId: UUID?
    var isGeneral: Bool // true for loose threads, false for project-specific
    var createdAt: Date
    var lastModified: Date
    var tags: [String]
    var isImportant: Bool
    var summary: String?

    init(
        title: String = "New Chat",
        projectId: UUID? = nil,
        isGeneral: Bool = true,
        tags: [String] = []
    ) {
        self.title = title
        self.messages = []
        self.projectId = projectId
        self.isGeneral = isGeneral
        self.createdAt = Date()
        self.lastModified = Date()
        self.tags = tags
        self.isImportant = false
        self.summary = nil
    }

    mutating func addMessage(_ message: ChatThreadMessage) {
        messages.append(message)
        updateLastModified()
        updateTitleIfNeeded()
    }

    mutating func updateLastModified() {
        lastModified = Date()
    }

    private mutating func updateTitleIfNeeded() {
        // ...existing code...
    }
}
