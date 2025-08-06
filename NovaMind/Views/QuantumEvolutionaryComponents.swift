import SwiftUI

// MARK: - QuantumEvolutionaryView Supporting Components

struct MetricCard: View {
    let title: String
    let value: Double
    let format: MetricFormat
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(formattedValue)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.backgroundSecondary)
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

enum MetricFormat {
    case percentage
    case decimal
    case integer
}

struct EntanglementStatusCard: View {
    let status: EntanglementStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quantum Entanglement")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                Text("Network Coherence:")
                Spacer()
                Text(status.networkCoherence.formatted(.percent.precision(.fractionLength(1))))
                    .fontWeight(.semibold)
                    .foregroundColor(coherenceColor)
            }
            HStack {
                Text("Active Connections:")
                Spacer()
                Text("\(status.activeConnections)")
                    .fontWeight(.semibold)
            }
            HStack {
                Text("Entanglement Strength:")
                Spacer()
                Text(status.entanglementStrength.formatted(.percent.precision(.fractionLength(1))))
                    .fontWeight(.semibold)
                    .foregroundColor(strengthColor)
            }
            // Visual representation
            EntanglementVisualization(status: status)
        }
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
    }

    private var coherenceColor: Color {
        status.networkCoherence > 0.8 ? .green : status.networkCoherence > 0.6 ? .orange : .red
    }

    private var strengthColor: Color {
        status.entanglementStrength > 0.7 ? .blue : status.entanglementStrength > 0.5 ? .orange : .red
    }
}

struct EntanglementVisualization: View {
    let status: EntanglementStatus

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                Rectangle()
                    .fill(barColor(for: index))
                    .frame(height: 20)
                    .cornerRadius(2)
            }
        }
    }

    private func barColor(for index: Int) -> Color {
        let threshold = Double(index) / 5.0
        return status.entanglementStrength > threshold ? .blue : .gray.opacity(0.3)
    }
}

struct MoralGraphStatusCard: View {
    let status: MoralGraphStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Moral Graph Networks")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                Text("Integrity Score:")
                Spacer()
                Text(status.integrityScore.formatted(.percent.precision(.fractionLength(1))))
                    .fontWeight(.semibold)
                    .foregroundColor(integrityColor)
            }
            HStack {
                Text("Active Validators:")
                Spacer()
                Text("\(status.activeValidators)")
                    .fontWeight(.semibold)
            }
            HStack {
                Text("Consensus Level:")
                Spacer()
                Text(status.consensusLevel.formatted(.percent.precision(.fractionLength(1))))
                    .fontWeight(.semibold)
                    .foregroundColor(consensusColor)
            }
            if !status.recentViolations.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recent Violations:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ForEach(status.recentViolations.prefix(3), id: \.self) { violation in
                        Text("• \(violation)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
    }

    private var integrityColor: Color {
        status.integrityScore > 0.9 ? .green : status.integrityScore > 0.7 ? .orange : .red
    }

    private var consensusColor: Color {
        status.consensusLevel > 0.8 ? .green : status.consensusLevel > 0.6 ? .orange : .red
    }
}

struct ChaosResilienceCard: View {
    let result: ChaosTestResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Chaos Resilience")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                Text("Stress Tests Passed:")
                Spacer()
                Text("\(result.stressTestsPassed)/\(result.totalStressTests)")
                    .fontWeight(.semibold)
                    .foregroundColor(testColor)
            }
            HStack {
                Text("Avg. Collapse Threshold:")
                Spacer()
                Text("\(result.averageCollapseThreshold, specifier: "%.2f")σ")
                    .fontWeight(.semibold)
            }
            HStack {
                Text("Resilience Score:")
                Spacer()
                Text(result.resilienceScore, format: .percent.precision(.fractionLength(1)))
                    .fontWeight(.semibold)
                    .foregroundColor(result.resilienceScore > 0.8 ? .green : .orange)
            }
            ChaosResilienceChart(result: result)
        }
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
    }

    private var testColor: Color {
        let passRate = Double(result.stressTestsPassed) / Double(result.totalStressTests)
        return passRate > 0.8 ? .green : passRate > 0.6 ? .orange : .red
    }
}

struct ChaosResilienceChart: View {
    let result: ChaosTestResult

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Resilience Distribution")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack(spacing: 2) {
                ForEach(result.resilienceDistribution.indices, id: \.self) { index in
                    Rectangle()
                        .fill(Color.purple.opacity(result.resilienceDistribution[index]))
                        .frame(height: 30)
                }
            }
            .cornerRadius(4)
        }
    }
}

struct EvolutionHistoryCard: View {
    let result: EvolutionResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Latest Evolution")
                    .font(.headline)
                Spacer()
                Text(result.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Success:")
                Spacer()
                Image(systemName: result.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(result.success ? .green : .red)
            }
            if result.success {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Genetic Changes:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    ForEach(result.geneticChanges, id: \.id) { change in
                        Text("• \(change.displayName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            HStack {
                Text("Performance Impact:")
                Spacer()
                Text("\(result.performanceMetrics.renderComplexity, specifier: "%.2f")")
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(8)
    }
}

struct LastMutationView: View {
    let mutation: UIEvolutionMutation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Last Mutation")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Image(systemName: "dna")
                    .foregroundColor(.blue)
                Text(mutation.type.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(mutation.confidence, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            Text(mutation.expectedBenefit.displayName)
                .font(.caption)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(8)
    }
}

struct DNAGenomeRow: View {
    let title: String
    let genome: String

    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(genome)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
}
