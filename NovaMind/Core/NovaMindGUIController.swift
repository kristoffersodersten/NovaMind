import Foundation
import Combine

class NovaMindGUIController: ObservableObject {
    @Published var currentView: String = "main"
    
    init() {
        // Initialize GUI controller
    }
    
    func navigateTo(_ view: String) {
        currentView = view
    }
}
