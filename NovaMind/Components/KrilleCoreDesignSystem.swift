import AppKit
import SwiftUI


// MARK: - Design System Core Types

struct KrilleColorPalette {
    let primary = Color.blue
    let secondary = Color.gray
    let accent = Color.accentColor
    let background = Color(NSColor.windowBackgroundColor)
    let surface = Color(NSColor.controlBackgroundColor)
    let onSurface = Color.primary
    let onPrimary = Color.white
    let onSecondary = Color.white
}

struct KrilleTypography {
    let h1 = Font.largeTitle.weight(.bold)
    let h2 = Font.title.weight(.semibold)
    let body = Font.body
    let caption = Font.caption

    func font(for style: Font) -> Font {
        return style
    }
}

struct KrilleSpacing {
    let small: CGFloat = 8
    let medium: CGFloat = 16
    let large: CGFloat = 24
}

struct KrilleCore {
    static let colors = KrilleColorPalette()
    static let typography = KrilleTypography()
    static let spacing = KrilleSpacing()
}

struct KrillePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(KrilleCore.colors.primary)
            .foregroundColor(KrilleCore.colors.onPrimary)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
struct KrilleSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(KrilleCore.colors.secondary)
            .foregroundColor(KrilleCore.colors.onSecondary)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
