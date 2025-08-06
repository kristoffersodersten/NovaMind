import Foundation

public struct Usage: Codable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
    public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
}

public enum Role: String, Codable {
    case system
    case user
    case assistant
    case tool
}

public struct ToolCall: Codable {
    public let id: String
    public let type: String
    public let function: FunctionCall
    public init(id: String, type: String, function: FunctionCall) {
        self.id = id
        self.type = type
        self.function = function
    }
}

public struct FunctionCall: Codable {
    public let name: String
    public let arguments: String
    public init(name: String, arguments: String) {
        self.name = name
        self.arguments = arguments
    }
}
