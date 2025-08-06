import SwiftUI

struct ProjectSectionView: View {
    let projects: [Project]
    @Binding var expandedProjectId: UUID?
    let maxHeight: CGFloat
    @ObservedObject var chatThreadStore: ChatThreadStore

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(projects, id: \.id) { project in
                    ProjectRow(
                        project: project,
                        isExpanded: expandedProjectId == project.id,
                        chatThreadStore: chatThreadStore,
                        onToggle: {
                            withAnimation {
                                expandedProjectId = expandedProjectId == project.id ? nil : project.id
                            }
                        }
                    )
                }

                // Tom tillstånd
                if projects.isEmpty {
                    EmptyStateView(
                        title: "Inga projekt hittades",
                        systemImage: "folder.badge.questionmark"
                    )
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
        }
        .frame(height: maxHeight)
    }
}
