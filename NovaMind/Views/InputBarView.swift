import SwiftUI

struct InputBarView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let onSend: () -> Void

    @State private var isHovering = false
    @State private var isRecording = false
    @State private var hasAttachments = false

    var body: some View {
        VStack(spacing: 8) {
            // Input text area
            HStack(spacing: 12) {
                TextEditor(text: $text)
                    .systemFont(Font.custom("SF Pro", size: 16))
                    .focused($isFocused)
                    .frame(minHeight: 44, maxHeight: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.backgroundPrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.glow : Color.separator, lineWidth: 1)
                    )
                    .krilleHover()

                // Send button
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .systemFont(Font.title2)
                        .foregroundColor(text.isEmpty ? .foregroundSecondary : .glow)
                        .glowEffect(active: !text.isEmpty)
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .microSpringButton()
            }

            // Action buttons row
            HStack(spacing: 16) {
                ActionButton(
                    systemName: "paperclip",
                    isActive: hasAttachments,
                    action: { hasAttachments.toggle() }
                )

                ActionButton(
                    systemName: "mic.fill",
                    isActive: isRecording,
                    pulse: isRecording,
                    action: { isRecording.toggle() }
                )

                ActionButton(
                    systemName: "camera",
                    isActive: false,
                    action: { /* Screenshot action */ }
                )

                ActionButton(
                    systemName: "globe",
                    isActive: false,
                    action: { /* Web search action */ }
                )

                Spacer()

                Text("\(text.count)/4000")
                    .systemFont(Font.caption)
                    .foregroundColor(.foregroundSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundPrimary.opacity(0.98))
        .shadow(color: .novaBlack.opacity(0.06), radius: 8, x: 0, y: -2)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3)) {
                isHovering = hovering
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isFocused)
    }
}

// MARK: - Color Extensions  
// Color definitions moved to ColorExtensions.swift to avoid duplicates
