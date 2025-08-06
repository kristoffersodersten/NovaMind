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
extension View {
    /// Applies a micro spring button animation effect
    func microSpringButton() -> some View {
        self.scaleEffect(1.0)
            .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: UUID())
    }
    
    /// Applies a glow effect when active
    func glowEffect(active: Bool) -> some View {
        self.shadow(color: active ? .blue : .clear, radius: 4)
    }
    
    /// Applies the Krille hover effect
    func krilleHover() -> some View {
        self.onHover { _ in
            // Hover effect implementation
        }
    }
}

// Glowing effect modifier
struct GlowEffect: ViewModifier {
    let isActive: Bool
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(
                color: isActive ? color.opacity(0.6) : Color.clear,
                radius: isActive ? radius : 0,
                x: 0,
                y: 0
            )
            .animation(.easeInOut(duration: 0.25), value: isActive)
    }
}

extension View {
    func glowEffect(active: Bool = true, color: Color = .glow, radius: CGFloat = 4) -> some View {
        self.modifier(GlowEffect(isActive: active, color: color, radius: radius))
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

extension View {
    func pulseEffect(active: Bool = true) -> some View {
        self.modifier(PulseEffect(active: active))
    }
}

// Helper for sending notifications for user activity tracking
extension View {
    func trackUserActivity() -> some View {
        self
            .onTapGesture {
                NotificationCenter.default.post(name: NSNotification.Name("UserActivity"), object: nil)
            }
            .onHover { _ in
                NotificationCenter.default.post(name: NSNotification.Name("UserActivity"), object: nil)
            }
    }
    
    func krilleHover() -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.glow.opacity(0.3), lineWidth: 1)
                .opacity(0)
        )
    }
    
    func microSpringButton() -> some View {
        self.buttonStyle(MicroSpringButtonStyle())
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
