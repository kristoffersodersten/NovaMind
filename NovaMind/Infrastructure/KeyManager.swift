import Foundation


class KeyManager {
    static let shared = KeyManager()
    private var keys: [String] = ["ABC123", "DEF456", "GHI789"]
    var activeKey: String {
        keys[currentIndex]
    }
    private var currentIndex: Int = 0
    private var rotationTimer: Timer?
    private init() {
        startRotation()
    }
    private func startRotation() {
        rotationTimer = Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { _ in
            self.currentIndex = (self.currentIndex + 1) % self.keys.count
        }
    }
}
