import SwiftUI


// MARK: - KrilleStyle
// Centralized design system implementation for KrilleCore2030
// Provides comprehensive styling, spacing, colors, typography, and component standards

struct KrilleStyle {

    // MARK: - Design System Version
    static let version = "2030.1.0"
    static let coreVersion = "KrilleCore2030"

    // MARK: - Color System

    struct Colors {
        // Primary palette
        static let novaPrimary = Color("foregroundPrimary")
        static let novaSecondary = Color("foregroundSecondary")
        static let novaBackground = Color("backgroundPrimary")
        static let novaAccent = Color("accentColor")
        static let novaGlow = Color("glow")

        // Semantic colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.blue

        // Neutral colors
        static let novaBlack = Color("novaBlack")
        static let novaGray = Color("novaGray")
        static let separator = Color("separator")

        // Interactive states
        static let hover = novaGlow.opacity(0.1 as Double)
        static let pressed = novaGlow.opacity(0.2 as Double)
        static let disabled = novaGray.opacity(0.3 as Double)
        static let focus = novaGlow

        // Gradients
        static let primaryGradient = LinearGradient(
            colors: [novaGlow, novaAccent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let backgroundGradient = LinearGradient(
            colors: [novaBackground, novaBackground.opacity(0.8 as Double)],
            startPoint: .top,
            endPoint: .bottom
        )

        static let glowGradient = RadialGradient(
            colors: [novaGlow.opacity(0.8 as Double), novaGlow.opacity(0.1 as Double), Color.clear],
            center: .center,
            startRadius: 0,
            endRadius: 100
        )
    }

    // MARK: - Typography System

    struct Typography {
        // Font families
        static let primaryFont = "SF Pro Display"
        static let secondaryFont = "SF Pro Text"
        static let monoFont = "SF Mono"

        // Font sizes (scaled for accessibility)
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption1: CGFloat = 12
        static let caption2: CGFloat = 11

        // Font weights
        static let ultraLight: Font.Weight = .ultraLight
        static let thin: Font.Weight = .thin
        static let light: Font.Weight = .light
        static let regular: Font.Weight = .regular
        static let medium: Font.Weight = .medium
        static let semibold: Font.Weight = .semibold
        static let bold: Font.Weight = .bold
        static let heavy: Font.Weight = .heavy
        static let black: Font.Weight = .black

        // Predefined text styles
        static func largeTitle(weight: Font.Weight = .regular) -> Font {
            .custom(primaryFont, size: largeTitle).weight(weight)
        }

        static func title1(weight: Font.Weight = .regular) -> Font {
            .custom(primaryFont, size: title1).weight(weight)
        }

        static func title2(weight: Font.Weight = .regular) -> Font {
            .custom(primaryFont, size: title2).weight(weight)
        }

        static func title3(weight: Font.Weight = .regular) -> Font {
            .custom(primaryFont, size: title3).weight(weight)
        }

        static func headline(weight: Font.Weight = .semibold) -> Font {
            .custom(primaryFont, size: headline).weight(weight)
        }

        static func body(weight: Font.Weight = .regular) -> Font {
            .custom(secondaryFont, size: body).weight(weight)
        }

        static func callout(weight: Font.Weight = .regular) -> Font {
            .custom(secondaryFont, size: callout).weight(weight)
        }

        static func subheadline(weight: Font.Weight = .regular) -> Font {
            .custom(secondaryFont, size: subheadline).weight(weight)
        }

        static func footnote(weight: Font.Weight = .regular) -> Font {
            .custom(secondaryFont, size: footnote).weight(weight)
        }

        static func caption1(weight: Font.Weight = .regular) -> Font {
            .custom(secondaryFont, size: caption1).weight(weight)
        }

        static func caption2(weight: Font.Weight = .regular) -> Font {
            .custom(secondaryFont, size: caption2).weight(weight)
        }

        static func monospace(size: CGFloat = body, weight: Font.Weight = .regular) -> Font {
            .custom(monoFont, size: size).weight(weight)
        }
    }

    // MARK: - Spacing System

    struct Spacing {
        // Base unit (4pt)
        static let base: CGFloat = 4

        // Common spacing values
        static let xtraSmall: CGFloat = base * 1      // 4pt
        static let small: CGFloat = base * 2      // 8pt
        static let medium: CGFloat = base * 3      // 12pt
        static let large: CGFloat = base * 4      // 16pt
        static let xtraLarge: CGFloat = base * 5      // 20pt
        static let xxl: CGFloat = base * 6     // 24pt
        static let xxxl: CGFloat = base * 8    // 32pt

        // Layout spacing
        static let section: CGFloat = base * 10    // 40pt
        static let page: CGFloat = base * 12       // 48pt
        static let screen: CGFloat = base * 16     // 64pt

        // Component spacing
        static let componentPadding: CGFloat = lg
        static let buttonPadding: CGFloat = md
        static let cardPadding: CGFloat = lg
        static let listPadding: CGFloat = sm

        // Edge insets
        static let componentInsets = EdgeInsets(
            top: componentPadding,
            leading: componentPadding,
            bottom: componentPadding,
            trailing: componentPadding
        )

        static let buttonInsets = EdgeInsets(
            top: buttonPadding,
            leading: buttonPadding,
            bottom: buttonPadding,
            trailing: buttonPadding
        )
    }

    // MARK: - Corner Radius System

    struct CornerRadius {
        static let xtraSmall: CGFloat = 2
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let xtraLarge: CGFloat = 16
        static let xxlarge: CGFloat = 20
        static let round: CGFloat = 50  // For circular elements

        // Component-specific
        static let button: CGFloat = md
        static let card: CGFloat = lg
        static let sheet: CGFloat = xl
        static let input: CGFloat = small
    }

    // MARK: - Shadow System

    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let xOffset: CGFloat
        let yOffset: CGFloat
    }

