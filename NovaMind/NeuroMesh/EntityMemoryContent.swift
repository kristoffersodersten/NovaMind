import Foundation

/// Represents memory content for entities in the NeuroMesh system
struct EntityMemoryContent: Codable {
    let entityId: String
    let contentType: MemoryContentType
    let data: String
    let timestamp: Date
    let relevanceScore: Double
    let emotionalContext: [String: Double]
    let connections: [String] // Related entity IDs
    
    init(
        entityId: String,
        contentType: MemoryContentType,
        data: String,
        timestamp: Date = Date(),
        relevanceScore: Double = 1.0,
        emotionalContext: [String: Double] = [:],
        connections: [String] = []
    ) {
        self.entityId = entityId
        self.contentType = contentType
        self.data = data
        self.timestamp = timestamp
        self.relevanceScore = relevanceScore
        self.emotionalContext = emotionalContext
        self.connections = connections
    }
}

/// Types of memory content
enum MemoryContentType: String, CaseIterable, Codable {
    case experience
    case knowledge
    case emotion
    case behavior
    case pattern
    case insight
    case relationship
    case skill
    case preference
    case goal
}
