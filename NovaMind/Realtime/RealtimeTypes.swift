import Foundation

/// Status för leverans av meddelanden i realtid.
public enum DeliveryStatus: String, Codable, CaseIterable {
    case pending
    case delivered
    case failed
}

/// Prioritet på meddelanden i realtid.
public enum MessagePriority: String, Codable, CaseIterable {
    case low
    case normal
    case high
}
