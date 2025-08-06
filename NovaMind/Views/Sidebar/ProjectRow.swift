import SwiftUI

struct ProjectRow: View {
    let project: SidebarProject
    let isExpanded: Bool
    @ObservedObject var chatThreadStore: ChatThreadStore
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FolderView(project: project, isExpanded: isExpanded, onToggle: onToggle)

            if isExpanded {
                ProjectAgentView(
                    projectDescription: .constant(project.description),
                    isAgentActive: .constant(project.agentConfiguration?.isEnabled ?? false),
                    onReturnToProjects: onToggle
                )
                .padding(.horizontal, 8)
                .padding(.top, 8)

                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
                    .padding(.vertical, 4)

                LazyVStack(alignment: .leading, spacing: 4) {
                    let projectThreads = chatThreadStore.getThreadsForProject(project.id)
                    ForEach(projectThreads, id: \.id) { thread in
                        ThreadRow(thread: thread)
                    }
                }
            }
        }
    }
}
