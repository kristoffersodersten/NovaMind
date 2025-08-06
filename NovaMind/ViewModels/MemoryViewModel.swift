import Foundation
import SwiftUI

/// ViewModel for managing memory canvas state and logic
@MainActor
final class MemoryViewModel: ObservableObject {
    @Published var memoryItems: [MemoryItem] = []
    @Published var searchText: String = ""
    @Published var selectedMemory: MemoryItem?
    @Published var showAddSheet: Bool = false
    
    init() {
        loadSampleMemories()
    }
    
    /// Adds a new memory item
    func addMemory(title: String, content: String, type: MemoryType) {
        let newItem = MemoryItem(title: title, content: content, memoryType: type)
        memoryItems.append(newItem)
    }
    
    /// Updates an existing memory item
    func updateMemory(_ updatedMemory: MemoryItem) {
        if let index = memoryItems.firstIndex(where: { $0.id == updatedMemory.id }) {
            memoryItems[index] = updatedMemory
        }
    }
    
    /// Returns filtered memory items for a specific type
    func filteredItems(for memoryType: MemoryType) -> [MemoryItem] {
        return memoryItems.filter {
            $0.memoryType == memoryType && (searchText.isEmpty ||
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    /// Loads sample memories for development
    private func loadSampleMemories() {
        memoryItems = [
            MemoryItem(
                title: "NovaMind Architecture",
                content: "Clean Architecture + TCA implementation",
                memoryType: .longTerm
            ),
            MemoryItem(
                title: "Current Task",
                content: "Validate project structure and complete missing components",
                memoryType: .shortTerm
            ),
            MemoryItem(
                title: "Design System",
                content: "KrilleCore2030 minimalist approach with parallax effects",
                memoryType: .midTerm
            )
        ]
    }
}
