import SwiftUI

//
//  OnboardingSplashView.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-01-20.
//


struct OnboardingSplashView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @State private var animationPhase: CGFloat = 0
    @State private var currentStep = 0

    private let totalSteps = 3

    var body: some View {
        ZStack {
            // Background with blur effect
            Color.novaBlack.opacity(0.9)
                .ignoresSafeArea()
                .background(Material.ultraThin)

            VStack(spacing: 32) {
                // Logo and title section
                VStack(spacing: 16) {
                    Image(systemName: "brain.head.profile")
                        .font(Font.system(size: 80, weight: .light))
                        .foregroundColor(Color.glow)
                        .scaleEffect(1.0 + animationPhase * 0.1)
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animationPhase)

                    Text("Welcome to NovaMind")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.foregroundPrimary)

                    Text("Your AI-powered cognitive workspace")
                        .font(.title2)
                        .foregroundColor(Color.foregroundSecondary)
                        .multilineTextAlignment(.center)
                }

                // Onboarding steps
                onboardingStepView

                // Action buttons
                actionButtonsView
            }
            .padding(40)
            .frame(maxWidth: 600)
        }
        .onAppear {
            startAnimation()
        }
    }

    // MARK: - Onboarding Step View
    private var onboardingStepView: some View {
        VStack(spacing: 24) {
            // Progress indicator
            HStack {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? Color.glow : Color.separator)
                        .frame(width: 12, height: 12)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }

            // Step content
            Group {
                switch currentStep {
                case 0:
                    welcomeStepView
                case 1:
                    featuresStepView
                case 2:
                    readyStepView
                default:
                    welcomeStepView
                }
            }
            .frame(minHeight: 150)
            .animation(.easeInOut(duration: 0.5), value: currentStep)
        }
    }

    // MARK: - Step Views
    private var welcomeStepView: some View {
        VStack(spacing: 16) {
            Text("Intelligent Workspace")
                .font(Font.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.foregroundPrimary)

            Text("NovaMind combines AI-powered conversations with spatial memory organization, " +
                 "creating a seamless cognitive workspace for your thoughts and projects.")
                .font(Font.body)
                .foregroundColor(Color.foregroundSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }

    private var featuresStepView: some View {
        VStack(spacing: 16) {
            Text("Core Features")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(
                    icon: "message.fill",
                    title: "AI Conversations",
                    description: "Natural language interactions with advanced AI"
                )
                FeatureRow(
                    icon: "brain.head.profile",
                    title: "Memory Canvas",
                    description: "Visual organization of your knowledge and ideas"
                )
                FeatureRow(
                    icon: "folder.fill",
                    title: "Project Management",
                    description: "Context-aware project tracking and insights"
                )
            }
        }
    }

    private var readyStepView: some View {
        VStack(spacing: 16) {
            Text("Ready to Begin")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.foregroundPrimary)

            Text("You're all set! NovaMind will adapt to your workflow and help you organize " +
                 "your thoughts, projects, and conversations in a natural, intuitive way.")
                .font(.body)
                .foregroundColor(.foregroundSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }

    // MARK: - Action Buttons
    private var actionButtonsView: some View {
        HStack(spacing: 16) {
            if currentStep > 0 {
                Button("Previous") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep -= 1
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            Spacer()

            Button(currentStep < totalSteps - 1 ? "Next" : "Get Started") {
                if currentStep < totalSteps - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep += 1
                    }
                } else {
                    onboardingManager.completeOnboarding()
                }
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    // MARK: - Helper Methods
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 2)) {
            animationPhase = 1.0
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.glow)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .font(Font.headline)
                    .foregroundColor(Color.foregroundPrimary)

                Text(description)
                    .font(Font.subheadline)
                    .foregroundColor(Color.foregroundSecondary)
                    .lineLimit(nil)

            Spacer()
        }
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.glow)
            .foregroundColor(.backgroundPrimary)
            .font(.headline)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.separator.opacity(0.2))
            .foregroundColor(.foregroundSecondary)
            .font(.headline)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    OnboardingSplashView()
        .environmentObject(OnboardingManager())
        .preferredColorScheme(.dark)
}
