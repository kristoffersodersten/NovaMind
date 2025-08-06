//
//  EmergingSignal.swift
//  NovaMind
//
//  Created by Assistant on 2025-01-11.
//

import Foundation

/// Represents an emerging signal detected by the resonance radar system
struct EmergingSignal {
    let signalType: String
    let strength: Double
    let frequency: Double
    let timestamp: Date
    let confidence: Double
    let metadata: [String: Any]
    
    init(signalType: String, 
         strength: Double, 
         frequency: Double, 
         timestamp: Date = Date(), 
         confidence: Double = 1.0, 
         metadata: [String: Any] = [:]) {
        self.signalType = signalType
        self.strength = strength
        self.frequency = frequency
        self.timestamp = timestamp
        self.confidence = confidence
        self.metadata = metadata
    }
}

extension EmergingSignal: Identifiable {
    var id: String {
        "\(signalType)_\(timestamp.timeIntervalSince1970)"
    }
}

extension EmergingSignal: Equatable {
    static func == (lhs: EmergingSignal, rhs: EmergingSignal) -> Bool {
        lhs.id == rhs.id
    }
}
