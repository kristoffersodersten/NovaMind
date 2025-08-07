import SwiftUI

/// Header view for the memory canvas with search and add functionality
struct MemoryCanvasHeaderView: View {
    @Binding var searchText: String
    let onAddTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Title and add button
            HStack {
                Text("Memory Canvas")
                    .systemFont(Font.custom("SF Pro", size: 18).weight(.semibold))
                    .foregroundColor(.foregroundPrimary)

                Spacer()

                Button(action: onAddTapped, label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.glow)
                        .systemFont(Font.title2)
                        .glowEffect(active: true)
                })
                .microSpringButton()
            }

            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.foregroundSecondary)
                    .systemFont(Font.system(size: 14))

                TextField("Search memories...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .systemFont(Font.custom("SF Pro", size: 14))
                    .foregroundColor(.foregroundPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.separator.opacity(0.3))
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}
