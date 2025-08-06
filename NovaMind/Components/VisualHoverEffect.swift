import SwiftUI


struct VisualHoverEffect: ViewModifier {
    var active: Bool
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.glow.opacity(active ? 0.3 : 0), lineWidth: 1.5)
                    .blur(radius: active ? 1 : 0)
            )
            .animation(.easeInOut(duration: 0.2), value: active)
    }
}
