import SwiftUI


// MARK: - Evolution Details View

struct EvolutionDetailsView: View {
    let result: EvolutionResult?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            if let result = result {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        mutationOverviewSection(result)
                        geneticChangesSection(result)
                        performanceMetricsSection(result)
                        renderDNASection(result)
                    }
                    .padding(.padding(.all))
                }
                .navigationTitle("Evolution Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            } else {
                Text("No evolution result available")
                    .foregroundColor(.secondary)
            }
        }
    }

    private func mutationOverviewSection(_ result: EvolutionResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mutation Overview")
                .systemFont(Font.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "Type", value: result.mutation.type.displayName)
                InfoRow(label: "Target", value: result.mutation.targetComponent.displayName)
                InfoRow(label: "Expected Benefit", value: result.mutation.expectedBenefit.displayName)
                InfoRow(label: "Risk Level", value: result.mutation.riskAssessment.displayName)
                InfoRow(label: "Semantic Hash", value: result.semanticHash.value.prefix(16) + "...")
            }
        }
        .padding(.padding(.all))
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
    }

    private func geneticChangesSection(_ result: EvolutionResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Genetic Changes")
                .systemFont(Font.title2)
                .fontWeight(.bold)

            ForEach(
                Array(result.mutation.geneticChanges.enumerated()),
                id: \.offset
            ) { index, change in
                GeneticChangeRow(change: change, index: index + 1)
            }
        }
        .padding(.padding(.all))
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
    }

    private func performanceMetricsSection(_ result: EvolutionResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Performance Metrics")
                .systemFont(Font.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 8) {
                InfoRow(
                    label: "Duration",
                    value: "\(result.performanceMetrics.duration, specifier: "%.3f")s"
                )
                InfoRow(
                    label: "Changes Applied",
                    value: "\(result.performanceMetrics.geneticChangesCount)"
                )
                InfoRow(
                    label: "Render Complexity",
                    value: "\(result.performanceMetrics.renderComplexity, specifier: "%.2f")"
                )
                InfoRow(
                    label: "Applied At",
                    value: result.performanceMetrics.appliedAt.formatted(
                        date: .abbreviated,
                        time: .standard
                    )
                )
            }
        }
        .padding(.padding(.all))
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
    }

    private func renderDNASection(_ result: EvolutionResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Render DNA State")
                .systemFont(Font.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 8) {
                DNAGenomeRow(
                    title: "Color Genome",
                    genome: "Contrast: \(result.renderDNA.colorGenome.contrastMultiplier, specifier: "%.2f")"
                )
                DNAGenomeRow(
                    title: "Typography",
                    genome: "Font Size: \(result.renderDNA.typographyGenome.baseFontSize, specifier: "%.1f")pt"
                )
                DNAGenomeRow(
                    title: "Layout",
                    genome: "Spacing: \(result.renderDNA.layoutGenome.spacingMultiplier, specifier: "%.2f")x"
                )
                DNAGenomeRow(
                    title: "Interaction",
                    genome: "Complexity: \(result.renderDNA.interactionGenome.gestureComplexity.rawValue)"
                )
                DNAGenomeRow(
                    title: "Adaptation",
                    genome: "Sensitivity: \(result.renderDNA.adaptationGenome.contextSensitivity, specifier: "%.2f")"
                )
            }
        }
        .padding(.padding(.all))
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
    }
}

// MARK: - Detail Supporting Views

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label + ":")
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .systemFont(Font.subheadline)
    }
}

struct GeneticChangeRow: View {
    let change: GeneticChange
    let index: Int

    var body: some View {
        HStack {
            Text("\(index).")
                .systemFont(Font.caption)
                .foregroundColor(.secondary)
                .frame(width: 20, alignment: .leading)

            Text(change.displayName)
                .systemFont(Font.subheadline)

            Spacer()

            Image(systemName: "arrow.right")
                .systemFont(Font.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}

struct DNAGenomeRow: View {
    let title: String
    let genome: String

    var body: some View {
        HStack {
            Text(title)
                .systemFont(Font.subheadline)
                .fontWeight(.medium)

            Spacer()

            Text(genome)
                .systemFont(Font.caption)
                .fontFamily(.monospaced)
                .foregroundColor(.secondary)
        }
    }
}
