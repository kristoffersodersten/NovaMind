import SwiftUI

// MARK: - Contrast Testing Types
struct ContrastTest {
    let foreground: Color
    let background: Color
    let ratio: Double
    let wcagLevel: WCAGLevel
    let description: String
    
    enum WCAGLevel: String, CaseIterable {
        case fail = "Fail"
        case aa = "AA"
        case aaa = "AAA"
        
        var color: Color {
            switch self {
            case .fail: return .red
            case .aa: return .orange  
            case .aaa: return .green
            }
        }
    }
    
    // Predefined contrast tests
    static let tests: [ContrastTest] = [
        ContrastTest(
            foreground: .black,
            background: .white,
            ratio: 21.0,
            wcagLevel: .aaa,
            description: "Black on White"
        ),
        ContrastTest(
            foreground: .white,
            background: .black,
            ratio: 21.0,
            wcagLevel: .aaa,
            description: "White on Black"
        ),
        ContrastTest(
            foreground: .blue,
            background: .white,
            ratio: 8.6,
            wcagLevel: .aa,
            description: "Blue on White"
        )
    ]
}

// MARK: - Gradient Presets
struct GradientPreset {
    let name: String
    let colors: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    // Predefined gradient presets
    static let presets: [GradientPreset] = [
        GradientPreset(
            name: "Sunset",
            colors: [.orange, .red, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            name: "Ocean",
            colors: [.blue, .cyan, .green],
            startPoint: .top,
            endPoint: .bottom
        ),
        GradientPreset(
            name: "Galaxy",
            colors: [.purple, .blue, .black],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        GradientPreset(
            name: "Forest",
            colors: [.green, .mint, .cyan],
            startPoint: .leading,
            endPoint: .trailing
        )
    ]
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

// MARK: - Size Constants
struct SizeConstants {
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// Global size constants for easy access
let xs = SizeConstants.xs
let sm = SizeConstants.sm  
let md = SizeConstants.md
let lg = SizeConstants.lg
let xl = SizeConstants.xl
let xxl = SizeConstants.xxl

// MARK: - Radar and Resonance Types
struct RadarEcho {
    let id: UUID = UUID()
    let signal: String
    let timestamp: Date = Date()
    let resonanceLevel: Double
    let patterns: [String]
}

struct PingCycleInsights {
    let totalEchoes: Int
    let averageResonance: Double  
    let detectedPatterns: [String]
}

struct ResonanceMap {
    let id: UUID = UUID()
    var status: ResonanceStatus = .pending
    let patterns: [String]
    let resonanceLevel: Double
}

enum ResonanceStatus {
    case pending
    case approved
    case flaggedForReview
}
