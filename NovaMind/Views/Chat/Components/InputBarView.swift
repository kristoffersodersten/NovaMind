import SwiftUI

struct InputBarView: View {
    @Binding var text: String
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Type a message...", text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.body)
                .foregroundColor(.foregroundPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.novaGray.opacity(0.3))
                .cornerRadius(20)
                .lineLimit(1...5)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(text.isEmpty ? .foregroundSecondary : .glow)
            }
            .disabled(text.isEmpty)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundPrimary)
    }
}
