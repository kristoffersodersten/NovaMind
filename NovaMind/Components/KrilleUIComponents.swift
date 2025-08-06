import SwiftUI


// Missing component placeholders
struct TagChip: View {
    let tag: String
    let color: Color
    let isAI: Bool

    var body: some View {
        HStack(spacing: 4) {
            if isAI {
                Image(systemName: "brain")
                    .font(.system(size: 10))
                    .foregroundColor(color)
            }
            Text(tag)
                .font(.caption)
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct KrilleBadge: View {
    let label: String
    let color: Color
    let icon: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .cornerRadius(6)
    }
}

struct NovaMindStatusBubble: View {
    let title: String
    let icon: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(isActive ? .green : .secondary)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isActive ? .primary : .secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isActive ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct GlowDivider: View {
    let glowing: Bool

    var body: some View {
        Rectangle()
            .fill(glowing ? Color.accentColor : Color.separator)
            .frame(height: 1)
            .animation(.easeInOut(duration: 0.3), value: glowing)
    }
}

struct KrilleUIComponents: View {
    @State private var isHovering = false
    @State private var aiGlowActive = true

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("KrilleCore 2030 Design Demo")
                    .font(.title.bold())
                    .padding(.top, 20)

                HStack(spacing: 16) {
                    Text("krilleCard()")
                        .padding()
                        .krilleCard()

                    Text("krilleHover")
                        .padding()
                        .krilleCard()
                        .krilleHover(isHovering)
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
