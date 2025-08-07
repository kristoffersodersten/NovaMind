import SwiftUI


struct ProjectActionFormatter {
    func format(action: ProjectAction) -> some View {
        switch action.type {
        case .create:
            return AnyView(formatCreate(for: action))
        case .rename:
            return AnyView(formatRename(for: action))
        case .delete:
            return AnyView(formatDelete(for: action))
        case .duplicate:
            return AnyView(formatDuplicate(for: action))
        case .archive:
            return AnyView(formatArchive(for: action))
        }
    }

    private func formatCreate(for action: ProjectAction) -> some View {
        VStack(alignment: .leading) {
            Text("Create Project").font(.headline)
            Text("Timestamp: \(action.timestamp.formatted())")
        }
    }

    private func formatRename(for action: ProjectAction) -> some View {
        VStack(alignment: .leading) {
            Text("Rename Project").font(.headline)
            Text("Timestamp: \(action.timestamp.formatted())")
        }
    }

    private func formatDelete(for action: ProjectAction) -> some View {
        VStack(alignment: .leading) {
            Text("Delete Project").font(.headline)
            Text("Timestamp: \(action.timestamp.formatted())")
        }
    }

    private func formatDuplicate(for action: ProjectAction) -> some View {
        VStack(alignment: .leading) {
            Text("Duplicate Project").font(.headline)
            Text("Timestamp: \(action.timestamp.formatted())")
        }
    }

    private func formatArchive(for action: ProjectAction) -> some View {
        VStack(alignment: .leading) {
            Text("Archive Project").font(.headline)
            Text("Timestamp: \(action.timestamp.formatted())")
        }
    }
}
