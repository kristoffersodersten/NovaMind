import SwiftUI


struct ActionButton: View {
    let title: String
    let systemImage: String?
    let action: () -> Void
    let onLongPress: (() -> Void)?

    init(title: String, systemImage: String? = nil, action: @escaping () -> Void, onLongPress: (() -> Void)? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
        self.onLongPress = onLongPress
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(CGFloat(8))
        }
        .onLongPressGesture(perform: onLongPress ?? {})
    }
}
