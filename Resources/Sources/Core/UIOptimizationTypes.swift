import Foundation
import SwiftUI

// MARK: - Optimization Data
struct OptimizationData: Codable {
    let metrics: DataFlowMetrics
    let recommendations: [UIRecommendation]
    let significantChange: Bool
    let confidence: Double

    struct DataFlowMetrics: Codable {
        let throughput: Double
        let latency: TimeInterval
        let packetLoss: Double
        let activeConnections: Int
    }
}

struct UIRecommendation: Codable {
    let type: RecommendationType
    let description: String
    let priority: RecommendationPriority
    let parameters: [String: String]

    enum RecommendationType: String, Codable {
        case layout
        case animation
        case rendering
        case performance
    }

    enum RecommendationPriority: String, Codable {
        case low
        case medium
        case high
        case critical
    }
}

// MARK: - Render Prediction
struct RenderPrediction {
    let elements: [UIElement]
    let expectedInteractions: [UserInteraction]
    let confidence: Double
    let timeHorizon: TimeInterval
}

struct UIElement: Identifiable {
    let id: String
    let type: ElementType
    let properties: [String: Any]

    enum ElementType {
        case button
        case textField
        case image
        case list
        case custom(String)
    }
}

struct UserInteraction {
    let type: InteractionType
    let target: String
    let probability: Double
    let expectedTime: TimeInterval

    enum InteractionType {
        case tap
        case drag
        case scroll
        case hover
        case keyboard
    }
}

// MARK: - Adaptive Layout
struct AdaptiveLayout {
    let gridConfiguration: GridConfiguration
    let animationPreferences: AnimationPreferences
    let performanceMode: PerformanceMode
    let responsiveBreakpoints: ResponsiveBreakpoints
}

struct GridConfiguration {
    let columns: Int
    let spacing: Double
    let itemSize: CGSize
    let adaptiveResize: Bool
}

struct AnimationPreferences {
    let duration: TimeInterval
    let curve: AnimationCurve
    let reducedMotion: Bool

    enum AnimationCurve {
        case linear
        case easeIn
        case easeOut
        case easeInOut
        case spring(damping: Double, response: Double)
    }
}

enum PerformanceMode {
    case highQuality
    case balanced
    case battery
    case lowPower
}

struct ResponsiveBreakpoints {
    let compact: CGFloat
    let regular: CGFloat
    let large: CGFloat
}

// MARK: - Flow Visualization
struct FlowPath {
    let path: Path
    let color: Color
    let width: CGFloat
    let animationSpeed: Double
    let opacity: Double

    func path(in rect: CGRect) -> Path {
        // Transform the path to fit the given rectangle
        var transformedPath = Path()

        // Apply scaling and translation to fit the rect
        let scaleX = rect.width / 100.0  // Assuming original path is in 100x100 space
        let scaleY = rect.height / 100.0

        transformedPath.addPath(path, transform: CGAffineTransform(
            scaleX: scaleX,
            y: scaleY
        ).translatedBy(x: rect.minX, y: rect.minY))

        return transformedPath
    }
}

class FlowPathGenerator {
    static func generate(from metrics: OptimizationData.DataFlowMetrics) -> [FlowPath] {
        var paths: [FlowPath] = []

        // Generate paths based on throughput
        let throughputPath = createThroughputPath(metrics.throughput)
        paths.append(throughputPath)

        // Generate paths based on latency
        let latencyPath = createLatencyPath(metrics.latency)
        paths.append(latencyPath)

        // Generate connection paths
        for connectionIndex in 0..<metrics.activeConnections {
            let connectionPath = createConnectionPath(index: connectionIndex, total: metrics.activeConnections)
            paths.append(connectionPath)
        }

        return paths
    }

    private static func createThroughputPath(_ throughput: Double) -> FlowPath {
        var path = Path()

        // Create a flowing curve representing throughput
        path.move(to: CGPoint(x: 0, y: 50))
        path.addCurve(
            to: CGPoint(x: 100, y: 50),
            control1: CGPoint(x: 25, y: 50 - throughput * 10),
            control2: CGPoint(x: 75, y: 50 + throughput * 10)
        )

        return FlowPath(
            path: path,
            color: .blue,
            width: max(1.0, CGFloat(throughput / 10.0)),
            animationSpeed: throughput,
            opacity: min(1.0, throughput / 100.0 + 0.3)
        )
    }

    private static func createLatencyPath(_ latency: TimeInterval) -> FlowPath {
        var path = Path()

        // Create a jagged path for high latency, smooth for low latency
        let smoothness = max(0.1, 1.0 - latency)

        path.move(to: CGPoint(x: 0, y: 25))
        for step in stride(from: 0.0, to: 100.0, by: 10.0) {
            let variance = (1.0 - smoothness) * 5.0
            let yOffset = Double.random(in: -variance...variance)
            path.addLine(to: CGPoint(x: step, y: 25 + yOffset))
        }

        return FlowPath(
            path: path,
            color: latency > 0.1 ? .red : .green,
            width: 2.0,
            animationSpeed: max(0.5, 2.0 - latency * 10),
            opacity: 0.7
        )
    }

    private static func createConnectionPath(index: Int, total: Int) -> FlowPath {
        var path = Path()

        let startY = 75.0 + Double(index) * (20.0 / max(1.0, Double(total - 1)))
        path.move(to: CGPoint(x: 0, y: startY))
        path.addLine(to: CGPoint(x: 100, y: startY))

        return FlowPath(
            path: path,
            color: Color.gray,
            width: 1.0,
            animationSpeed: 1.0,
            opacity: 0.5
        )
    }
}
