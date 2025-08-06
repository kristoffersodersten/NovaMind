import SwiftUI


/// Central workspace view – NovaMindMacOS
/// Visar chatthistorik, InputBar och stöd för framtida multi-AI-svar.
/// All logik är mock/dummy tills backend kopplas in.
struct RealtimeWorkspaceView: View {
  @State private var messages: [Message] = [
    Message(
      role: .assistant,
      content: "Hej! Hur kan jag hjälpa dig idag?",
      timestamp: Date().addingTimeInterval(-300)
    ),
    Message(
      role: .user,
      content: "Visa example på NovaMind-layout.",
      timestamp: Date().addingTimeInterval(-250)
    ),
    Message(
      role: .assistant,
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
          .font(.title2)
          .fontWeight(.semibold)
          .foregroundStyle(.primary)
        Spacer()
        // Plats för framtida multi-AI-ikoner eller status
        HStack(spacing: 8) {
          Image(systemName: "brain.head.profile")
            .foregroundStyle(.accentColor)
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
        .background(Color(.systemBackground))
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
    let userMsg = Message(role: .user, content: inputText, timestamp: Date())
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

struct ChatBubble: View {
  let message: Message

  var isUser: Bool {
    message.role == .user
  }

  var body: some View {
    HStack(alignment: .bottom, spacing: 8) {
      if isUser { Spacer() }
      VStack(alignment: isUser ? .trailing : .leading, spacing: 2) {
        Text(message.content)
          .padding(.vertical, 8)
          .padding(.horizontal, 14)
          .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
              .fill(isUser ? Color.accentColor.opacity(0.18) : Color.secondary.opacity(0.09))
              .shadow(color: .black.opacity(0.03), radius: 1, y: 1)
          )
          .foregroundColor(.primary)
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(isUser ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
          )
        Text(message.timestamp, style: .time)
          .font(.caption2)
          .foregroundColor(.gray)
          .padding(.top, 2)
      }
      if !isUser { Spacer() }
    }
    .padding(.horizontal, 2)
    .transition(.move(edge: isUser ? .trailing : .leading).combined(with: .opacity))
    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: message.id)
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
            .font(.custom("SF Pro", size: 15))
        }
        TextEditor(text: $text)
          .frame(minHeight: 36, maxHeight: 120)
          .font(.custom("SF Pro", size: 15))
          .focused($isFocused)
          .background(Color(.secondarySystemBackground))
          .cornerRadius(10)
          .accessibilityLabel("Meddelandefält")
      }
      .frame(maxWidth: .infinity)

      // Skicka-knapp
      Button(action: onSend) {
        Image(systemName: "arrow.up.circle.fill")
          .font(.title2)
          .foregroundColor(text.isEmpty ? .gray : .accentColor)
          .accessibilityLabel("Skicka meddelande")
      }
      .disabled(text.isEmpty)
    }
    .padding(8)
    .background(Color(.systemGroupedBackground))
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
