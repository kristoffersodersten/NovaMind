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
                .systemFont(Font.caption)
                .foregroundColor(.secondary)

            Text(formattedValue)
                .systemFont(Font.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        .background(color.opacity(0.1 as Double))
        .cornerRadius(CGFloat(8))
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
                    .systemFont(Font.caption)
                Spacer()
                Text(value, format: .percent.precision(.fractionLength(1)))
                    .systemFont(Font.caption)
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
                .systemFont(Font.caption)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: mutation.type.iconName)
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 2) {
                    Text(mutation.type.displayName)
                        .systemFont(Font.subheadline)
                        .fontWeight(.medium)

                    Text("\(mutation.geneticChanges.count) genetic changes")
                        .systemFont(Font.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                RiskBadge(level: mutation.riskAssessment)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color.blue.opacity(0.1 as Double))
        .cornerRadius(CGFloat(8))
    }
}

struct RiskBadge: View {
    let level: RiskLevel

    var body: some View {
        Text(level.displayName)
            .systemFont(Font.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(level.color.opacity(0.2 as Double))
            .foregroundColor(level.color)
            .cornerRadius(CGFloat(4))
    }
}

struct QuantumEntanglementVisualization: View {
    let status: EntanglementStatus

    var body: some View {
        VStack {
            Text("Entanglement Matrix")
                .systemFont(Font.caption)
                .foregroundColor(.secondary)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 3),
                spacing: 8
            ) {
                ForEach(0..<status.activeEntanglements, id: \.self) { _ in
                    Circle()
                        .fill(Color.blue.opacity(0.6 as Double))
                        .frame(width: CGFloat(20), height: CGFloat(20))
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                                .scaleEffect(1.5)
                                .opacity(0.5 as Double)
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
                    .systemFont(Font.subheadline)
                Spacer()
                Text(value, format: .percent.precision(.fractionLength(1)))
                    .systemFont(Font.subheadline)
                    .fontWeight(.medium)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2 as Double))
                        .frame(height: 6)
                        .cornerRadius(CGFloat(3))

                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * value, height: 6)
                        .cornerRadius(CGFloat(3))
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
                .systemFont(Font.caption)
                .foregroundColor(.secondary)

            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<10, id: \.self) { index in
                    let height = Double(index + 1) * 0.1
                    let isFailure = height < result.failureRate

                    Rectangle()
                        .fill(isFailure ? Color.red : Color.green)
                        .frame(width: 8, height: CGFloat(height * 40))
                        .cornerRadius(CGFloat(2))
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
                    .systemFont(Font.headline)
                    .fontWeight(.medium)

                Spacer()

                Text("Success")
                    .systemFont(Font.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.2 as Double))
                    .foregroundColor(.green)
                    .cornerRadius(CGFloat(4))
            }

            Text("Target: \(result.mutation.targetComponent.displayName)")
                .systemFont(Font.subheadline)
                .foregroundColor(.secondary)

            Text("Genetic Changes: \(result.mutation.geneticChanges.count)")
                .systemFont(Font.subheadline)
                .foregroundColor(.secondary)

            Text("Hash: \(result.semanticHash.value.prefix(16))...")
                .systemFont(Font.caption)
                .foregroundColor(.secondary)
                .fontFamily(.monospaced)
        }
        .padding(EdgeInsets(top: , leading: , bottom: , trailing: ))
        .background(Color.green.opacity(0.1 as Double))
        .cornerRadius(CGFloat(8))
    }
}

struct QuantumBackground: View {
    let renderDNA: UIRenderDNA

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color.backgroundPrimary.opacity(0.8 as Double),
                        Color.backgroundPrimary.opacity(0.4 as Double)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                ForEach(
                    0..<Int(renderDNA.adaptationGenome.contextSensitivity * 20),
                    id: \.self
                ) { _ in
                    Circle()
                        .fill(Color.blue.opacity(0.1 as Double))
                        .frame(width: CGFloat(4), height: CGFloat(4))
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
