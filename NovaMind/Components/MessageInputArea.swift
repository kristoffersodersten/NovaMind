import SwiftUI


struct MessageInputArea: View {
    @Binding var inputText: String
    var onSendMessage: (String) -> Void
    var onHeightChange: (CGFloat) -> Void
    var onAttachFile: () -> Void
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Button(action: onAttachFile) {
                Image(systemName: "paperclip")
            }
            .buttonStyle(PlainButtonStyle())
            TextEditor(text: $inputText)
                .frame(minHeight: 30, maxHeight: 200)
                .padding(.horizontal, 4)
                .background(Color.white.opacity(0.1 as Double))
                .cornerRadius(CGFloat(8))
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(Font.title)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(CGFloat(12))
        .shadow(radius: 2)
    }
    private func sendMessage() {
        if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onSendMessage(inputText)
            inputText = ""
        }
    }
}
struct MessageInputArea_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputArea(
            inputText: .constant(""),
            onSendMessage: { _ in },
            onHeightChange: { _ in },
            onAttachFile: {}
        )
    }
}
