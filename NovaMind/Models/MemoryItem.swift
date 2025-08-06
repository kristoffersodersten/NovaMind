import Foundation
import SwiftUI

// MARK: - Memory Type
enum MemoryType: String, CaseIterable, Codable {
    case shortTerm = "short_term"
    case midTerm = "mid_term"
    case longTerm = "long_term"
    
    var displayName: String {
        switch self {
        case .shortTerm:
            return "Short Term"
        case .midTerm:
            return "Mid Term"
        case .longTerm:
            return "Long Term"
        }
    }
    
    var color: Color {
        switch self {
        case .shortTerm:
            return .orange
        case .midTerm:
            return .blue
        case .longTerm:
            return .green
        }
    }
}

// MARK: - Memory Item
struct MemoryItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var content: String
    var memoryType: MemoryType
    let createdAt: Date
    var updatedAt: Date
    var tags: [String]
    var importance: Int // 1-5 scale
    
    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        memoryType: MemoryType,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tags: [String] = [],
        importance: Int = 3
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.memoryType = memoryType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.importance = importance
    }
}

// MARK: - Extensions
extension MemoryItem {
    // For converting from NeuromeshMemory
    init(from neuromeshMemory: Any) {
        // Placeholder implementation
        self.init(
            title: "Imported Memory",
            content: "Content from Neuromesh",
            memoryType: .midTerm
        )
    }
}
