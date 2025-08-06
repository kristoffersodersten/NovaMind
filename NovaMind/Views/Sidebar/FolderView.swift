import SwiftUI

struct FolderView: View {
    let project: Project
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: isExpanded ? "folder.fill" : "folder")
                    .foregroundColor(.glow)
                Text(project.name)
                    .font(.headline)
                    .foregroundColor(.foregroundPrimary)
                Spacer()
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundColor(.foregroundSecondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
