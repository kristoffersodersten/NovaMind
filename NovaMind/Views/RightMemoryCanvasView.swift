import SwiftUI

//
//  RightMemoryCanvasView.swift
//  NovaMind
//
//  Created by Kristoffer Södersten on 2025-01-20.
//


struct RightMemoryCanvasView: View {
    @State private var memoryItems: [MemoryItem] = [
        MemoryItem(
            title: "NovaMind Architecture",
            content: "Clean Architecture + TCA implementation",
            memoryType: .longTerm
        ),
        MemoryItem(
            title: "Current Task",
            content: "Optimize main layout with modular panel states",
            memoryType: .shortTerm
        ),
        MemoryItem(
            title: "Design System",
            content: "KrilleCore2030 minimalist approach with parallax effects",
            memoryType: .midTerm
        )
    ]

    @State private var selectedMemory: MemoryItem?
    @State private var showAddSheet = false
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header with search and controls
            headerView
                .padding(.horizontal, 16)
                .padding(.top, 16)

            // Memory layers organized by type
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(MemoryType.allCases, id: \.self) { memoryType in
                        memoryLayerView(for: memoryType)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
            }

            Spacer()
        }
        .background(Color.backgroundPrimary.opacity(0.95))
        .cornerRadius(16)
        .shadow(color: .novaBlack.opacity(0.1), radius: 8, x: 0, y: 2)
        .sheet(isPresented: $showAddSheet) {
            AddMemorySheetView { title, content, type in
                let newItem = MemoryItem(title: title, content: content, memoryType: type)
                memoryItems.append(newItem)
            }
        }
        .sheet(item: $selectedMemory) { memory in
            MemoryDetailSheetView(memory: memory) { updatedMemory in
                if let index = memoryItems.firstIndex(where: { $0.id == updatedMemory.id }) {
                    memoryItems[index] = updatedMemory
                }
            }
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Memory Canvas")
                    .font(.custom("SF Pro", size: 18).weight(.semibold))
                    .foregroundColor(.foregroundPrimary)

                Spacer()

                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.glow)
                        .font(.title2)
                        .glowEffect(active: true)
                }
                .microSpringButton()
            }

            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.foregroundSecondary)
                    .font(.system(size: 14))

                TextField("Search memories...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.custom("SF Pro", size: 14))
                    .foregroundColor(.foregroundPrimary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.separator.opacity(0.3))
            .cornerRadius(8)
        }
    }

    // MARK: - Memory Layer View
    private func memoryLayerView(for memoryType: MemoryType) -> some View {
        let filteredItems = memoryItems.filter {
            $0.memoryType == memoryType && (searchText.isEmpty ||
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText))
        }

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(memoryType.color)
                    .frame(width: 8, height: 8)

                Text(memoryType.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.foregroundPrimary)

                Spacer()

                Text("\(filteredItems.count)")
                    .font(.system(size: 12))
                    .foregroundColor(.foregroundSecondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.separator.opacity(0.3))
                    .cornerRadius(8)
            }

            ForEach(filteredItems) { item in
                memoryItemView(item: item)
                    .onTapGesture { selectedMemory = item }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .novaBlack.opacity(0.05), radius: 2, y: 1)
    }

    // MARK: - Memory Item View
    private func memoryItemView(item: MemoryItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(item.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.foregroundPrimary)
                    .lineLimit(1)

                Spacer()

                if item.importance > 3 {
                    Image(systemName: "star.fill")
                        .foregroundColor(.highlightAction)
                        .font(.system(size: 10))
                }
            }

            Text(item.content)
                .font(.system(size: 11))
                .foregroundColor(.foregroundSecondary)
                .lineLimit(2)

            if !item.tags.isEmpty {
                HStack {
                    ForEach(item.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 9))
                            .foregroundColor(.foregroundSecondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.separator.opacity(0.3))
                            .cornerRadius(4)
                    }
                    Spacer()
                }
            }
        }
        .padding(8)
        .background(Color.backgroundPrimary)
        .cornerRadius(8)
        .krilleHover()
    }
}

// MARK: - Supporting Views

struct AddMemorySheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var selectedType: MemoryType = .shortTerm

    let onSave: (String, String, MemoryType) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Memory Type", selection: $selectedType) {
                    ForEach(MemoryType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.separator, lineWidth: 1)
                    )

                Spacer()
            }
            .padding()
            .navigationTitle("New Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(title.isEmpty ? "Untitled" : title, content, selectedType)
                        dismiss()
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
    }
}

struct MemoryDetailSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editedMemory: MemoryItem

    let onSave: (MemoryItem) -> Void

    init(memory: MemoryItem, onSave: @escaping (MemoryItem) -> Void) {
        self._editedMemory = State(initialValue: memory)
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Title", text: $editedMemory.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Memory Type", selection: $editedMemory.memoryType) {
                    ForEach(MemoryType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextEditor(text: $editedMemory.content)
                    .frame(minHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.separator, lineWidth: 1)
                    )

                Toggle("Important", isOn: .constant(item.importance > 3))

                Spacer()
            }
            .padding()
            .navigationTitle("Edit Memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        editedMemory.updatedAt = Date()
                        onSave(editedMemory)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - View Modifiers
extension View {
    func microSpringButton() -> some View {
        self.scaleEffect(1.0)
            .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: UUID())
    }
    
    func glowEffect(active: Bool) -> some View {
        self.shadow(color: active ? .blue : .clear, radius: 4)
    }
    
    func krilleHover() -> some View {
        self.onHover { _ in
            // Hover effect implementation
        }
    }
}

// MARK: - Memory Models
struct MemoryItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    var memoryType: MemoryType
    var importance: Int = 1
    var isImportant: Bool { importance > 3 }
    var tags: [String] = []
    var createdAt = Date()
    var updatedAt = Date()
}

enum MemoryType: String, CaseIterable, Codable {
    case shortTerm = "short"
    case midTerm = "mid"
    case longTerm = "long"
    
    var displayName: String {
        switch self {
        case .shortTerm: return "Short Term"
        case .midTerm: return "Mid Term"
        case .longTerm: return "Long Term"
        }
    }
    
    var color: Color {
        switch self {
        case .shortTerm: return .green
        case .midTerm: return .orange
        case .longTerm: return .blue
        }
    }
    
    var iconName: String {
        switch self {
        case .shortTerm: return "clock"
        case .midTerm: return "calendar"
        case .longTerm: return "brain.head.profile"
        }
    }
}

// MARK: - Preview
#Preview {
    RightMemoryCanvasView()
        .frame(width: 320, height: 600)
        .preferredColorScheme(.dark)
}
