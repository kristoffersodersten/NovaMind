import SwiftUI


struct AISaveGlowModifier: ViewModifier {
    @Binding var active: Bool
    var color: Color
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(active ? color.opacity(0.8) : Color.clear, lineWidth: 4)
                    .blur(radius: active ? 8 : 0)
            )
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: active)
    }
}

extension View {
    func aiSaveGlow(active: Binding<Bool>, color: Color) -> some View {
        self.modifier(AISaveGlowModifier(active: active, color: color))
    }
}
