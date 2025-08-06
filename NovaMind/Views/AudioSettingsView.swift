import SwiftUI

struct AudioSettingsView: View {
    var body: some View {
        Form {
            Section("Ljudinställningar") {
                Toggle("Aktivera ljud", isOn: .constant(true))
                Slider(value: .constant(0.5), in: 0...1, step: 0.01) {
                    Text("Volym")
                }
                Text("Justera volymen för ljudnotiser och feedback.")
                    .systemFont(Font.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
    }
}
