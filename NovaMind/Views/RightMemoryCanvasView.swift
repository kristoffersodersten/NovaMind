//
//  RightMemoryCanvasView.swift
//  NovaMind
//
//  Created by Assistant on 2025-01-11.
//

import SwiftUI

struct RightMemoryCanvasView: View {
    @State private var showingAddMemorySheet = false
    @State private var showingMemoryDetailSheet = false
    @State private var selectedMemory: MemoryItem?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header med add-knapp
            HStack {
                Text("Minneskarta")
                    .font(Font.system(.title2))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    showingAddMemorySheet = true
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(Font.system(.title2))
                        .foregroundColor(.accentColor)
                })
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.clear)
            
            // Canvas område
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical]) {
                    LazyVStack(spacing: 12) {
                        ForEach(sampleMemoryItems) { memory in
                            MemoryItemView(item: memory)
                                .onTapGesture {
                                    selectedMemory = memory
                                    showingMemoryDetailSheet = true
                                }
                        }
                    }
                    .padding(20)
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                }
            }
        }
        .background(Color.clear)
        .sheet(isPresented: $showingAddMemorySheet) {
            AddMemorySheetView()
                .frame(minWidth: 500, minHeight: 400)
        }
        .sheet(isPresented: $showingMemoryDetailSheet) {
            if let memory = selectedMemory {
                MemoryDetailSheetView(memory: memory)
                    .frame(minWidth: 600, minHeight: 500)
            }
        }
    }
}

// MARK: - Sample Data
let sampleMemoryItems: [MemoryItem] = [
    MemoryItem(
        id: UUID(),
        title: "SwiftUI Navigation",
        content: "Best practices for SwiftUI navigation patterns",
        type: .conceptual, // Replace with a valid case of MemoryType, e.g., .conceptual
        isImportant: 1,    // Assuming isImportant expects Int (1 for true, 0 for false)
        tags: ["SwiftUI", "Navigation"],
        createdAt: Date().addingTimeInterval(-86400)
    ),
    MemoryItem(
        id: UUID(),
        title: "AI Integration Notes",
        content: "Notes on integrating AI capabilities into the app",
        type: .noteType,   // Replace with a valid case of MemoryType, e.g., .noteType
        isImportant: 0,    // Assuming isImportant expects Int (1 for true, 0 for false)
        tags: ["AI", "Integration"],
        createdAt: Date().addingTimeInterval(-3600)
    )
]

// MARK: - Preview
#Preview {
    RightMemoryCanvasView()
        .frame(width: 400, height: 600)
}
