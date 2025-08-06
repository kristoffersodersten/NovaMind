import SwiftUI

//
//  NovaMindMainLayout.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-01-20.
//


// MARK: - Panel State Enum (Modular State Management)
enum PanelState {
    case collapsed
    case expanded
    case pinned

    var width: CGFloat {
        switch self {
        case .collapsed: return 60
        case .expanded: return 320
        case .pinned: return 320
        }
    }

    var isLocked: Bool {
        switch self {
        case .pinned: return true
        default: return false
        }
    }
}

// MARK: - Main Layout with Enhanced Modularity
struct NovaMindMainLayout: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var keyboardNavigator = KeyboardPanelNavigator()
    @StateObject private var onboardingManager = OnboardingManager()

    // Modular Panel States (KrilleCore2030 State Management)
    @State private var leftPanelState: PanelState = .collapsed
    @State private var rightPanelState: PanelState = .collapsed
    @State private var isLeftPanelHovered = false
    @State private var isRightPanelHovered = false
    @State private var isDraggingLeftBorder = false
    @State private var isDraggingRightBorder = false

    // Animation State
    @State private var animationPhase: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main 3-Panel Layout
                mainLayoutView(in: geometry)

                // Onboarding Overlay
                if onboardingManager.shouldShowOnboarding {
                    OnboardingSplashView()
                        .environmentObject(onboardingManager)
                        .transition(.opacity.combined(with: .scale))
                        .zIndex(1000)
                }
            }
        }
        .background(Color.backgroundPrimary)
        .environmentObject(navigationManager)
        .environmentObject(keyboardNavigator)
        .environmentObject(onboardingManager)
        .keyboardShortcuts()
        .onAppear {
            setupInitialState()
            startAmbientAnimation()
        }
    }

    // MARK: - Main Layout View
    private func mainLayoutView(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Unified Title Bar
            UnifiedTitleBar(navigationManager: navigationManager)
                .environmentObject(themeManager)

            // Three-Panel Content Area
            HStack(spacing: 0) {
                // Left Panel (Sidebar)
                PanelView(
                    state: leftPanelState,
                    isHovered: isLeftPanelHovered,
                    content: {
                        LeftSidebarView()
                    }
                )
                .frame(width: leftPanelState.width)
                .panelBehavior(
                    state: $leftPanelState,
                    isHovered: $isLeftPanelHovered,
                    panelType: .left
                )

                // Center Panel (Main Chat)
                MainChatView()
                    .frame(maxWidth: .infinity)
                    .panelFocus(.chat, navigator: keyboardNavigator)
                    .background(
                        ParallaxBackground(phase: animationPhase)
                            .animation(.easeInOut(duration: 0.2), value: keyboardNavigator.activePanel)
                    )

                // Right Panel (Memory Canvas)
                PanelView(
                    state: rightPanelState,
                    isHovered: isRightPanelHovered,
                    content: {
                        RightMemoryCanvasView()
                    }
                )
                .frame(width: rightPanelState.width)
                .panelBehavior(
                    state: $rightPanelState,
                    isHovered: $isRightPanelHovered,
                    panelType: .right
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Setup & Animation
    private func setupInitialState() {
        navigationManager.navigateToPanel(.workspace)
        keyboardNavigator.focusPanel(.chat)
    }

    private func startAmbientAnimation() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            animationPhase = 1.0
        }
    }
}

// MARK: - Reusable Panel Component
struct PanelView<Content: View>: View {
    let state: PanelState
    let isHovered: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .parallaxElevation(
                depth: state == .pinned ? 3 : (isHovered ? 2 : 1),
                isActive: state == .pinned || isHovered
            )
            .background(
                RoundedRectangle(cornerRadius: state == .collapsed ? 8 : 16)
                    .fill(Color.backgroundPrimary.opacity(0.95))
                    .shadow(
                        color: Color.novaBlack.opacity(0.1),
                        radius: state == .pinned ? 12 : 8,
                        x: 0,
                        y: state == .pinned ? 4 : 2
                    )
            )
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: state)
            .animation(.easeInOut(duration: 0.25), value: isHovered)
    }
}

// MARK: - Enhanced Chat View with Parallax
struct MainChatView: View {
    @State private var scrollPhase: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            // Chat content with parallax scrolling
            ChatView()
                .background(
                    ParallaxBackground(phase: scrollPhase)
                        .onScroll { offset in
                            scrollPhase = offset * 0.1
                        }
                )

            // Enhanced Input Bar
            InputBarView()
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(color: .glow.opacity(0.1), radius: 8, y: -2)
        }
    }
}

// MARK: - Panel Behavior Modifier
extension View {
    func panelBehavior(
        state: Binding<PanelState>,
        isHovered: Binding<Bool>,
        panelType: PanelType
    ) -> some View {
        self
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.25)) {
                    isHovered.wrappedValue = hovering
                    if hovering && state.wrappedValue == .collapsed {
                        state.wrappedValue = .expanded
                    } else if !hovering && state.wrappedValue == .expanded {
                        state.wrappedValue = .collapsed
                    }
                }
            }
            .onTapGesture(count: 2) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    state.wrappedValue = state.wrappedValue == .pinned ? .collapsed : .pinned
                }
            }
    }
}

// MARK: - Panel Type Helper
enum PanelType {
    case left
    case right
}

// MARK: - Parallax Background Component
struct ParallaxBackground: View {
    let phase: CGFloat

    var body: some View {
        ZStack {
            Color.backgroundPrimary

            // Subtle parallax gradients
            RadialGradient(
                colors: [
                    Color.glow.opacity(0.02),
                    Color.clear
                ],
                center: UnitPoint(x: 0.3 + phase * 0.1, y: 0.7 + phase * 0.05),
                startRadius: 100,
                endRadius: 400
            )

            RadialGradient(
                colors: [
                    Color.novaBlack.opacity(0.01),
                    Color.clear
                ],
                center: UnitPoint(x: 0.7 - phase * 0.08, y: 0.3 + phase * 0.06),
                startRadius: 150,
                endRadius: 300
            )
        }
    }
}

// MARK: - Scroll Detection Extension
extension View {
    func onScroll(_ action: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minY)
            }
        )
        .onPreferenceChange(ScrollOffsetKey.self, perform: action)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Keyboard Shortcuts Extension
extension View {
    func keyboardShortcuts() -> some View {
        self
            .onReceive(
                NotificationCenter.default.publisher(for: NSApplication.keyboardShortcutNotification)
            ) { notification in
                guard let keyCode = notification.userInfo?["keyCode"] as? UInt16,
                      let modifiers = notification.userInfo?["modifiers"] as? NSEvent.ModifierFlags else { return }

                handleKeyboardShortcut(keyCode: keyCode, modifiers: modifiers)
            }
    }

    private func handleKeyboardShortcut(keyCode: UInt16, modifiers: NSEvent.ModifierFlags) {
        switch (keyCode, modifiers) {
        case (18, [.command]): // Cmd+1 - Focus Left Panel
            print("Focus left panel")
        case (19, [.command]): // Cmd+2 - Focus Center Panel
            print("Focus center panel")
        case (123, [.shift, .command]): // Shift+Cmd+Left - Expand Left
            print("Expand left panel")
        case (124, [.shift, .command]): // Shift+Cmd+Right - Expand Right
            print("Expand right panel")
        default:
            break
        }
    }
}

// MARK: - Notification Extension
extension NSApplication {
    static let keyboardShortcutNotification = Notification.Name("KeyboardShortcut")
}

// MARK: - Preview
#Preview {
    NovaMindMainLayout()
        .environmentObject(ThemeManager())
}
