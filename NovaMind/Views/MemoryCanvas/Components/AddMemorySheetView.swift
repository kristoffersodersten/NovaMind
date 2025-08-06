import SwiftUI

/// Sheet view for adding a new memory item
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
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
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
