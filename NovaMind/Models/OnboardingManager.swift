import SwiftUI

// MARK: - Onboarding Manager
class OnboardingManager: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var shouldShowOnboarding = false
    @Published var currentStep = 0
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        withAnimation(.easeInOut(duration: 0.5)) {
            shouldShowOnboarding = false
        }
    }
}
