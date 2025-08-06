import SwiftUI


// MARK: - KrilleStyle Layout and Accessibility
// Layout system and accessibility standards for the KrilleCore2030 design system

extension KrilleStyle {
    
    // MARK: - Accessibility

    struct Accessibility {
        // Minimum touch targets (iOS HIG: 44pt minimum)
        static let minimumTouchTarget: CGFloat = 44

        // Font scaling support
        static let supportsAccessibilityText = true

        // Color contrast ratios (WCAG 2.1 AAA)
        static let minimumContrastRatio: Double = 7.0
        static let minimumLargeTextContrastRatio: Double = 4.5

        // Motion preferences
        static let respectsReduceMotion = true
    }

    // MARK: - Layout Constants

    struct Layout {
        // Grid system
        static let gridColumns: Int = 12
        static let gridGutter: CGFloat = Spacing.large

        // Breakpoints
        static let mobileBreakpoint: CGFloat = 480
        static let tabletBreakpoint: CGFloat = 768
        static let desktopBreakpoint: CGFloat = 1024
        static let largeDesktopBreakpoint: CGFloat = 1440

        // Safe areas
        static let minimumSafeArea: CGFloat = Spacing.large

        // Maximum content width
        static let maxContentWidth: CGFloat = 1200
    }
}
