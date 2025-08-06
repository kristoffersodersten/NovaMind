import SwiftUI


// MARK: - Supporting Views for QuantumEvolutionaryView

struct MetricCard: View {
    let title: String
    let value: Double
    let format: MetricFormat
    let color: Color

    enum MetricFormat {
        case percentage
        case decimal
        case integer
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(formattedValue)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }

    private var formattedValue: String {
        switch format {
        case .percentage:
            return value.formatted(.percent.precision(.fractionLength(1)))
        case .decimal:
            return value.formatted(.number.precision(.fractionLength(2)))
        case .integer:
            return Int(value).formatted()
        }
    }
}

struct PreferenceSlider: View {
    let title: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                Spacer()
                Text(value, format: .percent.precision(.fractionLength(1)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Slider(value: $value, in: 0...1)
                .accentColor(.blue)
        }
    }
}

struct LastMutationView: View {
    let mutation: UIEvolutionMutation

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Last Mutation")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: mutation.type.iconName)
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 2) {
                    Text(mutation.type.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text("\(mutation.geneticChanges.count) genetic changes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                RiskBadge(level: mutation.riskAssessment)
            }
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

struct RiskBadge: View {
    let level: RiskLevel

    var body: some View {
        Text(level.displayName)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(level.color.opacity(0.2))
            .foregroundColor(level.color)
            .cornerRadius(4)
    }
}

struct QuantumEntanglementVisualization: View {
    let status: EntanglementStatus

    var body: some View {
        VStack {
            Text("Entanglement Matrix")
                .font(.caption)
                .foregroundColor(.secondary)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 3),
                spacing: 8
            ) {
                ForEach(0..<status.activeEntanglements, id: \.self) { _ in
                    Circle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                                .scaleEffect(1.5)
                                .opacity(0.5)
                                .animation(
                                    .easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true),
                                    value: status.coherenceLevel
                                )
                        )
                }
            }
            .frame(height: 80)
        }
    }
}

struct MoralMetricBar: View {
    let title: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text(value, format: .percent.precision(.fractionLength(1)))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)

                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * value, height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 0.5), value: value)
                }
            }
            .frame(height: 6)
        }
    }
}

struct ChaosResilienceChart: View {
    let result: ChaosTestResult

    var body: some View {
        VStack {
            Text("Resilience Visualization")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<10, id: \.self) { index in
                    let height = Double(index + 1) * 0.1
                    let isFailure = height < result.failureRate

                    Rectangle()
                        .fill(isFailure ? Color.red : Color.green)
                        .frame(width: 8, height: CGFloat(height * 40))
                        .cornerRadius(2)
                }
            }
            .frame(height: 50)
        }
    }
}

struct EvolutionHistoryCard: View {
    let result: EvolutionResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(result.mutation.type.displayName)
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()

                Text("Success")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(4)
            }

            Text("Target: \(result.mutation.targetComponent.displayName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Genetic Changes: \(result.mutation.geneticChanges.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Hash: \(result.semanticHash.value.prefix(16))...")
                .font(.caption)
                .foregroundColor(.secondary)
                .fontFamily(.monospaced)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}

struct QuantumBackground: View {
    let renderDNA: UIRenderDNA

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color.backgroundPrimary.opacity(0.8),
                        Color.backgroundPrimary.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                ForEach(
                    0..<Int(renderDNA.adaptationGenome.contextSensitivity * 20),
                    id: \.self
                ) { _ in
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 4, height: 4)
                        .position(
                            x: Double.random(in: 0...geometry.size.width),
                            y: Double.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...6))
                            .repeatForever(autoreverses: true),
                            value: renderDNA.adaptationGenome.contextSensitivity
                        )
                }
            }
        }
        .ignoresSafeArea()
    }
}
