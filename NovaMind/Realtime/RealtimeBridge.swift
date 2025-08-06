import Combine
import Network
import SwiftUI


@MainActor
final class RealtimeBridge: ObservableObject {
  @Published var isConnected: Bool = false
  @Published var lastReceived: Date?
  private var timer: Timer?

  func connect() {
    isConnected = true
    lastReceived = Date()
    startPinging()
  }

  func disconnect() {
    isConnected = false
    stopPinging()
  }

  private func startPinging() {
    timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
      Task { @MainActor in
        self?.ping()
      }
    }
  }

  private func stopPinging() {
    timer?.invalidate()
    timer = nil
  }

  private func ping() {
    // Simulera en ping och uppdatera senast mottagna tiden
    lastReceived = Date()
    print("[RealtimeBridge] Ping")
  }
}
