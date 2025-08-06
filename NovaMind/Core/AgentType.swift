import Foundation

/// Unified AgentType for the NovaMind system
/// Consolidates all agent types used across the codebase
enum AgentType: String, Codable, CaseIterable {
    // Core agent types from NovaMindCICDConfig
    case sparrow
    case raven
    case owl
    case mentor
    
    // CoralEngine agent types
    case scoutbird
    case angrybird
    case coordinator
    
    /// Display name for the agent type
    var displayName: String {
        switch self {
        case .sparrow: return "Sparrow"
        case .raven: return "Raven"
        case .owl: return "Owl"
        case .mentor: return "Mentor"
        case .scoutbird: return "Scout Bird"
        case .angrybird: return "Angry Bird"
        case .coordinator: return "Coordinator"
        }
    }
    
    /// Description of the agent's role
    var description: String {
        switch self {
        case .sparrow: return "Fast response agent"
        case .raven: return "Deep analysis agent"
        case .owl: return "Wisdom and oversight agent"
        case .mentor: return "Guidance and support agent"
        case .scoutbird: return "Early signal detection"
        case .angrybird: return "Ethical enforcement"
        case .coordinator: return "Task coordination"
        }
    }
}
