import SwiftUI

struct MemoryMinimapView: View {
    let items: [MemoryItem]
    @Binding var selectedItem: MemoryItem?

    @State private var hoveredDot: MemoryItem?

    // KrilleCore2030 measurements
    private let dotSize: CGFloat = 4
    private let selectedDotSize: CGFloat = 6

    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                Text("Minimap")
                    .systemFont(Font.system(.caption2))
                    .fontWeight(.medium)
                    .foregroundColor(.foregroundSecondary)

                Spacer()

                Text("\(items.count) minnen")
                    .systemFont(Font.system(.caption2))
                    .foregroundColor(.foregroundSecondary)
            }

            // Minimap Canvas
            GeometryReader { geometry in
                Canvas { context, size in
                    drawMinimap(context: context, size: size, geometry: geometry)
                }
                .overlay(
                    // Invisible overlay for interaction
                    minimapInteractionOverlay(geometry: geometry)
                )
            }
            .frame(maxHeight: 80)
            .background(Color.novaGray.opacity(0.3 as Double))
            .cornerRadius(CGFloat(6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.separator, lineWidth: 0.5)
            )
        }
    }

    // MARK: - Canvas Drawing
    private func drawMinimap(context: GraphicsContext, size: CGSize, geometry: GeometryProxy) {
        let itemsPerRow = 8
        let spacing: CGFloat = 6
        let availableWidth = size.width - (spacing * 2)
        let itemWidth = availableWidth / CGFloat(itemsPerRow)

        for (index, item) in items.enumerated() {
            let row = index / itemsPerRow
            let col = index % itemsPerRow

            let xPosition = spacing + (CGFloat(col) * itemWidth) + (itemWidth / 2)
            let yPosition = spacing + (CGFloat(row) * (itemWidth + 4)) + (itemWidth / 2)

            let isSelected = selectedItem?.id == item.id
            let isHovered = hoveredDot?.id == item.id

            let currentDotSize = isSelected ? selectedDotSize : dotSize
            let color = item.memoryType.color
            let opacity = isSelected ? 1.0 : (isHovered ? 0.8 : 0.6)

            // Draw memory dot
            let rect = CGRect(
                x: xPosition - currentDotSize/2,
                y: yPosition - currentDotSize/2,
                width: currentDotSize,
                height: currentDotSize
            )

            context.fill(
                Path(ellipseIn: rect),
                with: .color(color.opacity(opacity))
            )

            // Draw glow for important items
            if item.importance > 3 {
                // Draw with glow effect
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(.glow.opacity(0.5 as Double))
                )
            }

            // Draw connection lines for important items
            if item.importance > 3 && index > 0 {
                let prevIndex = index - 1
                let prevRow = prevIndex / itemsPerRow
                let prevCol = prevIndex % itemsPerRow
                let prevXPosition = spacing + (CGFloat(prevCol) * itemWidth) + (itemWidth / 2)
                let prevYPosition = spacing + (CGFloat(prevRow) * (itemWidth + 4)) + (itemWidth / 2)

                var path = Path()
                path.move(to: CGPoint(x: prevXPosition, y: prevYPosition))
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))

                context.stroke(
                    path,
                    with: .color(.glow.opacity(0.3 as Double)),
                    lineWidth: 0.5
                )
            }
        }
    }

    // MARK: - Interaction Overlay
    private func minimapInteractionOverlay(geometry: GeometryProxy) -> some View {
        ZStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                let itemsPerRow = 8
                let spacing: CGFloat = 6
                let availableWidth = geometry.size.width - (spacing * 2)
                let itemWidth = availableWidth / CGFloat(itemsPerRow)

                let row = index / itemsPerRow
                let col = index % itemsPerRow

                let xPosition = spacing + (CGFloat(col) * itemWidth)
                let yPosition = spacing + (CGFloat(row) * (itemWidth + 4))

                Rectangle()
                    .fill(Color.clear)
                    .frame(width: itemWidth, height: itemWidth)
                    .position(x: xPosition + itemWidth/2, y: yPosition + itemWidth/2)
                    .onTapGesture {
                        selectedItem = item
                    }
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.1)) {
                            hoveredDot = hovering ? item : nil
                        }
                    }
            }
        }
    }
}

// MARK: - Preview
struct MemoryMinimapView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryMinimapView(
            items: [
                MemoryItem(title: "Test 1", content: "Content", memoryType: .shortTerm),
                MemoryItem(title: "Test 2", content: "Content", memoryType: .midTerm),
                MemoryItem(title: "Test 3", content: "Content", memoryType: .longTerm)
            ],
            selectedItem: .constant(nil)
        )
        .frame(height: 100)
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
    }
}
