import SwiftUI

// MARK: - Gradient Preview View
struct GradientPreviewView: View {
    let gradients: [GradientPreset]
    let onCopy: (GradientPreset) -> Void

    var body: some View {
        VStack(spacing: 16) {
            ForEach(gradients, id: \.name) { gradient in
                gradientRow(for: gradient)
            }
        }
    }

    private func gradientRow(for gradient: GradientPreset) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(gradient.name)
                    .systemFont(Font.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.foregroundPrimary)

                Spacer()

                Button("Copy") {
                    onCopy(gradient)
                }
                .systemFont(Font.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.glow.opacity(0.2 as Double))
                .foregroundColor(.glow)
                .cornerRadius(CGFloat(4))
            }

            RoundedRectangle(cornerRadius: 8)
                .fill(gradient.gradient)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.separator, lineWidth: 1)
                )
        }
    }
}
