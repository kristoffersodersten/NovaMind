import SwiftUI

struct TypingIndicator: View {
    @State private var animatingDots = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.foregroundSecondary)
                    .frame(width: CGFloat(6), height: CGFloat(6))
                    .scaleEffect(animatingDots ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animatingDots
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.novaGray.opacity(0.3 as Double))
        .cornerRadius(CGFloat(12))
        .onAppear {
            animatingDots = true
        }
    }
}
