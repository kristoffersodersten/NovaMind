import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Sök projekt och trådar...", text: $text)
                .textFieldStyle(.plain)
                .systemFont(Font.subheadline)

            if !text.isEmpty {
                Button(action: { text = "" }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                })
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.black)
        .cornerRadius(CGFloat(10))
        .padding(.horizontal, 10)
        .padding(.top, 8)
    }
}
