import SwiftUI


// Component definitions moved to NovaMindDesignSystem.swift to avoid duplicates

struct KrilleUIComponents: View {
    @State private var isHovering = false
    @State private var aiGlowActive = true

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("KrilleCore 2030 Design Demo")
                    .font(Font.title.bold())
                    .padding(.top, 20)

                HStack(spacing: 16) {
                    Text("krilleCard()")
                        .padding()
                        .krilleCard()

                    Text("krilleHover")
                        .padding()
                        .krilleCard()
                        .krilleHover()
                        .onHover { isHovering = $0 }
                }

                HStack(spacing: 12) {
                    TagChip(tag: "AI", color: Color.blue, isAI: true)
                    TagChip(tag: "Manual", color: Color.purple, isAI: false)
                }

//                FloatingPreviewChip(icon: "doc.text", label: "README.md") {}

                HStack(spacing: 12) {
                    KrilleBadge(label: "Beta", color: Color.orange, icon: "flame")
                    NovaMindStatusBubble(title: "Connected", icon: "network", isActive: true)
                    NovaMindStatusBubble(title: "Offline", icon: "wifi.slash", isActive: false)
                }

                Button("MicroSpring") {}
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: false)

                GlowDivider(glowing: isHovering)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 60)
                    .overlay(
                        Text("AI Save Glow")
                            .padding()
                            .aiSaveGlow(active: $aiGlowActive, color: .blue)
                    )
            }
            .padding()
        }
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 500)
    }
}

#Preview {
    KrilleUIComponents()
}
