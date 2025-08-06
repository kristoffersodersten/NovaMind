import Foundation
import Network


class OfflineMessageQueue {
    static let shared = OfflineMessageQueue()
    private var queuedMessages: [Data] = []
    private let fileURL: URL

    private init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documentsDirectory.appendingPathComponent("offline_queue.json")
        loadQueue()
    }

    func enqueue(message: Data) {
        queuedMessages.append(message)
        saveQueue()
    }

    func dequeue() -> Data? {
        guard !queuedMessages.isEmpty else { return nil }
        let message = queuedMessages.removeFirst()
        saveQueue()
        return message
    }

    func peek() -> Data? {
        return queuedMessages.first
    }

    func clear() {
        queuedMessages.removeAll()
        saveQueue()
    }

    private func saveQueue() {
        do {
            let data = try JSONEncoder().encode(queuedMessages)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save offline queue: \(error)")
        }
    }

    private func loadQueue() {
        do {
            let data = try Data(contentsOf: fileURL)
            queuedMessages = try JSONDecoder().decode([Data].self, from: data)
        } catch {
            print("Failed to load offline queue: \(error)")
        }
    }
}
