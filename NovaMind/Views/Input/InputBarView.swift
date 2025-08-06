import SwiftUI


struct InputBarView: View {
    @Binding var text: String
    @State private var isHandsfreeActive = false
    @State private var isMicActive = false
    @State private var editorHeight: CGFloat = 40
    @State private var isDragging = false
    @State private var isWebSearchActive: Bool = false
    @State private var isNoiseFilterActive: Bool = false
    @FocusState private var isInputFocused: Bool

    // KrilleCore2030 measurements
    private let maxInputHeight: CGFloat = 180
    private let iconSize: CGFloat = 24

    // Initialize with binding or default
    init(text: Binding<String> = .constant("")) {
        self._text = text
    }

    var body: some View {
        VStack(spacing: 8) {
            // Själva inputfältet med justerbar höjd
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Skriv ditt meddelande...")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .padding(.top, 12)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $text)
                    .font(.body)
                    .frame(height: editorHeight)
                    .padding(12)
                    .background(Color.novaBlack)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.glow.opacity(0.2), lineWidth: 1)
                            .shadow(color: .glow.opacity(0.1), radius: 3)
                    )
                    .focused($isInputFocused)
                    .onChange(of: text) { _ in
                        updateEditorHeight()
                    }
            }

            // Drag handle för höjdjustering
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 4)
                .cornerRadius(2)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            let newHeight = editorHeight + value.translation.height
                            editorHeight = max(40, min(180, newHeight))
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                )
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isDragging)

            // Ikonfält med glowstatus
            HStack(spacing: 20) {
                IconToggle(icon: "paperclip", isActive: false) {
                    handleFileAttachment()
                }

                IconToggle(icon: "globe", isActive: isWebSearchActive) {
                    withAnimation(.spring()) {
                        isWebSearchActive.toggle()
                    }
                    triggerHapticFeedback()
                }

                IconToggle(icon: "mic.fill", isActive: isMicActive) {
                    withAnimation(.spring()) {
                        isMicActive.toggle()
                    }
                    triggerHapticFeedback()
                }

                IconToggle(icon: "waveform.circle", isActive: isHandsfreeActive) {
                    withAnimation(.spring()) {
                        isHandsfreeActive.toggle()
                    }
                    triggerHapticFeedback()
                }

                Spacer()

                // Send Button
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(canSend ? .glow : .novaGray)
                }
                .disabled(!canSend)
                .scaleEffect(canSend ? 1.0 : 0.8)
                .animation(.easeInOut(duration: 0.2), value: canSend)
                .keyboardShortcut(.return, modifiers: [.command])
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
        .background(Color.novaGray)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .onAppear {
            isInputFocused = true
        }
    }

    // MARK: - Computed Properties
    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Actions
    private func sendMessage() {
        guard canSend else { return }

        // Send message logic here
        print("Sending message: \(text)")

        // Clear input
        withAnimation(.easeInOut(duration: 0.2)) {
            text = ""
        }
    }

    private func handleFileAttachment() {
        // File picker logic
        print("Opening file attachment")
    }

    private func updateEditorHeight() {
        let lineHeight = UIFont.preferredFont(forTextStyle: .body).lineHeight
        let lineCount = text.components(separatedBy: .newlines).count
        let newHeight = max(40, min(180, CGFloat(lineCount) * lineHeight + 24))

        withAnimation(.easeInOut(duration: 0.2)) {
            editorHeight = newHeight
        }
    }

    private func triggerHapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

struct IconToggle: View {
    var icon: String
    var isActive: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.glow.opacity(0.2) : Color.clear)
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isActive ? .glow : .gray)
                    .shadow(color: isActive ? .glow.opacity(0.4) : .clear, radius: 6)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isActive ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
    }
}

// MARK: - Visual Effect Modifiers

struct GlowEffectModifier: ViewModifier {
    let active: Bool
    let color: Color

    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .blur(radius: active ? 4 : 0)
                    .opacity(active ? 0.6 : 0)
                    .foregroundColor(color)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: active)
            )
    }
}

struct PulseEffectModifier: ViewModifier {
    let active: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(active ? 1.05 : 1.0)
            .animation(
                active ?
                    .easeInOut(duration: 0.8).repeatForever(autoreverses: true) :
                    .easeInOut(duration: 0.2),
                value: active
            )
    }
}

extension View {
    func glowEffect(active: Bool, color: Color = .glow) -> some View {
        self.modifier(GlowEffectModifier(active: active, color: color))
    }

    func pulseEffect(active: Bool) -> some View {
        self.modifier(PulseEffectModifier(active: active))
    }
}

#Preview {
    InputBarView()
        .padding()
        .background(Color.novaBlack)
}
