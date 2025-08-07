import SwiftUI

struct ShapeExampleView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("SwiftUI Shape Examples")
                .font(.title)
                .padding(.all, 16)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color.red)
                .frame(width: 200, height: 100)
                .shadow(color: Color.red.opacity(0.35), radius: 12, x: 0, y: 0)

            Capsule()
                .fill(Color.blue)
                .frame(width: 200, height: 60)
                .shadow(color: Color.blue.opacity(0.35), radius: 12, x: 0, y: 0)

            Rectangle()
                .fill(Color.green)
                .frame(width: 200, height: 60)
                .shadow(color: Color.green.opacity(0.35), radius: 12, x: 0, y: 0)
        }
        .padding(.all, 24)
        .background(Color.white)
    }
}

struct ShapeExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeExampleView()
            .frame(width: 300, height: 400)
    }
}
