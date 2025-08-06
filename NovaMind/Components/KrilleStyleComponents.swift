import SwiftUI


// MARK: - KrilleStyle Components
// UI component implementations and view modifiers for the KrilleCore2030 design system

extension KrilleStyle {
    
    // MARK: - Components

    struct Components {
        
        // MARK: Button Styles

        static func primaryButton() -> some ButtonStyle {
            KrillePrimaryButtonStyle()
        }

        static func secondaryButton() -> some ButtonStyle {
            KrilleSecondaryButtonStyle()
        }

        static func ghostButton() -> some ButtonStyle {
            KrilleGhostButtonStyle()
        }

        static func destructiveButton() -> some ButtonStyle {
            KrilleDestructiveButtonStyle()
        }

        // MARK: Card Styles

        static func card() -> some ViewModifier {
            KrilleCardModifier()
        }

        static func elevatedCard() -> some ViewModifier {
            KrilleElevatedCardModifier()
        }

        // MARK: Input Styles

        static func textField() -> some ViewModifier {
            KrilleTextFieldModifier()
        }

        // MARK: Navigation Styles

        static func navigationBar() -> some ViewModifier {
            KrilleNavigationBarModifier()
        }
    }
}

// MARK: - Button Style Implementations

struct KrillePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.KrilleStyle.Typography.body(weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, KrilleStyle.Spacing.large)
            .padding(.vertical, KrilleStyle.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.medium)
                    .fill(KrilleStyle.Colors.novaPrimary)
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            )
            .animation(.easeInOut(duration: KrilleStyle.Animations.quick), value: configuration.isPressed)
    }
}

struct KrilleSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.KrilleStyle.Typography.body(weight: .medium))
            .foregroundColor(KrilleStyle.Colors.novaPrimary)
            .padding(.horizontal, KrilleStyle.Spacing.large)
            .padding(.vertical, KrilleStyle.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.medium)
                    .stroke(KrilleStyle.Colors.novaPrimary, lineWidth: 1.5)
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            )
            .animation(.easeInOut(duration: KrilleStyle.Animations.quick), value: configuration.isPressed)
    }
}

struct KrilleGhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.KrilleStyle.Typography.body(weight: .medium))
            .foregroundColor(KrilleStyle.Colors.novaPrimary)
            .padding(.horizontal, KrilleStyle.Spacing.large)
            .padding(.vertical, KrilleStyle.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.medium)
                    .fill(configuration.isPressed ? KrilleStyle.Colors.hover : Color.clear)
            )
            .animation(.easeInOut(duration: KrilleStyle.Animations.quick), value: configuration.isPressed)
    }
}

struct KrilleDestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.KrilleStyle.Typography.body(weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, KrilleStyle.Spacing.large)
            .padding(.vertical, KrilleStyle.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: KrilleStyle.CornerRadius.medium)
                    .fill(KrilleStyle.Colors.error)
                    .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            )
            .animation(.easeInOut(duration: KrilleStyle.Animations.quick), value: configuration.isPressed)
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
                        color: KrilleStyle.Shadows.medium.color,
                        radius: KrilleStyle.Shadows.medium.radius,
                        x: KrilleStyle.Shadows.medium.xOffset,
                        y: KrilleStyle.Shadows.medium.yOffset
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
                        color: KrilleStyle.Shadows.large.color,
                        radius: KrilleStyle.Shadows.large.radius,
                        x: KrilleStyle.Shadows.large.xOffset,
                        y: KrilleStyle.Shadows.large.yOffset
                    )
            )
    }
}

struct KrilleTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.KrilleStyle.Typography.body())
            .padding(KrilleStyle.Spacing.medium)
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
                        color: KrilleStyle.Shadows.small.color,
                        radius: KrilleStyle.Shadows.small.radius,
                        x: KrilleStyle.Shadows.small.xOffset,
                        y: KrilleStyle.Shadows.small.yOffset
                    )
            )
    }
}
