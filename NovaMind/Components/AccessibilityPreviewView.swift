import SwiftUI

// MARK: - Accessibility Preview View
struct AccessibilityPreviewView: View {
    let contrastTests: [ContrastTest]

    var body: some View {
        VStack(spacing: 16) {
            contrastRatioSection
            colorBlindnessSection
        }
    }

    private var contrastRatioSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contrast Ratios")
                .font(Font.system(.subheadline))
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            VStack(spacing: 4) {
                ForEach(contrastTests, id: \.background) { test in
                    contrastTestRow(for: test)
                }
            }
        }
    }

    private func contrastTestRow(for test: ContrastTest) -> some View {
        HStack {
            Text("Sample Text")
                .foregroundColor(test.foreground)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(test.background)
                .cornerRadius(CGFloat(4))

            Spacer()

            Text(String(format: "%.1f:1", test.ratio))
                .font(Font.caption)
                .monospaced()
                .foregroundColor(test.isAccessible ? .green : .red)

            Image(systemName: test.isAccessible ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(test.isAccessible ? .green : .red)
                .font(Font.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.backgroundPrimary.opacity(0.5 as Double))
        .cornerRadius(CGFloat(6))
    }

    private var colorBlindnessSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color Blindness Simulation")
                .font(Font.system(.subheadline))
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            Text("Testing how colors appear to users with different types of color vision deficiency")
                .font(Font.caption)
                .foregroundColor(.foregroundSecondary)
        }
    }
}
