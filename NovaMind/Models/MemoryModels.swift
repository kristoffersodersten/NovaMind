import SwiftUI

// MARK: - Memory Models
struct MemoryItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    var memoryType: MemoryType
    var importance: Int = 1
    var isImportant: Bool { importance > 3 }
    var tags: [String] = []
    var createdAt = Date()
    var updatedAt = Date()
}

enum MemoryType: String, CaseIterable, Codable {
    case shortTerm = "short"
    case midTerm = "mid"
    case longTerm = "long"
    
    var displayName: String {
        switch self {
        case .shortTerm: return "Short Term"
        case .midTerm: return "Mid Term"
        case .longTerm: return "Long Term"
        }
    }
    
    var color: Color {
        switch self {
        case .shortTerm: return .green
        case .midTerm: return .orange
        case .longTerm: return .blue
        }
    }
    
    var iconName: String {
        switch self {
        case .shortTerm: return "clock"
        case .midTerm: return "calendar"
        case .longTerm: return "brain.head.profile"
        }
    }
}
