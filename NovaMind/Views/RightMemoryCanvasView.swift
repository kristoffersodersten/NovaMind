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
                    .systemFont(Font.system(.title2))
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    showingAddMemorySheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .systemFont(Font.system(.title2))
                        .foregroundColor(.accentColor)
                }
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
                            MemoryItemView(memory: memory)
                                .onTapGesture {
                                    selectedMemory = memory
                                    showingMemoryDetailSheet = true
                                }
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
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
        type: .concept,
        isImportant: true,
        tags: ["SwiftUI", "Navigation"],
        createdAt: Date().addingTimeInterval(-86400),
        lastModified: Date()
    ),
    MemoryItem(
        id: UUID(),
        title: "AI Integration Notes", 
        content: "Notes on integrating AI capabilities into the app",
        type: .note,
        isImportant: false,
        tags: ["AI", "Integration"],
        createdAt: Date().addingTimeInterval(-3600),
        lastModified: Date()
    )
]

// MARK: - Preview
#Preview {
    RightMemoryCanvasView()
        .frame(width: CGFloat(400), height: CGFloat(600))
}
