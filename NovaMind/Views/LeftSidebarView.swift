import SwiftUI

struct LeftSidebarView: View {
    // MARK: - State
    @State private var searchText: String = ""
    @StateObject private var projectStore = ProjectStore()
    @StateObject private var chatThreadStore: ChatThreadStore
    @State private var expandedProjectId: UUID?
    @State private var separatorY: CGFloat = 200

    // MARK: - Init
    init() {
        let projects = ProjectStore()
        _projectStore = StateObject(wrappedValue: projects)
        _chatThreadStore = StateObject(wrappedValue: ChatThreadStore(projects: projects.projects))
    }

    // MARK: - Computed Properties
    private var filteredProjects: [Project] {
        if searchText.isEmpty { return projectStore.projects }
        return projectStore.projects.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var filteredGeneralThreads: [ChatThread] {
        let generalThreads = chatThreadStore.getGeneralThreads()
        if searchText.isEmpty { return generalThreads }
        return generalThreads.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Sökfält
            SearchBar(text: $searchText)

            GeometryReader { geo in
                VStack(spacing: 0) {
                    // Projektsektion
                    ProjectSectionView(
                        projects: filteredProjects,
                        expandedProjectId: $expandedProjectId,
                        maxHeight: separatorY,
                        chatThreadStore: chatThreadStore
                    )

                    // Flyttbar separator
                    SeparatorView(separatorY: $separatorY, maxHeight: geo.size.height)

                    // Allmänna trådar
                    GeneralThreadsView(threads: filteredGeneralThreads)
                }
            }
        }
        .background(Color.gray)
        .animation(.easeInOut(duration: 0.2), value: separatorY)
    }
}

// MARK: - Previews
#Preview {
    LeftSidebarView()
        .frame(width: CGFloat(300), height: CGFloat(600))
        .preferredColorScheme(.dark)
}
