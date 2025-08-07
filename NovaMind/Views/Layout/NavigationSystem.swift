import AppKit
import SwiftUI


// MARK: - Navigation Manager
class NavigationManager: ObservableObject {
    @Published var selectedPanel: PanelType = .workspace
    @Published var navigationHistory: [NavigationState] = []
    @Published var currentHistoryIndex: Int = -1

    // MARK: - Panel Navigation
    func navigateToPanel(_ panel: PanelType) {
        selectedPanel = panel
        addToHistory(NavigationState(panel: panel, timestamp: Date()))
    }

    // MARK: - Keyboard Shortcuts
    func handleKeyboardShortcut(_ key: String) {
        switch key {
        case "1": navigateToPanel(.sidebar)
        case "2": navigateToPanel(.workspace)
        case "3": navigateToPanel(.memoryCanvas)
        default: break
        }
    }

    // MARK: - History Management
    private func addToHistory(_ state: NavigationState) {
        // Remove any future history if we're not at the end
        if currentHistoryIndex < navigationHistory.count - 1 {
            navigationHistory.removeSubrange((currentHistoryIndex + 1)...)
        }

        navigationHistory.append(state)
        currentHistoryIndex = navigationHistory.count - 1

        // Limit history to 50 items
        if navigationHistory.count > 50 {
            navigationHistory.removeFirst()
            currentHistoryIndex -= 1
        }
    }

    func canGoBack() -> Bool {
        return currentHistoryIndex > 0
    }

    func canGoForward() -> Bool {
        return currentHistoryIndex < navigationHistory.count - 1
    }

    func goBack() {
        guard canGoBack() else { return }
        currentHistoryIndex -= 1
        selectedPanel = navigationHistory[currentHistoryIndex].panel
    }

    func goForward() {
        guard canGoForward() else { return }
        currentHistoryIndex += 1
        selectedPanel = navigationHistory[currentHistoryIndex].panel
    }
}

// MARK: - Navigation State
struct NavigationState {
    let panel: PanelType
    let timestamp: Date
    let id = UUID()
}

// MARK: - Panel Type
enum PanelType: String, CaseIterable {
    case sidebar = "sidebar"
    case workspace = "workspace"
    case memoryCanvas = "memory_canvas"

    var displayName: String {
        switch self {
        case .sidebar: return "Sidebar"
        case .workspace: return "Workspace"
        case .memoryCanvas: return "Memory Canvas"
        }
    }

    var iconName: String {
        switch self {
        case .sidebar: return "sidebar.left"
        case .workspace: return "text.bubble"
        case .memoryCanvas: return "brain"
        }
    }

    var keyboardShortcut: String {
        switch self {
        case .sidebar: return "⌘1"
        case .workspace: return "⌘2"
        case .memoryCanvas: return "⌘3"
        }
    }
}

// MARK: - Unified Title Bar
struct UnifiedTitleBar: View {
    @ObservedObject var navigationManager: NavigationManager
    @EnvironmentObject var themeManager: ThemeManager

    @State private var isHovered = false
    @State private var showNavigationMenu = false

    var body: some View {
        HStack(spacing: 0) {
            // MARK: - Navigation Controls
            HStack(spacing: 8) {
                // Back button
                Button(action: { navigationManager.goBack() }) {
                    Image(systemName: "chevron.left")
                        .systemFont(Font.system(size: 14, weight: .medium))
                        .foregroundColor(navigationManager.canGoBack() ? .glow : .foregroundSecondary)
                }
                .disabled(!navigationManager.canGoBack())
                .buttonStyle(TitleBarButtonStyle())

                // Forward button
                Button(action: { navigationManager.goForward() }) {
                    Image(systemName: "chevron.right")
                        .systemFont(Font.system(size: 14, weight: .medium))
                        .foregroundColor(navigationManager.canGoForward() ? .glow : .foregroundSecondary)
                }
                .disabled(!navigationManager.canGoForward())
                .buttonStyle(TitleBarButtonStyle())

                // Navigation menu
                Menu {
                    ForEach(PanelType.allCases, id: \.self) { panel in
                        Button(action: { navigationManager.navigateToPanel(panel) }) {
                            Label {
                                HStack {
                                    Text(panel.displayName)
                                    Spacer()
                                    Text(panel.keyboardShortcut)
                                        .foregroundColor(.foregroundSecondary)
                                }
                            } icon: {
                                Image(systemName: panel.iconName)
                                    .foregroundColor(navigationManager.selectedPanel == panel ? .glow : .foregroundPrimary)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "list.bullet")
                        .systemFont(Font.system(size: 14, weight: .medium))
                        .foregroundColor(.glow)
                }
                .buttonStyle(TitleBarButtonStyle())
            }

            Spacer()

            // MARK: - Current Panel Indicator
            HStack(spacing: 8) {
                Image(systemName: navigationManager.selectedPanel.iconName)
                    .systemFont(Font.system(size: 12))
                    .foregroundColor(.glow)

                Text(navigationManager.selectedPanel.displayName)
                    .systemFont(Font.custom("SF Pro", size: 14, relativeTo: .body))
                    .fontWeight(.medium)
                    .foregroundColor(.foregroundPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color.novaGray.opacity(0.3))
            .cornerRadius(6)

            Spacer()

            // MARK: - System Controls
            HStack(spacing: 8) {
                // Theme toggle
                Button(action: { themeManager.toggleTheme() }) {
                    Image(systemName: themeManager.currentTheme == .dark ? "sun.max" : "moon")
                        .systemFont(Font.system(size: 14))
                        .foregroundColor(.glow)
                }
                .buttonStyle(TitleBarButtonStyle())

                // Window controls placeholder
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.red.opacity(0.7))
                        .frame(width: 12, height: 12)
                    Circle()
                        .fill(Color.yellow.opacity(0.7))
                        .frame(width: 12, height: 12)
                    Circle()
                        .fill(Color.green.opacity(0.7))
                        .frame(width: 12, height: 12)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.backgroundPrimary.opacity(0.95))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.separator),
            alignment: .bottom
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Title Bar Button Style
struct TitleBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
            .background(
                Circle()
                    .fill(configuration.isPressed ? Color.novaGray : Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Keyboard Shortcuts Handler
struct KeyboardShortcutsView: NSViewRepresentable {
    let navigationManager: NavigationManager

    func makeNSView(context: Context) -> NSView {
        let view = KeyboardHandlerView()
        view.navigationManager = navigationManager
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

class KeyboardHandlerView: NSView {
    var navigationManager: NavigationManager?

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        let modifierFlags = event.modifierFlags

        if modifierFlags.contains(.command) {
            switch event.charactersIgnoringModifiers {
            case "1", "2", "3":
                navigationManager?.handleKeyboardShortcut(event.charactersIgnoringModifiers ?? "")
                return
            default:
                break
            }
        }

        super.keyDown(with: event)
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.makeFirstResponder(self)
    }
}
