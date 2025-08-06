import AppKit // For Color(.systemBackground) on macOS
import Foundation
import SwiftUI

// import NovaMind.Core.Types.MemoryScope
// import NovaMind.UI.Components.IconButton

// Note: MCPTypes are defined in ../../Shared/MCPTypes.swift

// MARK: - Local ChatMessage Model for WorkspaceView

struct WorkspaceChatMessage: Identifiable {
  let id = UUID()
  let sender: SenderType
  let text: String
  let agent: AgentProfile?
  let accent: Color?
  let scope: MemoryScope
}

enum SenderType {
  case user
  case assistant
}

struct AgentProfile {
  let id: String
  let name: String
  let icon: String  // SF Symbol name
  let accent: Color
  let modelType: String
}

// MARK: - MainWorkspaceView

struct MainWorkspaceView: View {
  @State private var messages: [WorkspaceChatMessage] = [
    WorkspaceChatMessage(
      sender: .user,
      text: "Hej, vad är NovaMind?",
      agent: nil,
      accent: nil,
      scope: MemoryScope.individual("user")
    ),
    WorkspaceChatMessage(
      sender: .assistant,
      text: "NovaMind är en AI-assistent som hjälper dig med utveckling.",
      agent: AgentProfile(
        id: "nova",
        name: "Nova",
        icon: "brain",
        accent: Color.blue,
        modelType: "GPT-4"
      ),
      accent: Color.blue,
      scope: MemoryScope.entity("nova")
    ),
    WorkspaceChatMessage(
      sender: .assistant,
      text: "Jag kan hjälpa till med kodning, design och planering.",
      agent: AgentProfile(
        id: "assistant",
        name: "Assistant",
        icon: "gear",
        accent: Color.green,
        modelType: "Claude"
      ),
      accent: Color.green,
      scope: MemoryScope.entity("assistant")
    )
  ]
  @State private var inputText: String = ""
  @FocusState private var inputFocused: Bool
  @State private var isMicActive = false
  @State private var isWebSearchActive = false
  @State private var isNoiseFilterActive = false
  @State private var filePreview: Image?

  var body: some View {
    VStack(spacing: 0) {
      // Chatbubblor
      ScrollView {
        VStack(spacing: 18) {
          ForEach(messages) { msg in
            WorkspaceChatBubble(message: msg)
          }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
      }
      .background(Color(NSColor.controlBackgroundColor))
      .parallaxEffect()

      // Inputfält + ikonrad
      VStack(spacing: 8) {
        ZStack(alignment: .bottom) {
          TextEditor(text: $inputText)
            .font(Font.custom("SF Pro", size: 16))
            .frame(height: dynamicHeight())
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.05), radius: 1, y: 1)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.12), lineWidth: 1)
            )
            .focused($inputFocused)
            .padding(.horizontal, 4)
            .background(Color.white)
            .animation(.spring(), value: inputText)

          if filePreview != nil {
            filePreview!
              .resizable()
              .scaledToFit()
              .frame(maxHeight: 100)
              .cornerRadius(8)
              .padding(.bottom, 8)
          }
        }
        // Ikonrad
        HStack(spacing: 18) {
          IconButton(systemName: "folder.fill", active: filePreview != nil) {
            // Öppna Finder
          }
          IconButton(systemName: "globe", active: isWebSearchActive) {
            isWebSearchActive.toggle()
          }
          IconButton(systemName: "mic.fill", active: isMicActive, pulse: isMicActive) {
            isMicActive.toggle()
          }
          IconButton(
            systemName: "waveform.slash", active: isNoiseFilterActive, pulse: isNoiseFilterActive
          ) {
            isNoiseFilterActive.toggle()
          }
          Spacer()
          Button(action: sendMessage) {
            Image(systemName: "arrow.up.circle.fill")
              .font(Font.title2)
              .foregroundColor(.accentColor)
              .glowEffect(active: inputText.count > 0)
          }
          .keyboardShortcut(.return, modifiers: [.command])
        }
        .padding(.horizontal, 4)
      }
      .padding(.vertical, 12)
      .background(Color(.systemBackground))
      .shadow(color: .black.opacity(0.04), radius: 2, y: -1)
    }
    .background(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(Color(NSColor.controlBackgroundColor).opacity(0.98))
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
    )
    .padding(.horizontal, 8)
    .zIndex(2)
    .offset(y: -0.5)
    .animation(.spring(response: 0.5, dampingFraction: 0.85), value: inputText)
    .onAppear {
      connectWebSocket()
    }
  }

  func dynamicHeight() -> CGFloat {
    let lines = max(1, inputText.components(separatedBy: "\n").count)
    return min(max(64, CGFloat(lines) * 24), 140)
  }

  func sendMessage() {
    guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    // Skicka till backend via websocket
    inputText = ""
  }

  func connectWebSocket() {
    // Implementera websocket-to-websocket koppling till MCPN
  }
}

// MARK: - WorkspaceChatBubble

struct WorkspaceChatBubble: View {
  let message: WorkspaceChatMessage
  var body: some View {
    HStack {
      if message.sender == .user {
        BubbleContent(message: message)
        Spacer()
      } else {
        Spacer()
        BubbleContent(message: message)
      }
    }
    .transition(
      .move(edge: message.sender == .user ? .leading : .trailing).combined(with: .opacity)
    )
    .animation(.spring(), value: message.id)
  }
}

struct BubbleContent: View {
  let message: WorkspaceChatMessage
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        if let agent = message.agent {
          Image(systemName: agent.icon)
            .foregroundColor(agent.accent)
            .font(Font.title3)
            .glowEffect(active: true)
          Text(agent.name)
            .font(Font.caption)
            .foregroundColor(agent.accent)
            .bold()
        } else {
          Image(systemName: "person.crop.circle")
            .foregroundColor(.gray)
            .font(Font.title3)
          Text("User")
            .font(Font.caption)
            .foregroundColor(.gray)
            .bold()
        }
      }
      Text(message.text)
        .font(Font.custom("SF Pro", size: 16))
        .foregroundColor(.primary)
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .background(message.sender == .user ? Color(NSColor.controlColor) : Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
    }
    .padding(.vertical, 2)
    .padding(.horizontal, 4)
  }
}

// IconButton is now imported from dedicated IconButton.swift file

// MARK: - View Extensions

extension View {
  func parallaxEffect(strength: CGFloat = 0.08) -> some View {
    GeometryReader { geo in
      self.offset(y: -geo.frame(in: .global).minY * strength)
    }
  }
}
