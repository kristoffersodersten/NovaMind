import Foundation


public enum OfflineMessageStatus: String, Codable {
  case pending
  case sending
  case failed
  case sent
}

public struct QueuedMessage: Codable, Identifiable {
  public let id: UUID
  public let payload: Data
  public let createdAt: Date
  public var status: OfflineMessageStatus

  public init(
    id: UUID = UUID(), payload: Data, createdAt: Date = Date(),
    status: OfflineMessageStatus = .pending
  ) {
    self.id = id
    self.payload = payload
    self.createdAt = createdAt
    self.status = status
  }
}

public struct OfflineQueueItem: Identifiable, Codable {
  public let id: UUID
  public let description: String
  public var status: OfflineMessageStatus

  public init(id: UUID = UUID(), description: String, status: OfflineMessageStatus = .pending) {
    self.id = id
    self.description = description
    self.status = status
  }
}
