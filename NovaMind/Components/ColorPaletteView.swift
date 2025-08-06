import SwiftUI

// MARK: - Color Palette View
struct ColorPaletteView: View {
    @Binding var hoveredColor: String?
    @Binding var customColor: Color
    @Binding var showColorPicker: Bool
    
    let colors: [ColorInfo]
    let onCopy: (String) -> Void
    let onAddToFavorites: (ColorInfo) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
            ForEach(colors, id: \.name) { colorInfo in
                colorTile(for: colorInfo)
            }
            addCustomColorTile
        }
    }

    private func colorTile(for colorInfo: ColorInfo) -> some View {
        let isHovered = hoveredColor == colorInfo.name

        return VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(colorInfo.color)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.separator, lineWidth: 1)
                )
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .shadow(color: colorInfo.color.opacity(0.3), radius: isHovered ? 8 : 0)

            Text(colorInfo.name)
                .font(.caption)
                .foregroundColor(.foregroundSecondary)
                .lineLimit(1)

            Text(colorInfo.hexValue)
                .font(.caption2)
                .foregroundColor(.foregroundSecondary.opacity(0.7))
                .monospaced()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovered)
        .onHover { hovering in
            hoveredColor = hovering ? colorInfo.name : nil
        }
        .onTapGesture {
            onCopy(colorInfo.hexValue)
        }
        .contextMenu {
            colorContextMenu(for: colorInfo)
        }
    }

    private var addCustomColorTile: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(customColor.opacity(0.8))
                .frame(height: 60)
                .overlay(
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                )
                .onTapGesture {
                    showColorPicker = true
                }

            Text("Custom")
                .font(.caption)
                .foregroundColor(.foregroundSecondary)
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPicker("Select Custom Color", selection: $customColor)
                .padding()
        }
    }
    
    private func colorContextMenu(for colorInfo: ColorInfo) -> some View {
        VStack {
            Button("Copy Hex") {
                onCopy(colorInfo.hexValue)
            }

            Button("Copy RGB") {
                onCopy(colorInfo.rgbValue)
            }

            Button("Copy HSB") {
                onCopy(colorInfo.hsbValue)
            }

            Divider()

            Button("Add to Favorites") {
                onAddToFavorites(colorInfo)
            }
        }
    }
}
