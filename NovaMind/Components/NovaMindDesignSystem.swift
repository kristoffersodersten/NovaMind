import AppKit
import SwiftUI


// MARK: - Design System Core Types

struct KrilleColorPalette {
    let primary = Color.blue
    let secondary = Color.gray
    let accent = Color.accentColor
    let background = Color(NSColor.systemBackground)
    let surface = Color(NSColor.secondarySystemBackground)
    let onSurface = Color.primary
    let onPrimary = Color.white
    let onSecondary = Color.white
}

struct KrilleTypography {
    enum Style {
        case headline1, headline2, body, caption
    }

    let headline1 = Font.largeTitle.weight(.bold)
    let headline2 = Font.title2.weight(.semibold)
    let body = Font.body
    let caption = Font.caption

    func font(for style: Style) -> Font {
        switch style {
        case .headline1: return headline1
        case .headline2: return headline2
        case .body: return body
        case .caption: return caption
        }
    }
}

struct KrilleSpacing {
    let small: CGFloat = 4
    let medium: CGFloat = 8
    let large: CGFloat = 16
    let extraLarge: CGFloat = 24
}

// MARK: - Missing Design Components

struct MemoryItem: Identifiable {
    let id = UUID()
    let content: String
}

struct TagChip: View {
    let tag: String
    let color: Color
    let isAI: Bool

    var body: some View {
        Text(tag)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
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
            Text(label)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .cornerRadius(8)
    }
}

struct NovaMindStatusBubble: View {
    let title: String
    let icon: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(title)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isActive ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        .foregroundColor(isActive ? .green : .red)
        .cornerRadius(8)
    }
}

struct GlowDivider: View {
    let glowing: Bool

    var body: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.3))
            .frame(height: 1)
            .shadow(color: glowing ? .blue.opacity(0.5) : .clear, radius: glowing ? 4 : 0)
    }
}

// MARK: - Missing Type Definitions

struct AIProviderConfig {
    var name: String = ""
    var apiKey: APIKey = APIKey("")
    var baseURL: String = ""
}

struct APIKey {
    let rawValue: String

    init(_ value: String) {
        self.rawValue = value
    }
}

struct OnboardingMainContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to NovaMind")
                .font(.largeTitle.weight(.bold))
            Text("Your AI-powered development assistant")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct ChatThread: Identifiable {
    let id = UUID()
    let topic: String
}

struct Project: Identifiable {
    let id = UUID()
    let name: String
}

struct ProjectDetailView: View {
    let project: Project

    var body: some View {
        Text("Project: \(project.name)")
    }
}

struct ChatThreadDetailView: View {
    let chatThread: ChatThread

    var body: some View {
        Text("Chat: \(chatThread.topic)")
    }
}

// MARK: - Enhanced IconButton

struct IconButton: View {
    let systemName: String
    let active: Bool
    let pulse: Bool
    let action: () -> Void

    init(systemName: String, active: Bool = false, pulse: Bool = false, action: @escaping () -> Void) {
        self.systemName = systemName
        self.active = active
        self.pulse = pulse
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(active ? .accentColor : .secondary)
                .scaleEffect(pulse ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: pulse)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - View Extensions

extension View {
    func microSpringButton() -> some View {
        self
            .buttonStyle(MicroSpringButtonStyle())
    }

    func parallaxEffect(strength: CGFloat = 0.08) -> some View {
        GeometryReader { geo in
            self.offset(y: -geo.frame(in: .global).minY * strength)
        }
    }
}

// MARK: - Button Styles

struct MicroSpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Missing Message Types

struct MessageRowChatMessage: Identifiable {
    enum Role {
        case user, assistant
    }

    let id = UUID()
    let role: Role
    let content: String
    let timestamp: Date
    let attachments: [MessageAttachment] = []
}

struct MessageAttachment: Identifiable {
    let id = UUID()
    let type: String
    let url: URL?
}

struct MessageRowAttachmentView: View {
    let attachment: MessageAttachment
    let onRemove: () -> Void

    var body: some View {
        Text("Attachment")
            .padding(4)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(4)
    }
}

struct MarkdownText: View {
    let content: String

    var body: some View {
        Text(content)
            .textSelection(.enabled)
    }
}
