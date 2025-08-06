import Foundation

/// Represents an interaction within the NeuroMesh system
struct NeuroMeshInteraction {
    let id: String
    let type: InteractionType
    let content: String
    let timestamp: Date
    var metadata: [String: Any] = [:]
    
    init(id: String, type: InteractionType, content: String, timestamp: Date) {
        self.id = id
        self.type = type
        self.content = content
        self.timestamp = timestamp
    }
}

/// Types of NeuroMesh interactions
enum InteractionType: String, CaseIterable, Codable {
    case collaboration
    case query
    case response
    case feedback
    case learning
    case discovery
    case sharing
    case validation
    case creation
    case reflection
    case emergence
    case resonance
}
