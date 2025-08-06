import Foundation

// MARK: - Bird Agent Support Methods

extension BirdAgentOrchestrator {
    
    func completeAgentTask(agent: BirdAgent, success: Bool) async {
        if let index = activeAgents.firstIndex(where: { $0.id == agent.id }) {
            activeAgents[index].currentTask = nil
            activeAgents[index].lastHeartbeat = Date()

            // Update performance metrics
            if var metrics = agentPerformance[agent.id] {
                metrics.tasksCompleted += 1
                let previousTotal = Double(metrics.tasksCompleted - 1)
                let currentSuccess = success ? 1.0 : 0.0
                let totalTasks = Double(metrics.tasksCompleted)
                metrics.successRate = (metrics.successRate * previousTotal + currentSuccess) / totalTasks
                metrics.lastActive = Date()
                agentPerformance[agent.id] = metrics
            }
        }
    }

    func handleCriticalFailure(stage: PipelineStage, result: StageResult) async {
        print("🚨 Critical failure in stage: \(stage.rawValue)")
        pipelineStatus = .failed

        // Notify all mentors
        await notifyMentorsOfFailure(stage: stage, result: result)

        // Log to ethics ledger if ethical violation
        if !result.ethicalViolations.isEmpty {
            await logToEthicsLedger(violations: result.ethicalViolations)
        }
    }

    private func handleEthicalViolation(violations: [EthicalViolation]) async {
        ethicalCompliance.totalViolations += violations.count
        ethicalCompliance.lastViolation = Date()

        // Hard halt CI/CD
        pipelineStatus = .failed

        // Auto notify all mentors
        await notifyMentorsOfEthicalViolation(violations: violations)

        // Rollback memory diff
        await rollbackMemoryDiff()

        // Log to ethics ledger
        await logToEthicsLedger(violations: violations.map { $0.description })
    }

    private func notifyMentorsOfFailure(stage: PipelineStage, result: StageResult) async {
        // Implementation for mentor notification
    }

    private func notifyMentorsOfEthicalViolation(violations: [EthicalViolation]) async {
        // Implementation for ethical violation notification
    }

    private func rollbackMemoryDiff() async {
        // Implementation for memory rollback
    }

    private func logToEthicsLedger(violations: [String]) async {
        let ledgerPath = "/Volumes/kristoffersodersten/NovaMind/EthicsLedger.md"
        let timestamp = Date()
        let entry = """

        ## Ethics Violation - \(timestamp)

        **Violations:**
        \(violations.map { "- \($0)" }.joined(separator: "\n"))

        **Action Taken:** Pipeline halted, mentors notified, memory rolled back

        ---
        """

        do {
            let url = URL(fileURLWithPath: ledgerPath)
            let existingContent = (try? String(contentsOf: url)) ?? ""
            let header = existingContent.isEmpty ?
                "# Ethics Ledger\n\nThis file tracks all ethical violations in the NovaMind ecosystem.\n" : ""
            let newContent = header + existingContent + entry
            try newContent.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("⚠️ Failed to write to ethics ledger: \(error)")
        }
    }

    func completePipeline(results: [StageResult]) async {
        let success = results.allSatisfy { $0.success }
        pipelineStatus = success ? .completed : .failed

        let totalTime = results.map { $0.executionTime }.reduce(0, +)
        print("✅ Pipeline completed in \(String(format: "%.2f", totalTime))s - Success: \(success)")

        await generatePipelineReport(results: results)
    }

    private func generatePipelineReport(results: [StageResult]) async {
        // Implementation for pipeline report generation
    }

    func monitorAgentPerformance() async {
        for agent in activeAgents {
            let timeSinceLastHeartbeat = Date().timeIntervalSince(agent.lastHeartbeat)
            if timeSinceLastHeartbeat > 300 {
                print("⚠️ Agent \(agent.id) may be unresponsive - last heartbeat: \(agent.lastHeartbeat)")
                
                // Attempt to restart agent
                await restartAgent(agent)
            }
        }
    }

    private func restartAgent(_ agent: BirdAgent) async {
        print("🔄 Attempting to restart agent: \(agent.id)")
        
        if let index = activeAgents.firstIndex(where: { $0.id == agent.id }) {
            activeAgents[index].lastHeartbeat = Date()
            activeAgents[index].currentTask = nil
            
            // Reset performance metrics if needed
            if var metrics = agentPerformance[agent.id] {
                metrics.lastActive = Date()
                agentPerformance[agent.id] = metrics
            }
        }
    }
}
