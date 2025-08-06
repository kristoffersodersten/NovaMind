import SwiftUI

struct ShapeExampleView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("SwiftUI Shape Examples")
                .font(.title)
                .padding()

            SwiftUI.RoundedRectangle(cornerRadius: 16)
                .fill(SwiftUI.Color.red)
                .frame(width: 200, height: 100)
                .shadow(color: SwiftUI.Color.red.opacity(0.35), radius: 12, x: 0, y: 0)

            SwiftUI.Capsule()
                .fill(SwiftUI.Color.blue)
                .frame(width: 200, height: 60)
                .shadow(color: SwiftUI.Color.blue.opacity(0.35), radius: 12, x: 0, y: 0)

            SwiftUI.Rectangle()
                .fill(SwiftUI.Color.green)
                .frame(width: 200, height: 60)
                .shadow(color: SwiftUI.Color.green.opacity(0.35), radius: 12, x: 0, y: 0)
        }
        .padding()
        .background(SwiftUI.Color.white)
    }
}

struct ShapeExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeExampleView()
            .frame(width: 300, height: 400)
    }
}
