import SwiftUI

/// A view that displays an individual memory item
struct MemoryItemView: View {
    let item: MemoryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Title row with importance indicator
            HStack {
                Text(item.title)
                    .systemFont(Font.system(size: 12, weight: .medium))
                    .foregroundColor(.foregroundPrimary)
                    .lineLimit(1)

                Spacer()

                if item.importance > 3 {
                    Image(systemName: "star.fill")
                        .foregroundColor(.highlightAction)
                        .systemFont(Font.system(size: 10))
                }
            }

            // Content preview
            Text(item.content)
                .systemFont(Font.system(size: 11))
                .foregroundColor(.foregroundSecondary)
                .lineLimit(2)

            // Tags (up to 3)
            if !item.tags.isEmpty {
                HStack {
                    ForEach(item.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .systemFont(Font.system(size: 9))
                            .foregroundColor(.foregroundSecondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.separator.opacity(0.3 as Double))
                            .cornerRadius(CGFloat(4))
                    }
                    Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color.backgroundPrimary)
        .cornerRadius(CGFloat(8))
        .krilleHover()
    }
}
