import SwiftUI

/// A view that displays memory items for a specific memory type layer
struct MemoryLayerView: View {
    let memoryType: MemoryType
    let filteredItems: [MemoryItem]
    let onItemTap: (MemoryItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header with type indicator and count
            HStack {
                Circle()
                    .fill(memoryType.color)
                    .frame(width: 8, height: 8)

                Text(memoryType.displayName)
                    .systemFont(Font.system(size: 14, weight: .medium))
                    .foregroundColor(.foregroundPrimary)

                Spacer()

                Text("\(filteredItems.count)")
                    .systemFont(Font.system(size: 12))
                    .foregroundColor(.foregroundSecondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.separator.opacity(0.3))
                    .cornerRadius(8)
            }

            // Memory items
            ForEach(filteredItems) { item in
                MemoryItemView(item: item)
                    .onTapGesture { onItemTap(item) }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .novaBlack.opacity(0.05), radius: 2, y: 1)
    }
}
