import SwiftUI

// MARK: - Supporting Types
enum ColorSet: CaseIterable {
    case primary
    case secondary
    case semantic
    case neutral

    var displayName: String {
        switch self {
        case .primary: return "Primary"
        case .secondary: return "Secondary"
        case .semantic: return "Semantic"
        case .neutral: return "Neutral"
        }
    }
}

enum PreviewMode: CaseIterable {
    case palette
    case gradient
    case components
    case accessibility

    var iconName: String {
        switch self {
        case .palette: return "paintpalette"
        case .gradient: return "gradient"
        case .components: return "square.stack.3d.up"
        case .accessibility: return "accessibility"
        }
    }
}

struct ColorInfo {
    let name: String
    let color: Color

    var hexValue: String {
        // Convert Color to hex string
        "#\(String(format: "%06X", Int.random(in: 0...0xFFFFFF)))" // Placeholder
    }

    var rgbValue: String {
        "rgb(128, 128, 128)" // Placeholder
    }

    var hsbValue: String {
        "hsb(180°, 50%, 50%)" // Placeholder
    }
}

struct GradientPreset {
    let name: String
    let gradient: LinearGradient
}

struct ContrastTest {
    let foreground: Color
    let background: Color
    let ratio: Double

    var isAccessible: Bool {
        ratio >= 4.5 // WCAG AA standard
    }
}

// MARK: - Button Styles (if not already defined)

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.glow)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.glow.opacity(0.2))
            .foregroundColor(.glow)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
