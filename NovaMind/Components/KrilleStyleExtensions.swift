import SwiftUI


// MARK: - KrilleStyle Extensions
// Convenience extensions for SwiftUI views and types

// MARK: - View Extensions

extension View {
    // Apply KrilleStyle components
    func krilleCard() -> some View {
        self.modifier(KrilleStyle.Components.card())
    }

    func krilleElevatedCard() -> some View {
        self.modifier(KrilleStyle.Components.elevatedCard())
    }

    func krilleTextField() -> some View {
        self.modifier(KrilleStyle.Components.textField())
    }

    func krilleNavigationBar() -> some View {
        self.modifier(KrilleStyle.Components.navigationBar())
    }

    // Apply shadows
    func krilleShadow(_ shadow: KrilleStyle.ShadowStyle) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.xOffset, y: shadow.yOffset)
    }
}

// MARK: - Color Extensions

extension Color {
    // KrilleStyle color convenience accessors
    static var krillePrimary: Color { KrilleStyle.Colors.novaPrimary }
    static var krilleSecondary: Color { KrilleStyle.Colors.novaSecondary }
    static var krilleBackground: Color { KrilleStyle.Colors.novaBackground }
    static var krilleAccent: Color { KrilleStyle.Colors.novaAccent }
    static var krilleGlow: Color { KrilleStyle.Colors.novaGlow }
    static var krilleSuccess: Color { KrilleStyle.Colors.success }
    static var krilleWarning: Color { KrilleStyle.Colors.warning }
    static var krilleError: Color { KrilleStyle.Colors.error }
    static var krilleInfo: Color { KrilleStyle.Colors.info }
}

// MARK: - Font Extensions

extension Font {
    // KrilleStyle font convenience accessors
    static func krilleTitle1(_ weight: Font.Weight = .regular) -> Font {
        KrilleStyle.Typography.title1(weight: weight)
    }

    static func krilleTitle2(_ weight: Font.Weight = .regular) -> Font {
        KrilleStyle.Typography.title2(weight: weight)
    }

    static func krilleTitle3(_ weight: Font.Weight = .regular) -> Font {
        KrilleStyle.Typography.title3(weight: weight)
    }

    static func krilleHeadline(_ weight: Font.Weight = .semibold) -> Font {
        KrilleStyle.Typography.headline(weight: weight)
    }

    static func krilleBody(_ weight: Font.Weight = .regular) -> Font {
        KrilleStyle.Typography.body(weight: weight)
    }

    static func krilleCaption(_ weight: Font.Weight = .regular) -> Font {
        KrilleStyle.Typography.caption1(weight: weight)
    }

    static func krilleMono(_ size: CGFloat = 17, _ weight: Font.Weight = .regular) -> Font {
        KrilleStyle.Typography.monospace(size: size, weight: weight)
    }
}
