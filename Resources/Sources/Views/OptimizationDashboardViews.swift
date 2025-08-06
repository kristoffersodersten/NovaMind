import SwiftUI

// MARK: - Dashboard Views
struct PerformanceMetricsView: View {
    @ObservedObject var guiController: NovaMindGUIController

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            MetricCard(
                title: "Render Time",
                value: "\(guiController.performanceMetrics.renderTime, specifier: "%.1f")ms",
                trend: .stable,
                color: .blue
            )

            MetricCard(
                title: "Optimization Rate",
                value: "\(Int(guiController.performanceMetrics.optimizationRate * 100))%",
                trend: .improving,
                color: .green
            )

            MetricCard(
                title: "Prediction Accuracy",
                value: "\(Int(guiController.performanceMetrics.predictionAccuracy * 100))%",
                trend: .stable,
                color: .purple
            )

            MetricCard(
                title: "Response Time",
                value: "\(guiController.performanceMetrics.responseTime, specifier: "%.0f")ms",
                trend: .improving,
                color: .orange
            )
        }
    }
}

struct PredictionsView: View {
    @ObservedObject var guiController: NovaMindGUIController

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Predictions")
                .font(.headline)

            if let prediction = guiController.currentPrediction {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Confidence: \(Int(prediction.confidence * 100))%")
                        Spacer()
                        Text("Horizon: \(prediction.timeHorizon, specifier: "%.1f")s")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text("Expected \(prediction.expectedInteractions.count) interactions")
                        .font(.caption)

                    ForEach(prediction.expectedInteractions.prefix(3), id: \.target) { interaction in
                        HStack {
                            Text(interaction.target)
                                .font(.caption)
                            Spacer()
                            Text("\(Int(interaction.probability * 100))%")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(8)
            } else {
                Text("No active predictions")
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }
}

struct AdaptationsView: View {
    @ObservedObject var guiController: NovaMindGUIController

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Layout Adaptations")
                .font(.headline)

            if let layout = guiController.currentLayout {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Grid: \(layout.gridConfiguration.columns) columns")
                        Spacer()
                        Text("Mode: \(layout.performanceMode.description)")
                    }
                    .font(.caption)

                    Text("Animation: \(layout.animationPreferences.duration, specifier: "%.1f")s")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(8)
            } else {
                Text("No active adaptations")
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }
}

struct ConnectionsView: View {
    @ObservedObject var guiController: NovaMindGUIController

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WebSocket Connections")
                .font(.headline)

            if let data = guiController.latestOptimizationData {
                DataFlowVisualization(
                    flowPaths: FlowPathGenerator.generate(from: data.metrics)
                )
                .frame(height: 120)
                .background(.ultraThinMaterial)
                .cornerRadius(8)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Throughput")
                        Text("\(data.metrics.throughput, specifier: "%.1f") MB/s")
                            .font(.caption)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("Latency")
                        Text("\(data.metrics.latency * 1000, specifier: "%.0f") ms")
                            .font(.caption)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            } else {
                Text("No connection data available")
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }
}

// MARK: - Real-time Status Indicator
struct RealTimeStatusIndicator: View {
    @ObservedObject var guiController: NovaMindGUIController
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 8) {
            // AI Status
            Circle()
                .fill(aiStatusColor)
                .frame(width: 6, height: 6)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)

            Text("AI Engine")
                .font(.caption2)
                .foregroundStyle(.secondary)

            // WebSocket Status
            Rectangle()
                .fill(.separator)
                .frame(width: 1, height: 12)

            Circle()
                .fill(socketStatusColor)
                .frame(width: 6, height: 6)

            Text("WebSocket")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .onAppear {
            isAnimating = true
        }
    }

    private var aiStatusColor: Color {
        if guiController.isActive {
            return .green
        } else {
            return .gray
        }
    }

    private var socketStatusColor: Color {
        switch guiController.webSocketManager.connectionStatus {
        case .connected: return .green
        case .connecting: return .yellow
        case .disconnected: return .gray
        case .error: return .red
        }
    }
}

// MARK: - Quick Actions Panel
struct QuickActionsPanel: View {
    @ObservedObject var guiController: NovaMindGUIController

    var body: some View {
        HStack(spacing: 12) {
            ActionButton(
                title: "Optimize",
                icon: "wand.and.stars",
                color: .purple
            ) {
                guiController.triggerOptimization()
            }

            ActionButton(
                title: "Reset",
                icon: "arrow.clockwise",
                color: .blue
            ) {
                guiController.resetOptimizations()
            }

            ActionButton(
                title: guiController.isActive ? "Pause" : "Resume",
                icon: guiController.isActive ? "pause.fill" : "play.fill",
                color: .orange
            ) {
                guiController.toggleOptimization()
            }
        }
        .padding(.horizontal)
    }
}

private struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)

                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .hoverEffect(.lift)
    }
}

// MARK: - Floating Controls
struct FloatingOptimizationControls: View {
    @ObservedObject var guiController: NovaMindGUIController
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 8) {
            if isExpanded {
                VStack(spacing: 6) {
                    QuickActionsPanel(guiController: guiController)
                    RealTimeStatusIndicator(guiController: guiController)
                }
                .transition(.opacity.combined(with: .scale))
            }

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .buttonStyle(.plain)
        }
    }
}
