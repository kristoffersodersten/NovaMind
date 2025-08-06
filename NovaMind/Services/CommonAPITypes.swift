import Foundation


struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
}
enum Role: String, Codable {
    case system
    case user
    case assistant
    case tool
}
struct ToolCall: Codable {
    let id: String
    let type: String
    let function: FunctionCall
}
struct FunctionCall: Codable {
    let name: String
    let arguments: String
}
