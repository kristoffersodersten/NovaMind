import SwiftUI

//
//  ParallaxElevation.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


struct ParallaxElevation: ViewModifier {
    let depth: CGFloat
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color.black.opacity(isActive ? 0.12 : 0.06),
                radius: isActive ? depth * 3 : depth,
                x: 0,
                y: isActive ? depth * 0.5 : depth * 0.25
            )
            .scaleEffect(isActive ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.25), value: isActive)
    }
}

// Extension for easier usage
extension View {
    func parallaxElevation(depth: CGFloat, isActive: Bool = true) -> some View {
        self.modifier(ParallaxElevation(depth: depth, isActive: isActive))
    }
}
