import Foundation


public enum ProjectActionType {
    case create
    case rename
    case delete
    case duplicate
    case archive
}

public struct ProjectAction {
    // Alias för att matcha användning i ProjectActionFormatters
    public typealias ActionType = ProjectActionType

    public let type: ProjectActionType
    public let timestamp: Date
    public let metadata: [String: Any]

    public init(type: ProjectActionType, timestamp: Date = Date(), metadata: [String: Any] = [:]) {
        self.type = type
        self.timestamp = timestamp
        self.metadata = metadata
    }
}
