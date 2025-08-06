import SwiftUI

struct SeparatorView: View {
    @Binding var separatorY: CGFloat
    let maxHeight: CGFloat
    @State private var isDragging = false

    var body: some View {
        Rectangle()
            .fill(Color.separator)
            .frame(height: 2)
            .overlay(
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 2)
                    .opacity(isDragging ? 0.8 : 0.4)
                    .blur(radius: isDragging ? 2 : 0)
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        let newY = separatorY + value.translation.height
                        let minY: CGFloat = 100
                        let maxY = maxHeight - 120
                        separatorY = min(max(minY, newY), maxY)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
            .animation(.easeInOut(duration: 0.2), value: isDragging)
    }
}
