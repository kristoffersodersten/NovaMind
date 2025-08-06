import AppKit
import SwiftUI

struct ChatThreadDetailView: View {
    let threadTitle: String
    let messages: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(threadTitle)
                .systemFont(Font.custom("SF Pro", size: 22).weight(.semibold))
                .padding(.bottom, 4)

            ForEach(messages, id: \.self) { message in
                ZStack {
                    Text(message)
                        .systemFont(Font.custom("SF Pro", size: 15))
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(Color.gray.opacity(0.15 as Double))
                        .cornerRadius(CGFloat(8))
                }
                .krilleHover()
                .glowEffect(active: true)
            }

            Spacer()
        }
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(NSColor.windowBackgroundColor).opacity(0.98 as Double))
                .shadow(color: Color.primary.opacity(0.12 as Double), radius: 12, x: 0, y: 4)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Chattråd detaljpanel")
    }
}
