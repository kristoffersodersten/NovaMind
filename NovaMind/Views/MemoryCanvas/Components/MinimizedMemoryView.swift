import SwiftUI

/// Minimized view showing memory type indicators
struct MinimizedMemoryView: View {
    var body: some View {
        VStack(spacing: 8) {
            ForEach(MemoryType.allCases, id: \.self) { memoryType in
                Circle()
                    .fill(memoryType.color.opacity(0.7 as Double))
                    .frame(width: CGFloat(16), height: CGFloat(16))
                    .overlay(
                        Image(systemName: memoryType.iconName)
                            .systemFont(Font.system(size: 8))
                            .foregroundColor(memoryType.color)
                    )
            }
        }
        .padding(.top, 16)
    }
}
