import SwiftUI

struct ThreadRow: View {
    let thread: ChatThread

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "message")
                .font(Font.system(size: 12))
                .foregroundColor(.glow)

            VStack(alignment: .leading, spacing: 2) {
                Text(thread.title)
                    .font(Font.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.foregroundPrimary)
                    .lineLimit(1)

                if !thread.tags.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(thread.tags.prefix(2), id: \.self) { tag in
                            Text(tag)
                                .font(Font.system(size: 8))
                                .foregroundColor(.foregroundSecondary)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.novaBlack.opacity(0.5 as Double))
                                .cornerRadius(CGFloat(4))
                        }

                        if thread.isImportant {
                            Image(systemName: "star.fill")
                                .font(Font.system(size: 8))
                                .foregroundColor(.glow)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.3 as Double))
        .cornerRadius(CGFloat(6))
        .padding(.horizontal, 8)
    }
}
