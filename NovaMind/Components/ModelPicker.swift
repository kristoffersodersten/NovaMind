import AppKit
import SwiftUI

// ModelPicker.swift
// Intelligent model selection component for NovaMind
// Supports local model routing with cloud fallback


// MARK: - Model Types
public enum ModelType {
    case local(String)
    case cloud(CloudProvider)
    case auto
}

public enum CloudProvider {
    case gemini
    case deepseek
    case openai
    case azure
}

// MARK: - Model Information
public struct ModelInfo {
    public let id: String
    public let name: String
    public let type: ModelType
    public let isAvailable: Bool
    public let batteryRequired: Int // 0-100, 0 means no requirement
    public let powerRequired: Bool

    public init(id: String,
                name: String,
                type: ModelType,
                isAvailable: Bool = true,
                batteryRequired: Int = 0,
                powerRequired: Bool = false) {
        self.id = id
        self.name = name
        self.type = type
        self.isAvailable = isAvailable
        self.batteryRequired = batteryRequired
        self.powerRequired = powerRequired
    }
}

// MARK: - Model Picker Component
public struct ModelPicker: View {
    @Binding public var selectedModel: String
    @State private var availableModels: [ModelInfo] = []
    @State private var systemStatus = SystemStatus()
    private struct SystemStatus {
        var batteryLevel: Int = 100
        var isPowerConnected: Bool = true
        var isTailscaleAvailable: Bool = false
    }

    public init(selectedModel: Binding<String>) {
        self._selectedModel = selectedModel
    }

    public var body: some View {
        Menu {
            Section("Intelligent Routing") {
                Button("Auto-Select (Recommended)") {
                    selectedModel = "auto"
                }
                .disabled(selectedModel == "auto")
            }

            if !localModels.isEmpty {
                Section("Local Models") {
                    ForEach(localModels, id: \.id) { model in
                        modelButton(for: model)
                    }
                }
            }

            Section("Cloud Models") {
                ForEach(cloudModels, id: \.id) { model in
                    modelButton(for: model)
                }
            }

            Divider()

            Section("System Status") {
                systemStatusView
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: modelIcon)
                    .foregroundColor(.secondary)
                    .scaleEffect(1.0)
                    .shadow(color: .accentColor.opacity(0.3 as Double), radius: 1, x: 0, y: 0)

                Text(selectedModelDisplayName)
                    .systemFont(Font.system(.body))
                    .foregroundColor(.primary)

                Image(systemName: "chevron.down")
                    .systemFont(Font.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(NSColor.quaternaryLabelColor))
            .cornerRadius(CGFloat(6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.accentColor.opacity(0.2 as Double), lineWidth: 1)
                    .shadow(color: .accentColor.opacity(0.3 as Double), radius: 3, x: 0, y: 1)
                    .opacity(0.4 as Double)
            )
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
        }
        .onAppear {
            updateSystemStatus()
            loadAvailableModels()
        }
    }

    // MARK: - Computed Properties
    private var localModels: [ModelInfo] {
        availableModels.filter { model in
            if case .local = model.type {
                return model.isAvailable &&
                       systemStatus.batteryLevel >= model.batteryRequired &&
                       (!model.powerRequired || systemStatus.isPowerConnected)
            }
            return false
        }
    }

    private var cloudModels: [ModelInfo] {
        availableModels.filter { model in
            if case .cloud = model.type {
                return true
            }
            return false
        }
    }

    private var selectedModelDisplayName: String {
        if selectedModel == "auto" {
            return "Auto-Select"
        }
        return availableModels.first { $0.id == selectedModel }?.name ?? selectedModel
    }

    private var modelIcon: String {
        if selectedModel == "auto" {
            return "brain.head.profile"
        }

        guard let model = availableModels.first(where: { $0.id == selectedModel }) else {
            return "cpu"
        }

        switch model.type {
        case .local:
            return "desktopcomputer"
        case .cloud(.gemini):
            return "cloud"
        case .cloud(.deepseek):
            return "cloud.fill"
        case .cloud(.openai):
            return "cloud.bolt"
        case .cloud(.azure):
            return "cloud.rain"
        case .auto:
            return "brain.head.profile"
        }
    }

