import SwiftUI

/// Main memory canvas view for the right panel using MVVM architecture
struct RightPanelMemoryCanvasView: View {
    @Binding var isLocked: Bool
    @Binding var isHovered: Bool
    @StateObject private var viewModel = MemoryViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Header (shown when locked or hovered)
            if isLocked || isHovered {
                MemoryCanvasHeaderView(
                    searchText: $viewModel.searchText,
                    onAddTapped: { viewModel.showAddSheet = true }
                )
                .transition(.opacity.combined(with: .scale))
            }

            // Memory layers
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(MemoryType.allCases, id: \.self) { memoryType in
                        MemoryLayerView(
                            memoryType: memoryType,
                            filteredItems: viewModel.filteredItems(for: memoryType),
                            onItemTap: { item in
                                viewModel.selectedMemory = item
                            }
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, isLocked || isHovered ? 16 : 8)
            }

            // Minimized view (shown when not locked and not hovered)
            if !isLocked && !isHovered {
                MinimizedMemoryView()
                    .transition(.opacity)
            }

            Spacer()
        }
        .background(Color.backgroundPrimary.opacity(0.95 as Double))
        .cornerRadius(isLocked || isHovered ? 16 : 8)
        .shadow(color: .novaBlack.opacity(0.1 as Double), radius: 8, x: 0, y: 2)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isLocked)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isHovered)
        .sheet(isPresented: $viewModel.showAddSheet) {
            AddMemorySheetView { title, content, type in
                viewModel.addMemory(title: title, content: content, type: type)
            }
        }
        .sheet(item: $viewModel.selectedMemory) { memory in
            MemoryDetailSheetView(memory: memory) { updatedMemory in
                viewModel.updateMemory(updatedMemory)
            }
        }
    }
}
