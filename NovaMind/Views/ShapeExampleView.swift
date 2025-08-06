import SwiftUI

struct ShapeExampleView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("SwiftUI Shape Examples")
                .systemFont(Font.title)
                .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))

            SwiftUI.RoundedRectangle(cornerRadius: 16)
                .fill(SwiftUI.Color.red)
                .frame(width: CGFloat(200), height: CGFloat(100))
                .shadow(color: SwiftUI.Color.red.opacity(0.35 as Double), radius: 12, x: 0, y: 0)

            SwiftUI.Capsule()
                .fill(SwiftUI.Color.blue)
                .frame(width: CGFloat(200), height: CGFloat(60))
                .shadow(color: SwiftUI.Color.blue.opacity(0.35 as Double), radius: 12, x: 0, y: 0)

            SwiftUI.Rectangle()
                .fill(SwiftUI.Color.green)
                .frame(width: CGFloat(200), height: CGFloat(60))
                .shadow(color: SwiftUI.Color.green.opacity(0.35 as Double), radius: 12, x: 0, y: 0)
        }
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        .background(SwiftUI.Color.white)
    }
}

struct ShapeExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeExampleView()
            .frame(width: CGFloat(300), height: CGFloat(400))
    }
}
