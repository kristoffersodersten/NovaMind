import AppKit
import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        VStack {
            VStack {
                Text("Welcome to NovaMind")
                    .systemFont(Font.largeTitle)
                    .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))

                Text("Getting started...")
                    .systemFont(Font.body)
                    .foregroundColor(.secondary)
            }

            Button(action: completeOnboarding) {
                Text("Fortsätt")
                    .systemFont(Font.custom("SF Pro", size: 18).weight(.medium))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.accentColor)
                            .shadow(color: Color.accentColor.opacity(0.18 as Double), radius: 8, x: 0, y: 2)
                    )
                    .foregroundColor(.white)
                    .glowEffect(active: true)
                    .krilleHover()
                    .accessibilityLabel("Fortsätt onboarding")
            }
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        }
        .background(Color(NSColor.windowBackgroundColor))
        .ignoresSafeArea(edges: .bottom)
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
        dismiss()
    }
}
