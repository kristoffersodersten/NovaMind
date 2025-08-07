import SwiftUI


// MARK: - KrilleStyle Preview
// Preview implementation for the KrilleCore2030 design system

#if DEBUG
struct KrilleStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: KrilleStyle.Spacing.large) {
            Text("KrilleCore2030 Design System")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            HStack(spacing: KrilleStyle.Spacing.medium) {
                Button("Primary") {}
                    .buttonStyle(.borderedProminent)

                Button("Secondary") {}
                    .buttonStyle(.bordered)

                Button("Ghost") {}
                    .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: KrilleStyle.Spacing.small) {
                Text("Card Example")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("This design system provides comprehensive styling, spacing, colors, and typography standards.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.controlBackgroundColor))
            .cornerRadius(8)
        }
        .padding(KrilleStyle.Spacing.large)
        .background(Color(.windowBackgroundColor))
    }
}
#endif
