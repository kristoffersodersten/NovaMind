import AppKit
import SwiftUI


extension Color {
    // MARK: - NovaMind Semantic Colors (from Assets.xcassets)
    static let glow = Color("glow")
    static let novaBlack = Color("novaBlack")
    static let novaGray = Color("novaGray")
    static let separator = Color("separator")
    static let softBackground = Color("softBackground")
    static let foregroundPrimary = Color("foregroundPrimary")
    static let foregroundSecondary = Color("foregroundSecondary")
    static let backgroundPrimary = Color("backgroundPrimary")
    static let backgroundSecondary = Color("backgroundSecondary")
    static let accentPassive = Color("accentPassive")
    static let highlightAction = Color("highlightAction")

    // MARK: - Computed Colors (for dynamic behavior)
    static var interactiveGlow: Color {
        glow.opacity(0.8)
    }

    static var panelBackground: Color {
        #if os(macOS)
        if NSAppearance.current?.name == .darkAqua {
            return Color(red: 0.12, green: 0.12, blue: 0.12)
        } else {
            return Color(red: 0.90, green: 0.90, blue: 0.92)
        }
        #else
        return Color(UIColor.controlBackgroundColor)
        #endif
    }

    static var adaptivePrimary: Color {
        #if os(macOS)
        return Color(NSColor { appearance in
            switch appearance.bestMatch(from: [.aqua, .darkAqua]) {
            case .darkAqua:
                return NSColor.white
            default:
                return NSColor.black
            }
        })
        #else
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        })
        #endif
    }

    // MARK: - KrilleCore2030 Compliance
    static func enforceMonochrome() -> Bool {
        return true
    }
    // MARK: - Theme Reactive Colors
    static func adaptive(light: Color, dark: Color) -> Color {
        #if os(macOS)
        return Color(NSColor { appearance in
            switch appearance.bestMatch(from: [.aqua, .darkAqua]) {
            case .darkAqua:
                return NSColor(dark)
            default:
                return NSColor(light)
            }
        })
        #else
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
        #endif
    }
}

// MARK: - UIColor Extensions
#if !os(macOS)
extension UIColor {
    var color: Color {
        return Color(self)
    }
}
#endif

// MARK: - Theme Environment Key
struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: ThemeManager = ThemeManager.shared
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Color Asset Validation
extension Color {
    /// Validates that all required colorsets exist in Assets.xcassets
    static func validateColorAssets() -> [String] {
        let requiredColors = [
            "glow", "novaBlack", "novaGray", "separator", "softBackground",
            "foregroundPrimary", "foregroundSecondary", "backgroundPrimary", "backgroundSecondary",
            "accentPassive", "highlightAction"
        ]

        var missingColors: [String] = []

        for colorName in requiredColors where Bundle.main.path(forResource: colorName, ofType: "colorset") == nil {
            missingColors.append(colorName)
        }

        return missingColors
    }
}
