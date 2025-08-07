import SwiftUI

// MARK: - Basic Button Styles (Non-Krille)
struct BasicDestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(configuration.isPressed ? Color.red.opacity(0.8) : Color.red)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct BasicPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct BasicSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(configuration.isPressed ? Color.blue.opacity(0.1) : Color.clear)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Button Style Extensions  
extension ButtonStyle where Self == BasicDestructiveButtonStyle {
    static var basicDestructive: BasicDestructiveButtonStyle {
        BasicDestructiveButtonStyle()
    }
}

extension ButtonStyle where Self == BasicPrimaryButtonStyle {
    static var basicPrimary: BasicPrimaryButtonStyle {
        BasicPrimaryButtonStyle()
    }
}

extension ButtonStyle where Self == BasicSecondaryButtonStyle {
    static var basicSecondary: BasicSecondaryButtonStyle {
        BasicSecondaryButtonStyle()
    }
}
