import SwiftUI

// MARK: - Sidebar Model Definitions
public struct SidebarProject: Identifiable {
    public let id = UUID()
    public let name: String
    public let description: String
    public var agentConfiguration: ProjectAgentConfiguration?
    
    public init(name: String, description: String, agentConfiguration: ProjectAgentConfiguration? = nil) {
        self.name = name
        self.description = description
        self.agentConfiguration = agentConfiguration
    }
}

public struct ProjectAgentConfiguration {
    public let isEnabled: Bool
    
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}

// Use the core ChatThread type
typealias SidebarChatThread = ChatThread

public class ProjectStore: ObservableObject {
    @Published public var projects: [SidebarProject] = [
        SidebarProject(
            name: "Sample Project",
            description: "A sample project",
            agentConfiguration: ProjectAgentConfiguration(isEnabled: true)
        )
    ]
    
    public init() {}
}

public class ChatThreadStore: ObservableObject {
    @Published var threads: [SidebarChatThread] = []
    
    public init() {}
    
    func getGeneralThreads() -> [SidebarChatThread] {
        return threads.filter { $0.projectId == nil }
    }
    
    func getThreadsForProject(_ projectId: UUID) -> [SidebarChatThread] {
        return threads.filter { $0.projectId == projectId }
    }
}
