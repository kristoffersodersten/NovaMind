import SwiftUI

// MARK: - Model Definitions
struct Project: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    var agentConfiguration: ProjectAgentConfiguration?
}

struct ProjectAgentConfiguration {
    let isEnabled: Bool
}

struct ChatThread: Identifiable {
    let id = UUID()
    let title: String
    let tags: [String]
    let isImportant: Bool
    let projectId: UUID?
}

class ProjectStore: ObservableObject {
    @Published var projects: [Project] = [
        Project(
            name: "Sample Project",
            description: "A sample project",
            agentConfiguration: ProjectAgentConfiguration(isEnabled: true)
        )
    ]
}

class ChatThreadStore: ObservableObject {
    @Published var threads: [ChatThread] = []
    
    func getGeneralThreads() -> [ChatThread] {
        return threads.filter { $0.projectId == nil }
    }
    
    func getThreadsForProject(_ projectId: UUID) -> [ChatThread] {
        return threads.filter { $0.projectId == projectId }
    }
}
