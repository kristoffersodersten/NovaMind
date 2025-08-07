import AppKit
import SwiftUI


/// Central workspace view – NovaMindMacOS
/// Visar chatthistorik, InputBar och stöd för framtida multi-AI-svar.
/// All logik är mock/dummy tills backend kopplas in.
struct RealtimeWorkspaceView: View {
  @State private var messages: [Models.Message] = [
    Models.Message(
      role: Role.assistant,
      content: "Hej! Hur kan jag hjälpa dig idag?",
      timestamp: Date().addingTimeInterval(-300)
    ),
    Models.Message(
      role: Role.user,
      content: "Visa example på NovaMind-layout.",
      timestamp: Date().addingTimeInterval(-250)
    ),
    Models.Message(
      role: Role.assistant,
      content: "Här är en översikt över NovaMind-panelerna...",
      timestamp: Date().addingTimeInterval(-200)
    )
  ]
  @State private var inputText: String = ""
  @FocusState private var inputFocused: Bool

  // Inject MultiAIChatService (dummy for now)
  // @StateObject private var chatService = MultiAIChatServiceCore() // Kommentera ut om klassen saknas

  var body: some View {
    VStack(spacing: 0) {
      // Titelrad
      HStack {
        Text("NovaMind")
          .systemFont(Font.title2)
          .fontWeight(.semibold)
          .foregroundStyle(.primary)
        Spacer()
        // Plats för framtida multi-AI-ikoner eller status
        HStack(spacing: 8) {
          Image(systemName: "brain.head.profile")
            .foregroundStyle(Color.accentColor)
          Image(systemName: "sparkles")
            .foregroundStyle(.yellow)
        }
        .opacity(0.7)
      }
      .padding(.horizontal)
      .padding(.top, 12)
      .padding(.bottom, 4)
      .background(Material.ultraThinMaterial)
      .shadow(color: .black.opacity(0.04), radius: 2, y: 1)

      Divider()

      // Chattfönster
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack(spacing: 12) {
            ForEach(messages) { msg in
              ChatBubble(message: msg)
                .id(msg.id)
            }
          }
          .padding(.vertical, 16)
          .padding(.horizontal, 12)
        }
        .background(Color(.windowBackgroundColor))
        .onChange(of: messages.count) { _ in
          // Scrolla till senaste meddelandet
          if let last = messages.last {
            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
          }
        }
      }

      // InputBar
      InputBar(
        text: $inputText,
        onSend: sendMessage,
        isFocused: _inputFocused
      )
      .padding(.horizontal)
      .padding(.bottom, 8)
      .background(.ultraThinMaterial)
      .cornerRadius(16)
      .shadow(color: .black.opacity(0.03), radius: 2, y: -1)
    }
    .background(Color(.systemGroupedBackground))
    .ignoresSafeArea(edges: .bottom)
  }

  // Dummy send-function
  func sendMessage() {
    guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    let userMsg = Models.Message(role: Role.user, content: inputText, timestamp: Date())
    messages.append(userMsg)
    inputText = ""

    // Simulera AI-svar (dummy)
    Task {
      // let response = await chatService.sendMessage(userMsg.content)
      // DispatchQueue.main.async {
      //     let aiMsg = Message(role: .assistant, content: response, timestamp: Date())
      //     messages.append(aiMsg)
      // }
    }
  }
}

// MARK: - InputBar

private struct InputBar: View {
  @Binding var text: String
  var onSend: () -> Void
  @FocusState var isFocused: Bool

  var body: some View {
    HStack(spacing: 8) {
      // Ikoner vänster
      HStack(spacing: 6) {
        Button(
          action: {},
          label: {
            Image(systemName: "paperclip")
              .foregroundColor(.gray)
              .accessibilityLabel("Bifoga fil")
          })
        Button(
          action: {},
          label: {
            Image(systemName: "globe")
              .foregroundColor(.gray)
              .accessibilityLabel("Välj AI-modell")
          })
      }
      .padding(.leading, 2)

      // Textfält
      ZStack(alignment: .topLeading) {
        if text.isEmpty {
          Text("Skriv ett meddelande...")
            .foregroundColor(.secondary)
            .systemFont(Font.custom("SF Pro", size: 15))
        }
        TextEditor(text: $text)
          .frame(minHeight: 36, maxHeight: 120)
          .systemFont(Font.custom("SF Pro", size: 15))
          .focused($isFocused)
          .background(Color(NSColor.controlBackgroundColor))
          .cornerRadius(10)
          .accessibilityLabel("Meddelandefält")
      }
      .frame(maxWidth: .infinity)

      // Skicka-knapp
      Button(action: onSend) {
        Image(systemName: "arrow.up.circle.fill")
          .systemFont(Font.title2)
          .foregroundColor(text.isEmpty ? .gray : .accentColor)
          .accessibilityLabel("Skicka meddelande")
      }
      .disabled(text.isEmpty)
    }
    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    .background(Color(NSColor.windowBackgroundColor))
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.03), radius: 2, y: -1)
  }
}

// MARK: - Preview

struct RealtimeWorkspaceView_Previews: PreviewProvider {
  static var previews: some View {
    RealtimeWorkspaceView()
      .frame(width: 520, height: 600)
      .preferredColorScheme(.light)
    WorkspaceView()
      .frame(width: 520, height: 600)
      .preferredColorScheme(.dark)
  }
}
