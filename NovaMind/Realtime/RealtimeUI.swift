import SwiftUI


struct RealtimeUI: View {
  /// A SwiftUI view that displays a realtime feed of messages, updating every few seconds.
  @State private var realtimeMessages: [String] = []
  @State private var timer: Timer?

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Realtime Feed")
        .font(.title)
        .bold()
        .padding(.top)

      ScrollView {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(realtimeMessages.indices, id: \.self) { messageIndex in
            Text(realtimeMessages[messageIndex])
              .padding(8)
              .background(Color(NSColor.controlBackgroundColor))
              .cornerRadius(8)
              .transition(.move(edge: .bottom).combined(with: .opacity))
          }
        }
      }
      .animation(.easeInOut(duration: 0.3), value: realtimeMessages)

      Spacer()
    }
    .onAppear {
      timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
        Task { @MainActor in
          let timestamp = Self.timeFormatter.string(from: Date())
          realtimeMessages.append("Meddelande mottaget: \(timestamp)")
          realtimeMessages.append("Message received: \(timestamp)")
        }
      }
    }
    .onDisappear {
      timer?.invalidate()
      timer = nil
    }
  }

  private static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
  }()
}

struct RealtimeUI_Previews: PreviewProvider {
  static var previews: some View {
    RealtimeUI()
  }
}
