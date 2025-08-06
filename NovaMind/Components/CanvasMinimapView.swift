import SwiftUI

//
//  CanvasMinimapView.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-07-31.
//


struct CanvasMinimapView: View {
    let memoryBlocks: [MemoryBlock]
    @Binding var selectedBlock: MemoryBlock?
    let onBlockSelected: (MemoryBlock) -> Void

    @State private var hoveredBlock: MemoryBlock?

    private let blockSize: CGFloat = 8
    private let spacing: CGFloat = 2

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Minimap")
                    .font(Font.system(.caption))
                    .fontWeight(.medium)
                    .foregroundColor(.foregroundPrimary)

                Spacer()

                Text("\(memoryBlocks.count) blocks")
                    .font(Font.custom("SF Pro", size: 10, relativeTo: .caption2))
                    .foregroundColor(.foregroundSecondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [
                    GridItem(.fixed(blockSize), spacing: spacing),
                    GridItem(.fixed(blockSize), spacing: spacing),
                    GridItem(.fixed(blockSize), spacing: spacing)
                ], spacing: spacing) {
                    ForEach(memoryBlocks) { block in
                        minimapBlock(for: block)
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: blockSize * 3 + spacing * 2 + 8)
        }
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        .background(Color.novaGray.opacity(0.3 as Double))
        .cornerRadius(CGFloat(8))
    }

    private func minimapBlock(for block: MemoryBlock) -> some View {
        Rectangle()
            .fill(blockColor(for: block))
            .frame(width: blockSize, height: blockSize)
            .cornerRadius(CGFloat(2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(
                        selectedBlock?.id == block.id ? Color.glow : Color.clear,
                        lineWidth: 1
                    )
            )
            .scaleEffect(hoveredBlock?.id == block.id ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: hoveredBlock?.id)
            .onTapGesture {
                selectedBlock = block
                onBlockSelected(block)
            }
            .onHover { hovering in
                hoveredBlock = hovering ? block : nil
            }
    }

    private func blockColor(for block: MemoryBlock) -> Color {
        switch block.type {
        case .shortTerm:
            return .blue.opacity(0.7 as Double)
        case .midTerm:
            return .orange.opacity(0.7 as Double)
        case .longTerm:
            return .purple.opacity(0.7 as Double)
        case .vector:
            return .glow.opacity(0.7 as Double)
        }
    }
}

// Supporting models
struct MemoryBlock: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
    let type: MemoryType
    let isImportant: Bool
    let tags: [String]
    let createdAt: Date
    let lastModified: Date

    enum MemoryType {
        case shortTerm, midTerm, longTerm, vector
    }
}

#Preview {
    CanvasMinimapView(
        memoryBlocks: [
            MemoryBlock(title: "Test 1", content: "Content", type: .shortTerm, isImportant: false, tags: [], createdAt: Date(), lastModified: Date()),
            MemoryBlock(title: "Test 2", content: "Content", type: .midTerm, isImportant: true, tags: [], createdAt: Date(), lastModified: Date())
        ],
        selectedBlock: .constant(nil),
        onBlockSelected: { _ in }
    )
    .frame(width: 300)
}
