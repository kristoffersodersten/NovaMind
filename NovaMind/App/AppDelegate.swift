import Cocoa
import SwiftUI

//
//  AppDelegate.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


class AppDelegate: NSObject, NSApplicationDelegate {
    var settingsWindow: NSWindow?
    var settingsController: NSWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMainMenu()
        setupAppearance()
    }

    private func setupMainMenu() {
        let mainMenu = NSMenu()

        // App Menu
        let appMenu = NSMenuItem()
        mainMenu.addItem(appMenu)

        let appMenuContent = NSMenu()
        appMenuContent.addItem(withTitle: "About NovaMind", action: #selector(showAbout), keyEquivalent: "")
        appMenuContent.addItem(.separator())
        appMenuContent.addItem(withTitle: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        appMenuContent.addItem(.separator())
        appMenuContent.addItem(withTitle: "Hide NovaMind",
                              action: #selector(NSApplication.hide(_:)),
                              keyEquivalent: "h")
        appMenuContent.addItem(withTitle: "Hide Others",
                              action: #selector(NSApplication.hideOtherApplications(_:)),
                              keyEquivalent: "h")
        appMenuContent.addItem(withTitle: "Show All",
                              action: #selector(NSApplication.unhideAllApplications(_:)),
                              keyEquivalent: "")
        appMenuContent.addItem(.separator())
        appMenuContent.addItem(withTitle: "Quit NovaMind",
                              action: #selector(NSApplication.terminate(_:)),
                              keyEquivalent: "q")

        appMenu.submenu = appMenuContent

        // File Menu
        let fileMenu = NSMenuItem()
        mainMenu.addItem(fileMenu)

        let fileMenuContent = NSMenu()
        fileMenuContent.addItem(withTitle: "New Chat", action: #selector(newChat), keyEquivalent: "n")
        fileMenuContent.addItem(withTitle: "Open...", action: #selector(openDocument), keyEquivalent: "o")
        fileMenuContent.addItem(.separator())
        fileMenuContent.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")

        fileMenu.submenu = fileMenuContent

        NSApp.mainMenu = mainMenu
    }

    private func setupAppearance() {
        if #available(macOS 11.0, *) {
            NSApp.appearance = NSAppearance(named: .darkAqua)
        }
    }

    @objc func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView()
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 420, height: 500),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered, defer: false)

            window.title = "Settings"
            window.center()
            window.contentView = NSHostingView(rootView: settingsView)
            window.isReleasedWhenClosed = false

            settingsWindow = window
            settingsController = NSWindowController(window: window)
        }

        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func showAbout() {
        NSApp.orderFrontStandardAboutPanel(options: [:])
    }

    @objc func newChat() {
        // Implement new chat action
    }

    @objc func openDocument() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true

        if openPanel.runModal() == .OK {
            let url = openPanel.url
            // Handle file opening
        }
    }

    @objc private func showAbout() {
        NSApp.orderFrontStandardAboutPanel(nil)
    }

    func showSettings() {
        showSettingsWindow()
    }

    @objc private func showSettingsWindow() {
        if settingsWindow == nil {
            let settingsView = SettingsView()
                .environmentObject(ThemeManager.shared)
            let hostingController = NSHostingController(rootView: settingsView)

            settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            settingsWindow?.title = "Settings"
            settingsWindow?.contentViewController = hostingController
            settingsWindow?.center()
        }

        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func focusLeftPanel() {
        NotificationCenter.default.post(name: NSNotification.Name("FocusLeftPanel"), object: nil)
    }

    @objc private func focusChat() {
        NotificationCenter.default.post(name: NSNotification.Name("FocusChat"), object: nil)
    }

    @objc private func focusRightPanel() {
        NotificationCenter.default.post(name: NSNotification.Name("FocusRightPanel"), object: nil)
    }
}
