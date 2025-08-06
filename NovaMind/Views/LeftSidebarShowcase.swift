import SwiftUI

struct LeftSidebarShowcase: View {
    @State private var showSidebar = true

    var body: some View {
        HStack(spacing: 0) {
            // Optimized Left Sidebar
            if showSidebar {
                LeftSidebarView()
                    .frame(width: 300)
                    .transition(.move(edge: .leading))
            }

            // Main content area
            VStack {
                // Demo controls
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSidebar.toggle()
                        }
                    }, label: {
                        HStack {
                            Image(systemName: showSidebar ? "sidebar.left" : "sidebar.right")
                            Text(showSidebar ? "Dölj Sidebar" : "Visa Sidebar")
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    })

                    Spacer()

                    Text("LeftSidebar Features")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding()

                // Demo content
                VStack(spacing: 16) {
                    Text("Sidebar Features:")
                        .font(.headline)
                        .foregroundColor(.primary)

                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(
                            icon: "magnifyingglass",
                            title: "Intelligent Sökning",
                            description: "Fuzzy search genom projekt och trådar med realtidsfiltrering"
                        )

                        FeatureRow(
                            icon: "rectangle.3.group",
                            title: "Modulär Struktur",
                            description: "Återanvändbara komponenter för enkel underhåll"
                        )

                        FeatureRow(
                            icon: "bolt.fill",
                            title: "Prestanda",
                            description: "LazyVStack för optimal rendering av stora listor"
                        )

                        FeatureRow(
                            icon: "hand.draw",
                            title: "Interaktiv Separator",
                            description: "Dra för att ändra storlek mellan projekt och trådar"
                        )

                        FeatureRow(
                            icon: "sparkles",
                            title: "Animationer",
                            description: "Smidiga övergångar och feedback-effekter"
                        )

                        FeatureRow(
                            icon: "accessibility",
                            title: "Tillgänglighet",
                            description: "Komplett stöd för skärmläsare och tangentbordsnavigation"
                        )
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)

                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
    }
}

#Preview {
    LeftSidebarShowcase()
        .preferredColorScheme(.dark)
}