    struct Shadows {
        static let xtraSmall = ShadowStyle(color: Colors.novaBlack.opacity(0.1 as Double), radius: 1, xOffset: 0, yOffset: 1)
        static let small = ShadowStyle(color: Colors.novaBlack.opacity(0.1 as Double), radius: 2, xOffset: 0, yOffset: 1)
        static let medium = ShadowStyle(color: Colors.novaBlack.opacity(0.1 as Double), radius: 4, xOffset: 0, yOffset: 2)
        static let large = ShadowStyle(color: Colors.novaBlack.opacity(0.1 as Double), radius: 8, xOffset: 0, yOffset: 4)
        static let xtraLarge = ShadowStyle(color: Colors.novaBlack.opacity(0.15 as Double), radius: 16, xOffset: 0, yOffset: 8)
        static let glow = ShadowStyle(color: Colors.novaGlow.opacity(0.3 as Double), radius: 8, xOffset: 0, yOffset: 0)
    }

    // MARK: - Animation System

    struct Animations {
        // Duration constants
        static let instant: Double = 0.0
        static let fast: Double = 0.15
        static let medium: Double = 0.25
        static let slow: Double = 0.4
        static let verySlow: Double = 0.6

        // Easing curves
        static let easeInOut = Animation.easeInOut(duration: medium)
        static let easeIn = Animation.easeIn(duration: medium)
        static let easeOut = Animation.easeOut(duration: medium)
        static let linear = Animation.linear(duration: medium)
        static let spring = Animation.spring(response: 0.4, dampingFraction: 0.8)
        static let bouncy = Animation.spring(response: 0.6, dampingFraction: 0.6)

        // Common animations
        static let buttonPress = spring
        static let hover = easeInOut
        static let focus = Animation.easeOut(duration: fast)
        static let modal = Animation.easeInOut(duration: slow)
        static let pageTransition = Animation.easeInOut(duration: medium)
    }
}

// MARK: - Button Style Implementations

struct KrillePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .systemFont(Font.KrilleStyle.Typography.body(.semibold))
            .foregroundColor(.white)
            .padding(KrilleStyle.Spacing.buttonInsets)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.button)
                    .fill(KrilleStyle.Colors.novaGlow)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(KrilleStyle.Animations.buttonPress, value: configuration.isPressed)
    }
}

struct KrilleSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .systemFont(Font.KrilleStyle.Typography.body(.medium))
            .foregroundColor(KrilleStyle.Colors.novaGlow)
            .padding(KrilleStyle.Spacing.buttonInsets)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.button)
                    .stroke(KrilleStyle.Colors.novaGlow, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.button)
                            .fill(KrilleStyle.Colors.novaGlow.opacity(configuration.isPressed ? 0.1 : 0.05))
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(KrilleStyle.Animations.buttonPress, value: configuration.isPressed)
    }
}

struct KrilleGhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .systemFont(Font.KrilleStyle.Typography.body(.medium))
            .foregroundColor(KrilleStyle.Colors.novaPrimary)
            .padding(KrilleStyle.Spacing.buttonInsets)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.button)
                    .fill(KrilleStyle.Colors.hover.opacity(configuration.isPressed ? 1.0 : 0.0))
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(KrilleStyle.Animations.buttonPress, value: configuration.isPressed)
    }
}

struct KrilleDestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .systemFont(Font.KrilleStyle.Typography.body(.semibold))
            .foregroundColor(.white)
            .padding(KrilleStyle.Spacing.buttonInsets)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.button)
                    .fill(KrilleStyle.Colors.error)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(KrilleStyle.Animations.buttonPress, value: configuration.isPressed)
    }
}

// MARK: - View Modifier Implementations

struct KrilleCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(KrilleStyle.Spacing.componentInsets)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.card)
                    .fill(KrilleStyle.Colors.novaBackground)
                    .shadow(
                        color: KrilleStyle.Shadows.md.color,
                        radius: KrilleStyle.Shadows.md.radius,
                        x: KrilleStyle.Shadows.md.x,
                        y: KrilleStyle.Shadows.md.y
                    )
            )
    }
}

struct KrilleElevatedCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(KrilleStyle.Spacing.componentInsets)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.card)
                    .fill(KrilleStyle.Colors.novaBackground)
                    .shadow(
                        color: KrilleStyle.Shadows.lg.color,
                        radius: KrilleStyle.Shadows.lg.radius,
                        x: KrilleStyle.Shadows.lg.x,
                        y: KrilleStyle.Shadows.lg.y
                    )
            )
    }
}

struct KrilleTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .systemFont(Font.KrilleStyle.Typography.body())
            .padding(KrilleStyle.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.input)
                    .stroke(KrilleStyle.Colors.separator, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.input)
                            .fill(KrilleStyle.Colors.novaBackground)
                    )
            )
    }
}

struct KrilleNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(KrilleStyle.Colors.novaBackground.opacity(0.9 as Double))
                    .shadow(
                        color: KrilleStyle.Shadows.sm.color,
                        radius: KrilleStyle.Shadows.sm.radius,
                        x: KrilleStyle.Shadows.sm.x,
                        y: KrilleStyle.Shadows.sm.y
                    )
            )
    }
}
