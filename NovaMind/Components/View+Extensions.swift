import AppKit
import SwiftUI

//
//  View+Extensions.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


#if os(macOS)

extension View {
    func cursor(_ cursor: NSCursor) -> some View {
        self.onHover { inside in
            if inside {
                cursor.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}

extension NSCursor {
    static let resizeLeftRight = NSCursor.resizeLeftRight
}
#endif

// MARK: - View Modifiers for NovaMind UI Components

// Glowing effect modifier
struct GlowEffect: ViewModifier {
    let isActive: Bool
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(
                color: isActive ? color.opacity(0.6 as Double) : Color.clear,
                radius: isActive ? radius : 0,
                x: 0,
                y: 0
            )
            .animation(.easeInOut(duration: 0.25), value: isActive)
    }
}


// Pulse effect modifier
struct PulseEffect: ViewModifier {
    let active: Bool
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(active && isAnimating ? 1.1 : 1.0)
            .opacity(active && isAnimating ? 0.8 : 1.0)
            .animation(
                active ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .easeInOut(duration: 0.2),
                value: isAnimating
            )
            .onAppear {
                if active {
                    isAnimating = true
                }
            }
            .onChange(of: active) { newValue in
                if newValue {
                    isAnimating = true
                } else {
                    isAnimating = false
                }
            }
    }
}


// Helper for sending notifications for user activity tracking

// MARK: - Button Styles

struct MicroSpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
