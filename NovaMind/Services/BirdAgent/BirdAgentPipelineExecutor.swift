import Foundation

// MARK: - Bird Agent Pipeline Executor
class BirdAgentPipelineExecutor {
    private let stageExecutor = PipelineStageExecutor()
    
    // MARK: - Pipeline Execution
    
    func executePipelineStages(
        triggeredBy condition: TriggerCondition,
        metadata: [String: Any],
        activeAgents: [BirdAgent],
        onStageComplete: @escaping (StageResult) -> Void,
        onUpdate: @escaping (BirdAgent, String?) -> Void
    ) async -> [StageResult] {
        var results: [StageResult] = []
        
        let stages: [PipelineStage] = [
            .preflightReflection,
            .documentationAudit,
            .memoryIntegritySweep,
            .buildAndLint,
            .fullTestSuite,
            .constitutionalGate
        ]
        
        for stage in stages {
            let startTime = Date()
            let result = await executeStage(stage, activeAgents: activeAgents, onUpdate: onUpdate)
            let endTime = Date()
            
            let stageResult = StageResult(
                stage: stage,
                success: result.success,
                executionTime: endTime.timeIntervalSince(startTime),
                details: result.details,
                ethicalViolations: result.ethicalViolations,
                timestamp: startTime
            )
            
            results.append(stageResult)
            onStageComplete(stageResult)
            
            // Stop on critical failures
            if !result.success && isCriticalStage(stage) {
                break
            }
        }
        
        return results
    }
    
    private func executeStage(
        _ stage: PipelineStage,
        activeAgents: [BirdAgent],
        onUpdate: @escaping (BirdAgent, String?) -> Void
    ) async -> StageProcessResult {
        switch stage {
        case .preflightReflection:
            return await stageExecutor.executePreflightReflection(activeAgents: activeAgents, onUpdate: onUpdate)
        case .documentationAudit:
            return await stageExecutor.executeDocumentationAudit(activeAgents: activeAgents, onUpdate: onUpdate)
        case .memoryIntegritySweep:
            return await stageExecutor.executeMemoryIntegritySweep(activeAgents: activeAgents, onUpdate: onUpdate)
        case .buildAndLint:
            return await stageExecutor.executeBuildAndLint(activeAgents: activeAgents, onUpdate: onUpdate)
        case .fullTestSuite:
            return await stageExecutor.executeFullTestSuite(activeAgents: activeAgents, onUpdate: onUpdate)
        case .constitutionalGate:
            return await stageExecutor.executeConstitutionalGate(activeAgents: activeAgents, onUpdate: onUpdate)
        case .deploymentPreparation:
            return await stageExecutor.executeDeploymentPreparation(activeAgents: activeAgents, onUpdate: onUpdate)
        case .postDeploymentValidation:
            return await stageExecutor.executePostDeploymentValidation(activeAgents: activeAgents, onUpdate: onUpdate)
        }
    }
    
    // MARK: - Helper Methods
    
    private func isCriticalStage(_ stage: PipelineStage) -> Bool {
        switch stage {
        case .buildAndLint, .fullTestSuite, .constitutionalGate:
            return true
        case .preflightReflection, .documentationAudit, .memoryIntegritySweep,
             .deploymentPreparation, .postDeploymentValidation:
            return false
        }
    }
}
