import SwiftUI

// MARK: - Component Preview View
struct ComponentPreviewView: View {
    var body: some View {
        VStack(spacing: 20) {
            buttonPreviewSection
            textPreviewSection
            cardPreviewSection
        }
    }

    private var buttonPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Buttons")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            HStack(spacing: 12) {
                Button("Primary") {}
                    .buttonStyle(.borderedProminent)

                Button("Secondary") {}
                    .buttonStyle(.bordered)

                Button("Destructive") {}
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    private var textPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Typography")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Large Title")
                    .font(.largeTitle)
                    .foregroundColor(.foregroundPrimary)

                Text("Headline")
                    .font(.headline)
                    .foregroundColor(.foregroundPrimary)

                Text("Body text with secondary color")
                    .font(.body)
                    .foregroundColor(.foregroundSecondary)

                Text("Caption text")
                    .font(.caption)
                    .foregroundColor(.foregroundSecondary)
            }
        }
    }

    private var cardPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cards")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Card Title")
                        .font(.headline)
                        .foregroundColor(.foregroundPrimary)

                    Text("Card content with multiple lines of text to show how it wraps.")
                        .font(.body)
                        .foregroundColor(.foregroundSecondary)
                }
                .padding()
                .background(Color.backgroundPrimary)
                .cornerRadius(8)
                .shadow(color: .novaBlack.opacity(0.1), radius: 4)

                Spacer()
            }
        }
    }
}
