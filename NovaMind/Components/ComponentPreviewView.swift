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
                .font(Font.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            HStack(spacing: 12) {
                Button("Primary") {}
                    .buttonStyle(PrimaryButtonStyle())

                Button("Secondary") {}
                    .buttonStyle(SecondaryButtonStyle())

                Button("Destructive") {}
                    .buttonStyle(DestructiveButtonStyle())
            }
        }
    }

    private var textPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Typography")
                .font(Font.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Large Title")
                    .font(Font.largeTitle)
                    .foregroundColor(.foregroundPrimary)

                Text("Headline")
                    .font(Font.headline)
                    .foregroundColor(.foregroundPrimary)

                Text("Body text with secondary color")
                    .font(Font.body)
                    .foregroundColor(.foregroundSecondary)

                Text("Caption text")
                    .font(Font.caption)
                    .foregroundColor(.foregroundSecondary)
            }
        }
    }

    private var cardPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cards")
                .font(Font.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Card Title")
                        .font(Font.headline)
                        .foregroundColor(.foregroundPrimary)

                    Text("Card content with multiple lines of text to show how it wraps.")
                        .font(Font.body)
                        .foregroundColor(.foregroundSecondary)
                }
                .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
                .background(Color.backgroundPrimary)
                .cornerRadius(CGFloat(8))
                .shadow(color: .novaBlack.opacity(0.1 as Double), radius: 4)

                Spacer()
            }
        }
    }
}
