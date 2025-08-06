import Foundation

// MARK: - Bird Agent Performance Monitor
class BirdAgentPerformanceMonitor {
    private var monitoringTimer: Timer?
    
    // MARK: - Performance Monitoring
    
    func setupPerformanceMonitoring(
        onUpdate: @escaping ([String: AgentPerformanceMetrics]) -> Void
    ) {
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task { await self.monitorAgentPerformance(onUpdate: onUpdate) }
        }
    }
    
    func stopPerformanceMonitoring() {
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }
    
    private func monitorAgentPerformance(
        onUpdate: @escaping ([String: AgentPerformanceMetrics]) -> Void
    ) async {
        // Simulate performance monitoring
        // In a real implementation, this would gather actual metrics
        await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // For now, we'll just update last active time
        // The actual metrics would be updated by the orchestrator
    }
    
    // MARK: - Metrics Management
    
    func initializePerformanceMetrics(for agent: BirdAgent) -> AgentPerformanceMetrics {
        return AgentPerformanceMetrics(
            agentId: agent.id,
            species: agent.species.name,
            tasksCompleted: 0,
            averageExecutionTime: 0.0,
            successRate: 1.0,
            ethicalViolations: 0,
            lastActive: Date()
        )
    }
    
    func updateMetrics(
        for agentId: String,
        in metrics: inout [String: AgentPerformanceMetrics],
        taskCompleted: Bool = false,
        executionTime: TimeInterval? = nil,
        ethicalViolation: Bool = false
    ) {
        guard var agentMetrics = metrics[agentId] else { return }
        
        if taskCompleted {
            agentMetrics.tasksCompleted += 1
            
            if let time = executionTime {
                let totalTime = agentMetrics.averageExecutionTime * Double(agentMetrics.tasksCompleted - 1)
                agentMetrics.averageExecutionTime = (totalTime + time) / Double(agentMetrics.tasksCompleted)
            }
            
            // Update success rate based on completion
            let totalTasks = Double(agentMetrics.tasksCompleted)
            let successfulTasks = totalTasks * agentMetrics.successRate
            agentMetrics.successRate = successfulTasks / totalTasks
        }
        
        if ethicalViolation {
            agentMetrics.ethicalViolations += 1
        }
        
        agentMetrics.lastActive = Date()
        metrics[agentId] = agentMetrics
    }
    
    func completeAgentTask(
        for agent: BirdAgent,
        success: Bool,
        executionTime: TimeInterval,
        in metrics: inout [String: AgentPerformanceMetrics]
    ) {
        updateMetrics(
            for: agent.id,
            in: &metrics,
            taskCompleted: success,
            executionTime: executionTime,
            ethicalViolation: !success
        )
    }
    
    // MARK: - Performance Analysis
    
    func getPerformanceSummary(from metrics: [String: AgentPerformanceMetrics]) -> PerformanceSummary {
        let totalTasks = metrics.values.reduce(0) { $0 + $1.tasksCompleted }
        let averageSuccessRate = metrics.values.isEmpty ? 0.0 :
            metrics.values.map { $0.successRate }.reduce(0, +) / Double(metrics.count)
        let totalViolations = metrics.values.reduce(0) { $0 + $1.ethicalViolations }
        
        return PerformanceSummary(
            totalTasks: totalTasks,
            averageSuccessRate: averageSuccessRate,
            totalEthicalViolations: totalViolations,
            activeAgents: metrics.count
        )
    }
}

// MARK: - Supporting Types

struct PerformanceSummary {
    let totalTasks: Int
    let averageSuccessRate: Double
    let totalEthicalViolations: Int
    let activeAgents: Int
}
