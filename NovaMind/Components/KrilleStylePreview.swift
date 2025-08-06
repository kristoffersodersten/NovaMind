import SwiftUI


// MARK: - KrilleStyle Preview
// Preview implementation for the KrilleCore2030 design system

#if DEBUG
struct KrilleStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: KrilleStyle.Spacing.large) {
            Text("KrilleCore2030 Design System")
                .font(.krilleTitle1(.bold))
                .foregroundColor(.krillePrimary)

            HStack(spacing: KrilleStyle.Spacing.medium) {
                Button("Primary") {}
                    .buttonStyle(KrilleStyle.Components.primaryButton())

                Button("Secondary") {}
                    .buttonStyle(KrilleStyle.Components.secondaryButton())

                Button("Ghost") {}
                    .buttonStyle(KrilleStyle.Components.ghostButton())
            }

            VStack(alignment: .leading, spacing: KrilleStyle.Spacing.small) {
                Text("Card Example")
                    .font(.krilleHeadline())
                    .foregroundColor(.krillePrimary)

                Text("This design system provides comprehensive styling, spacing, colors, and typography standards.")
                    .font(.krilleBody())
                    .foregroundColor(.krilleSecondary)
            }
            .krilleCard()
        }
        .padding(KrilleStyle.Spacing.large)
        .background(Color.krilleBackground)
    }
}
#endif
