import Combine
import SwiftUI


// Enkel NetworkMonitor för Swift 5.9 kompatibilitet
class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true

    init() {
        // Förenklad implementering - kan utökas senare med Network framework
    }
}

struct OfflineQueueView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var queueCount = 0

    var body: some View {
        VStack {
            if !networkMonitor.isConnected {
                HStack {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.red)
                    Text("Offline. Messages will be sent when back online. Queue: \(queueCount)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .onAppear(perform: updateQueueCount)
        .onReceive(NotificationCenter.default.publisher(for: .didUpdateQueue)) { _ in
            updateQueueCount()
        }
    }

    private func updateQueueCount() {
        queueCount = 0
    }
}

extension Notification.Name {
    static let didUpdateQueue = Notification.Name("didUpdateQueue")
}