    // MARK: - Helper Views
    private func modelButton(for model: ModelInfo) -> some View {
        Button {
            selectedModel = model.id
        } label: {
            HStack {
                Image(systemName: modelIcon(for: model))
                VStack(alignment: .leading, spacing: 2) {
                    Text(model.name)
                        .systemFont(Font.system(.body))
                    if !model.isAvailable {
                        Text("Unavailable")
                            .systemFont(Font.caption)
                            .foregroundColor(.secondary)
                    } else if model.batteryRequired > 0 || model.powerRequired {
                        Text("Requires: \(requirementsText(for: model))")
                            .systemFont(Font.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                if selectedModel == model.id {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .disabled(!model.isAvailable ||
                 systemStatus.batteryLevel < model.batteryRequired ||
                 (model.powerRequired && !systemStatus.isPowerConnected))
    }

    private var systemStatusView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "battery.100")
                Text("\(systemStatus.batteryLevel)%")
                Spacer()
                if systemStatus.isPowerConnected {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.green)
                }
            }

            if systemStatus.isTailscaleAvailable {
                HStack {
                    Image(systemName: "network")
                        .foregroundColor(.green)
                    Text("Tailscale Connected")
                }
            }
        }
        .systemFont(Font.caption)
        .foregroundColor(.secondary)
    }

    // MARK: - Helper Functions
    private func modelIcon(for model: ModelInfo) -> String {
        switch model.type {
        case .local:
            return "desktopcomputer"
        case .cloud(.gemini):
            return "cloud"
        case .cloud(.deepseek):
            return "cloud.fill"
        case .cloud(.openai):
            return "cloud.bolt"
        case .cloud(.azure):
            return "cloud.rain"
        case .auto:
            return "brain.head.profile"
        }
    }

    private func requirementsText(for model: ModelInfo) -> String {
        var requirements: [String] = []

        if model.batteryRequired > 0 {
            requirements.append("Battery \(model.batteryRequired)%+")
        }

        if model.powerRequired {
            requirements.append("Power")
        }

        return requirements.joined(separator: ", ")
    }

    private func updateSystemStatus() {
        // Get actual system status
        systemStatus.batteryLevel = getBatteryLevel()
        systemStatus.isPowerConnected = isPowerConnected()
        systemStatus.isTailscaleAvailable = isTailscaleAvailable()
    }

    private func loadAvailableModels() {
        // Load available models based on system configuration
        availableModels = [
            // Local models (requires Tailscale and power)
            ModelInfo(
                id: "local-llama",
                name: "Llama 3 (Local)",
                type: .local("llama3"),
                isAvailable: systemStatus.isTailscaleAvailable,
                batteryRequired: 80,
                powerRequired: true
            ),

            // Cloud models
            ModelInfo(
                id: "gemini-pro",
                name: "Gemini Pro",
                type: .cloud(.gemini)
            ),

            ModelInfo(
                id: "deepseek-chat",
                name: "DeepSeek Chat",
                type: .cloud(.deepseek)
            ),

            ModelInfo(
                id: "gpt-4",
                name: "GPT-4",
                type: .cloud(.openai)
            ),

            ModelInfo(
                id: "azure-gpt",
                name: "Azure GPT",
                type: .cloud(.azure)
            )
        ]
    }

    // MARK: - System Status Functions
    private func getBatteryLevel() -> Int {
        // Implementation would use IOKit to get actual battery level
        return 85 // Placeholder
    }

    private func isPowerConnected() -> Bool {
        // Implementation would check power adapter status
        return true // Placeholder
    }

    private func isTailscaleAvailable() -> Bool {
        // Implementation would check Tailscale connectivity
        return false // Placeholder
    }
}

// MARK: - Preview
#Preview {
    ModelPicker(selectedModel: .constant("auto"))
}
