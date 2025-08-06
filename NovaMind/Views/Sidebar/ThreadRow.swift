import SwiftUI

struct ThreadRow: View {
    let thread: ChatThread

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "message")
                .font(.system(size: 12))
                .foregroundColor(.glow)

            VStack(alignment: .leading, spacing: 2) {
                Text(thread.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.foregroundPrimary)
                    .lineLimit(1)

                if !thread.tags.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(thread.tags.prefix(2), id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 8))
                                .foregroundColor(.foregroundSecondary)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.novaBlack.opacity(0.5))
                                .cornerRadius(4)
                        }

                        if thread.isImportant {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.glow)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.3))
        .cornerRadius(6)
        .padding(.horizontal, 8)
    }
}
