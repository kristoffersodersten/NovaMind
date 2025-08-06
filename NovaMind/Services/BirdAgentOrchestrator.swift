import Foundation
import SwiftUI

// MARK: - Bird Agent Orchestrator
@MainActor
class BirdAgentOrchestrator: ObservableObject {
    
    // MARK: - Published Properties
    @Published var activeAgents: [BirdAgent] = []
    @Published var isRunningPipeline: Bool = false
    @Published var lastPipelineResults: [StageResult] = []
    @Published var performanceMetrics: PerformanceMetrics = PerformanceMetrics()
    @Published var currentStage: PipelineStage?
    @Published var lastTrigger: TriggerCondition?
    
    // MARK: - Component Managers
    private let speciesManager = BirdSpeciesManager()
    private let deploymentManager = BirdAgentDeploymentManager()
    private let pipelineExecutor = BirdAgentPipelineExecutor()
    private let performanceMonitor = BirdAgentPerformanceMonitor()
    
    // MARK: - Initialization
    
    init() {
        Task {
            await initializeOrchestrator()
        }
    }
    
    private func initializeOrchestrator() async {
        // Setup species and deploy initial agents
        let species = await speciesManager.setupSpecies()
        activeAgents = await deploymentManager.deployInitialAgents(species: species)
        
        // Initialize performance monitoring
        await performanceMonitor.setupPerformanceMonitoring(for: activeAgents) { [weak self] updatedMetrics in
            Task { @MainActor in
                self?.performanceMetrics = updatedMetrics
            }
        }
    }
    
    // MARK: - Pipeline Orchestration
    
    func triggerPipeline(_ condition: TriggerCondition, metadata: [String: Any] = [:]) async {
        guard !isRunningPipeline else { return }
        
        isRunningPipeline = true
        lastTrigger = condition
        currentStage = nil
        
        let results = await pipelineExecutor.executePipelineStages(
            triggeredBy: condition,
            metadata: metadata,
            activeAgents: activeAgents,
            onStageComplete: { [weak self] result in
                Task { @MainActor in
                    self?.currentStage = result.stage
                }
            },
            onUpdate: { [weak self] agent, status in
                Task { @MainActor in
                    if let index = self?.activeAgents.firstIndex(where: { $0.id == agent.id }) {
                        self?.activeAgents[index].currentTask = status
                    }
                }
            }
        )
        
        lastPipelineResults = results
        isRunningPipeline = false
        currentStage = nil
        
        // Update performance metrics
        await performanceMonitor.updateMetrics(
            pipelineResults: results,
            triggerCondition: condition
        )
    }
    
    // MARK: - Agent Management
    
    func refreshAgents() async {
        let species = await speciesManager.setupSpecies()
        activeAgents = await deploymentManager.deployInitialAgents(species: species)
    }
    
    func getAgentCapabilities() -> [String: [AgentCapability]] {
        var capabilities: [String: [AgentCapability]] = [:]
        for agent in activeAgents {
            capabilities[agent.species.name] = agent.species.capabilities
        }
        return capabilities
    }
    
    // MARK: - Status and Metrics
    
    var systemHealth: String {
        let activeCount = activeAgents.count
        let hasRecentFailures = lastPipelineResults.contains { !$0.success }
        
        if activeCount == 0 {
            return "OFFLINE"
        } else if hasRecentFailures {
            return "DEGRADED"
        } else {
            return "HEALTHY"
        }
    }
    
    var readinessStatus: String {
        if isRunningPipeline {
            return "BUSY"
        } else if activeAgents.isEmpty {
            return "NOT_READY"
        } else {
            return "READY"
        }
    }
}
