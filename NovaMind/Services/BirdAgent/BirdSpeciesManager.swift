import Foundation

// MARK: - Bird Species Manager
class BirdSpeciesManager {
    
    // MARK: - Species Initialization
    
    func createAllSpecies() -> [BirdSpecies] {
        return createCoreSpecies() + createSpecializedSpecies()
    }
    
    private func createCoreSpecies() -> [BirdSpecies] {
        return [
            BirdSpecies(
                name: "sparrow",
                description: "Agile unit tests, short memory sweeps",
                capabilities: [.unitTesting, .memoryManagement, .rapidExecution],
                autonomyLevel: 3,
                specializations: ["unit_tests", "memory_sweeps", "quick_validation"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.shortTerm])
            ),
            BirdSpecies(
                name: "raven",
                description: "Strategic oversight, regression patterns",
                capabilities: [.strategicAnalysis, .patternRecognition, .oversight],
                autonomyLevel: 3,
                specializations: ["regression_analysis", "strategic_planning", "system_oversight"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.shortTerm, .relationBound])
            ),
            BirdSpecies(
                name: "owl",
                description: "Semantic reflection, doc audits",
                capabilities: [.semanticAnalysis, .documentation, .reflection],
                autonomyLevel: 3,
                specializations: ["semantic_analysis", "documentation_audit", "reflection"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.relationBound, .collectiveMesh])
            )
        ]
    }
    
    private func createSpecializedSpecies() -> [BirdSpecies] {
        return [
            BirdSpecies(
                name: "kestrel",
                description: "Performance tracking, latency detection",
                capabilities: [.performanceMonitoring, .latencyDetection, .benchmarking],
                autonomyLevel: 3,
                specializations: ["performance_tracking", "latency_monitoring", "benchmark_analysis"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.shortTerm, .relationBound])
            ),
            BirdSpecies(
                name: "heron",
                description: "Memory integrity and drift correction",
                capabilities: [.memoryIntegrity, .driftCorrection, .dataValidation],
                autonomyLevel: 3,
                specializations: ["memory_integrity", "drift_detection", "data_validation"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.relationBound, .collectiveMesh])
            ),
            BirdSpecies(
                name: "falcon",
                description: "Fast CI-trigger deployment, refactor watch",
                capabilities: [.cicdTrigger, .deployment, .refactorMonitoring],
                autonomyLevel: 3,
                specializations: ["ci_trigger", "fast_deployment", "refactor_watch"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.shortTerm])
            ),
            BirdSpecies(
                name: "swallow",
                description: "UI snapshot diffing and pixel-shift detection",
                capabilities: [.uiTesting, .visualDiffing, .pixelAnalysis],
                autonomyLevel: 3,
                specializations: ["ui_snapshot", "pixel_diffing", "visual_regression"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.shortTerm, .relationBound])
            ),
            BirdSpecies(
                name: "albatross",
                description: "Deep system memory + rare correlation sweeps",
                capabilities: [.deepAnalysis, .correlationAnalysis, .systemMemory],
                autonomyLevel: 3,
                specializations: ["deep_memory", "correlation_analysis", "rare_pattern_detection"],
                memoryBinding: MemoryBinding(mode: .perEntity, stores: [.collectiveMesh])
            )
        ]
    }
    
    // MARK: - Mentor Selection
    
    func selectMentorForSpecies(species: String) -> String {
        switch species {
        case "sparrow":
            return "Asuka Langley Soryu - precision, speed, attention to detail"
        case "raven":
            return "L (Death Note) - strategic, deep pattern thinking, systems oversight"
        case "owl":
            return "Senku Ishigami (Dr. Stone) - scientific method, documentation, logical reflection"
        case "kestrel":
            return "Edward Elric - determination, alchemy precision (performance tuning)"
        case "heron":
            return "Makoto Tachibana - calm, reliability, maintaining integrity"
        case "falcon":
            return "Monkey D. Luffy - fast action, adaptability, boldness"
        case "swallow":
            return "Shoto Todoroki - precision, visual clarity, detail focus"
        case "albatross":
            return "Itachi Uchiha - deep wisdom, long-term thinking, rare insights"
        default:
            return "Tanjiro Kamado - empathy, adaptability, ethical foundation"
        }
    }
}
