import SwiftUI

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme = .system
    
    enum AppTheme: String, CaseIterable {
        case system
        case light
        case dark
        
        var displayName: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            }
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
    
    func toggleTheme() {
        switch currentTheme {
        case .light:
            currentTheme = .dark
        case .dark:
            currentTheme = .light
        case .system:
            currentTheme = .dark
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: 24) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Theme")
                    .font(.headline)
                
                HStack(spacing: 16) {
                    ForEach([ThemeManager.AppTheme.system, .light, .dark], id: \.self) { theme in
                        Button(action: {
                            themeManager.setTheme(theme)
                        }, label: {
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(themePreviewColor(for: theme))
                                    .frame(width: 60, height: 40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                themeManager.currentTheme == theme ?
                                                Color.highlightAction : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                Text(theme.displayName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
    }
    
    private func themePreviewColor(for theme: ThemeManager.AppTheme) -> Color {
        switch theme {
        case .system:
            return Color.gray.opacity(0.3)
        case .light:
            return Color.white
        case .dark:
            return Color.black
        }
    }
}
