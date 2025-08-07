import SwiftUI

/// Sheet view for editing an existing memory item
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

                Toggle("Important", isOn: .constant(editedMemory.importance > 3))

                Spacer()
            }
            .padding(.padding(.all))
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
