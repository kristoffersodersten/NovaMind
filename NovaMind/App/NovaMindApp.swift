import AppKit
import Combine
import CoreHaptics
import SwiftUI

//
//  NovaMindApp.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-26.
//


@main
struct NovaMindApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var dataController = DataController()
    @StateObject private var guiController = NovaMindGUIController()
    @StateObject private var ecosystemHealthMonitor = EcosystemHealthMonitor()
    @State private var windowSize: CGSize = CGSize(width: 1200, height: 800)
    @State private var showPerformanceOverlay = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Enhanced main layout with AI optimization
                NovaMindMainLayout()
                    .environmentObject(themeManager)
                    .environmentObject(dataController)
                    .environmentObject(guiController)
                    .environmentObject(ecosystemHealthMonitor)
                    .preferredColorScheme(.dark)
                    .frame(minWidth: 800, minHeight: 600)
                    .onReceive(NotificationCenter.default.publisher(for: NSWindow.didResizeNotification)) { _ in
                        updateWindowSize()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .togglePerformanceOverlay)) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showPerformanceOverlay.toggle()
                        }
                    }
                    .onAppear {
                        setupNovaMindQuantumSystem()
                        updateWindowSize()
                    }

                // AI-driven performance overlay
                if showPerformanceOverlay {
                    // TODO: Implement NovaMindPerformanceOverlay
                    /*
                    NovaMindPerformanceOverlay(
                        systemHealth: guiController.systemState,
                        dataFlowMetrics: guiController.dataFlow,
                        ecosystemHealth: ecosystemHealthMonitor.healthScore
                    )
                    .transition(.opacity.combined(with: .scale))
                    */
                }

                // Real-time connection status
                // TODO: Implement NovaMindConnectionStatusView
                /*
                NovaMindConnectionStatusView(
                    networkStatus: guiController.networkStatus,
                    systemStatus: ecosystemHealthMonitor.overallHealth > 0.8 ? .operational :
                                 ecosystemHealthMonitor.overallHealth > 0.5 ? .degraded : .failing
                )
                */
            }
        }
        // .windowStyle(.hiddenTitleBar) // TODO: Fix WindowStyle for current Swift version
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Chat") {
                    // Handle new chat
                }
                .keyboardShortcut("n", modifiers: [.command])
            }

            CommandGroup(before: .help) {
                Button("Toggle Performance Overlay") {
                    NotificationCenter.default.post(name: .togglePerformanceOverlay, object: nil)
                }
                .keyboardShortcut("p", modifiers: [.command, .option])

                Button("Force Health Check") {
                    Task {
                        await ecosystemHealthMonitor.forceHealthCheck()
                    }
                }
                .keyboardShortcut("h", modifiers: [.command, .option])
            }
        }
        .windowToolbarStyle(.unified)

        Settings {
            SettingsView()
                .environmentObject(themeManager)
        }
    }

    private func updateWindowSize() {
        if let window = NSApplication.shared.windows.first {
            windowSize = window.frame.size
        }
    }

    private func setupNovaMindQuantumSystem() {
        print("🚀 NovaMind Quantum-Constitutional Organic Mesh System Starting...")

        // Initialize AI-driven optimizations
        // guiController.initializeOptimizations() // TODO: Fix GUI controller method

        // Start ecosystem health monitoring
        ecosystemHealthMonitor.startMonitoring()

        // Setup performance tracking
        // PerformanceMonitor.shared.startMonitoring() // TODO: Implement PerformanceMonitor

        print("✅ All quantum systems initialized successfully")
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let togglePerformanceOverlay = Notification.Name("togglePerformanceOverlay")
}

// TODO: Fix WindowStyle implementation for current Swift version
/*
struct HiddenTitleBarWindowStyle: WindowStyle {
    func makeBody(configuration: WindowStyleConfiguration) -> some View {
        configuration.content
            .background(WindowAccessor { window in
                window?.titleVisibility = .hidden
                window?.titlebarAppearsTransparent = true
                window?.isMovableByWindowBackground = true
            })
    }
}
*/

struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                self.callback(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
