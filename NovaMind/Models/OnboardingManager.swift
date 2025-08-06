import SwiftUI

// MARK: - Onboarding Manager
class OnboardingManager: ObservableObject {
    @Published var hasCompletedOnboarding = false
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}
