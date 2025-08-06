import SwiftUI


/// Main view that implements the 3-panel Nova interface
struct NovaMindMainView: View {
    @StateObject private var enhancedAppState = EnhancedAppState()
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        NovaMainContentView()
            .environmentObject(enhancedAppState)
            .environmentObject(themeManager)
            .preferredColorScheme(ColorScheme.dark) // KrilleCore2030 compliance
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            .background(Color.black)
    }
}

// MARK: - Main Content View
struct NovaMainContentView: View {
    @EnvironmentObject var appState: EnhancedAppState
    
    var body: some View {
        HStack(spacing: 0) {
            // Left Sidebar
            LeftSidebarView()
                .frame(width: 300)
            
            // Main Chat Area
            ChatView()
                .frame(maxWidth: .infinity)
            
            // Right Memory Canvas
            RightMemoryCanvasView()
                .frame(width: 320)
        }
    }
}

// MARK: - App State
class EnhancedAppState: ObservableObject {
    @Published var selectedProject: UUID?
    @Published var selectedThread: UUID?
}

#Preview {
    NovaMindMainView()
}
