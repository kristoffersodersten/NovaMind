import SwiftUI

// MARK: - Color Details Panel
struct ColorDetailsPanel: View {
    @Binding var showColorDetails: Bool
    let colorInfo: ColorInfo?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Color Details")
                    .font(.headline)
                    .foregroundColor(.foregroundPrimary)

                Spacer()

                Button(action: { showColorDetails = false }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.foregroundSecondary)
                })
            }

            if let colorInfo = colorInfo {
                colorDetailContent(for: colorInfo)
            } else {
                Text("Hover over a color to see details")
                    .foregroundColor(.foregroundSecondary)
                    .italic()
            }
        }
        .padding()
        .background(Color.backgroundPrimary.opacity(0.9))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.separator),
            alignment: .top
        )
    }

    private func colorDetailContent(for colorInfo: ColorInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(colorInfo.color)
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading) {
                    Text(colorInfo.name)
                        .font(.headline)
                        .foregroundColor(.foregroundPrimary)

                    Text(colorInfo.hexValue)
                        .font(.caption)
                        .monospaced()
                        .foregroundColor(.foregroundSecondary)
                }

                Spacer()
            }

            // Color values in different formats
            VStack(alignment: .leading, spacing: 4) {
                Text("Hex: \(colorInfo.hexValue)")
                Text("RGB: \(colorInfo.rgbValue)")
                Text("HSB: \(colorInfo.hsbValue)")
            }
            .font(.caption)
            .monospaced()
            .foregroundColor(.foregroundSecondary)
        }
    }
}
