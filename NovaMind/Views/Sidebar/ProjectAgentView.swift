import SwiftUI

struct ProjectAgentView: View {
    @Binding var projectDescription: String
    @Binding var isAgentActive: Bool
    let onReturnToProjects: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Project Agent")
                .font(.caption)
                .foregroundColor(.foregroundSecondary)
            
            Toggle("Active", isOn: $isAgentActive)
                .font(.caption)
        }
        .padding(8)
        .background(Color.separator.opacity(0.1))
        .cornerRadius(6)
    }
}
