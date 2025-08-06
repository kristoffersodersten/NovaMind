import AppKit
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
                        .systemFont(Font.headline)
                        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
                        .background(Color.blue.opacity(0.2 as Double))
                        .foregroundColor(.blue)
                        .cornerRadius(CGFloat(8))
                    })

                    Spacer()

                    Text("LeftSidebar Features")
                        .systemFont(Font.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))

                // Demo content
                VStack(spacing: 16) {
                    Text("Sidebar Features:")
                        .systemFont(Font.headline)
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
                    .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
                    .background(Color.black.opacity(0.3 as Double))
                    .cornerRadius(CGFloat(12))

                    Spacer()
                }
                .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
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
                .systemFont(Font.title2)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .systemFont(Font.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(description)
                    .systemFont(Font.caption)
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
