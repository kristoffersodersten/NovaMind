import SwiftUI
import Foundation

struct EditProviderView: View {
    @Binding var provider: AIProviderConfig
    var onSave: () -> Void

    @State private var apiKeyText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Redigera leverantör")
                .font(Font.custom("SF Pro", size: 22).weight(.bold))

            TextField("Namn", text: $provider.name)
                .font(Font.custom("SF Pro", size: 15))
            TextField("API-nyckel", text: $apiKeyText)
                .font(Font.custom("SF Pro", size: 15))
                .onAppear {
                    apiKeyText = provider.apiKey
                }
                .onChange(of: apiKeyText) { newValue in
                    provider.apiKey = newValue
                }
            TextField("Endpoint", text: $provider.endpoint)
                .font(Font.custom("SF Pro", size: 15))

            HStack {
                Spacer()
                Button("Spara") {
                    onSave()
                }
                .buttonStyle(.borderedProminent)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: false)
                .font(Font.custom("SF Pro", size: 15))
            }
        }
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        .krilleHover()
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(NSColor.windowBackgroundColor).opacity(0.98 as Double))
                .shadow(color: Color.primary.opacity(0.12 as Double), radius: 12, x: 0, y: 4)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Redigera AI-leverantör panel")
    }
}
