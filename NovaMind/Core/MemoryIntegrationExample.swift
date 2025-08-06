import Foundation


// MARK: - Memory Architecture Integration Example

/// Example demonstrating how the memory architecture integrates with NovaMind agents
class MemoryIntegrationExample {
    private let memoryArchitecture = MemoryArchitecture.shared
    private let novaLinkCoordinator = NovaLinkCoordinator.shared

    // MARK: - Agent Memory Integration

    /// Example: Agent learns from user interaction
    func agentLearnsFromInteraction() async {
        do {
            // Store interaction in entity-bound memory
            try await memoryArchitecture.storeChatInteraction(
                agentId: "sparrow_001",
                userId: "user_alice",
                message: "Can you help me optimize this Swift function?",
                response: "I can help you optimize that function. " +
                         "Let me analyze the performance characteristics and suggest improvements.",
                context: "code_optimization_request",
                topics: ["swift", "optimization", "performance"]
            )

            // Store behavioral pattern
            let pattern = BehavioralPattern(
                agentId: "sparrow_001",
                pattern: "prefers_detailed_analysis_before_suggestions",
                frequency: 15,
                successRate: 0.87,
                contexts: ["code_optimization", "debugging", "architecture_review"],
                lastObserved: Date()
            )

            try await memoryArchitecture.store(
                pattern,
                for: MemoryContextBuilder.entityBound(agentId: "sparrow_001")
            )

            print("✅ Agent learning stored successfully")

        } catch {
            print("❌ Failed to store agent learning: \(error)")
        }
    }

    /// Example: Agents resolve conflict and store solution
    func agentsResolveConflict() async {
        do {
            // Two agents disagree on implementation approach
            let conflictDescription = "Agent Raven suggested using a singleton pattern " +
                                  "while Agent Owl recommended dependency injection for the APIClient class."

            let resolution = "After mentor consultation, decided to use dependency injection " +
                            "with a shared instance factory method. This provides testability benefits " +
                            "while maintaining convenient access patterns."

            try await memoryArchitecture.storeConflictResolution(
                conflictDescription: conflictDescription,
                participants: ["raven_002", "owl_003"],
                resolution: resolution,
                strategy: .mediation,
                outcome: .resolved
            )

            // Store the agreed-upon design solution
            let designSolution = DesignSolution(
                problem: "APIClient dependency management in multi-agent environment",
                solution: "Dependency injection with shared factory pattern",
                architecture: "Factory + DI pattern with protocol abstraction",
                constraints: ["thread_safety", "testability", "performance"],
                tradeoffs: ["slight_complexity_increase", "better_maintainability"],
                validation: .validated,
                timestamp: Date()
            )

            try await memoryArchitecture.store(
                designSolution,
                for: MemoryContextBuilder.collective(isResolution: true)
            )

            print("✅ Conflict resolution stored in collective memory")

        } catch {
            print("❌ Failed to store conflict resolution: \(error)")
        }
    }

    /// Example: System learns user preferences
    func systemLearnsUserPreferences() async {
        do {
            // User consistently chooses certain interface options
            let communicationPreference = UserPreference(
                userId: "user_alice",
                category: .communication,
                preference: "detailed_explanations_with_code_examples",
                strength: 0.85,
                context: "code_assistance_sessions",
                learnedFrom: ["interaction_001", "interaction_015", "interaction_023"],
                lastUpdated: Date()
            )

            try await memoryArchitecture.store(
                communicationPreference,
                for: MemoryContextBuilder.entityBound(agentId: "user_alice")
            )

            // Store workflow preference
            let workflowPreference = UserPreference(
                userId: "user_alice",
                category: .workflow,
                preference: "iterative_development_with_frequent_validation",
                strength: 0.92,
                context: "development_projects",
                learnedFrom: ["project_alpha", "project_beta"],
                lastUpdated: Date()
            )

            try await memoryArchitecture.store(
                workflowPreference,
                for: MemoryContextBuilder.entityBound(agentId: "user_alice")
            )

            print("✅ User preferences learned and stored")

        } catch {
            print("❌ Failed to store user preferences: \(error)")
        }
    }

    // MARK: - Memory Retrieval Examples

    /// Example: Retrieve similar solutions for new problem
    func findSimilarSolutions() async {
        do {
            let similarSolutions = try await memoryArchitecture.findSimilarSolutions(
                for: "need to manage API dependencies in a testable way",
                limit: 5
            )

            print("🔍 Found \(similarSolutions.count) similar solutions:")
            for solution in similarSolutions {
                print("  • \(solution.problem)")
                print("    Solution: \(solution.solution)")
                print("    Validation: \(solution.validation.rawValue)")
                print("")
            }

        } catch {
            print("❌ Failed to retrieve similar solutions: \(error)")
        }
    }

    /// Example: Retrieve interaction patterns for personalization
    func retrieveInteractionPatterns() async {
        let insights = await MemoryAnalytics.analyzeInteractionPatterns(
            for: "sparrow_001",
            memory: memoryArchitecture
        )

        print("📊 Interaction Pattern Insights:")
        for insight in insights {
            print("  Pattern: \(insight.pattern)")
            print("  Frequency: \(insight.frequency)")
            print("  Success Rate: \(String(format: "%.1f%%", insight.successRate * 100))")
            print("  Recommendation: \(insight.recommendation)")
            print("")
        }
    }

    /// Example: Generate personalization profile
    func generatePersonalizationProfile() async {
        let profile = await MemoryAnalytics.generatePersonalizationInsights(
            for: "user_alice",
            memory: memoryArchitecture
        )

        print("👤 Personalization Profile for user_alice:")
        print("  Communication Style: \(profile.communicationStyle)")
        print("  Interface Preferences: \(profile.interfacePreferences.joined(separator: ", "))")
        print("  Workflow Preferences: \(profile.workflowPreferences.joined(separator: ", "))")
        print("  Privacy Settings: \(profile.privacySettings.joined(separator: ", "))")
    }

    // MARK: - Memory Maintenance Examples

    /// Example: Clear short-term memory on context switch
    func handleContextSwitch() async {
        await memoryArchitecture.clearMemory(
            for: .shortTerm,
            condition: .contextSwitch
        )

        print("🔄 Short-term memory cleared for context switch")
    }

    /// Example: Handle agent reset
    func handleAgentReset(agentId: String) async {
        await memoryArchitecture.clearMemory(
            for: .entityBound(agentId),
            condition: .agentReset
        )

        print("🔄 Entity-bound memory cleared for agent: \(agentId)")
    }

    /// Example: Synchronize collective memory
    func synchronizeCollectiveKnowledge() async {
        do {
            try await memoryArchitecture.synchronizeCollectiveMemory()
            print("🌐 Collective memory synchronized with federation")
        } catch {
            print("❌ Failed to synchronize collective memory: \(error)")
        }
    }

    // MARK: - Advanced Memory Scenarios

    /// Example: Complex multi-agent memory interaction
    func complexMultiAgentScenario() async {
        do {
            // 1. Store agent skills
            let ravenSkill = AgentSkill(
                agentId: "raven_002",
                skillName: "architectural_pattern_analysis",
                proficiency: 0.93,
                domains: ["design_patterns", "system_architecture", "code_review"],
                examples: ["singleton_analysis", "factory_recommendation", "mvc_assessment"],
                lastUsed: Date(),
                improvementRate: 0.12
            )

            try await memoryArchitecture.store(
                ravenSkill,
                for: MemoryContextBuilder.entityBound(agentId: "raven_002")
            )

            // 2. Store interaction pattern between agents
            let interactionPattern = InteractionPattern(
                participantA: "raven_002",
                participantB: "owl_003",
                interactionType: .collaboration,
                pattern: "raven_proposes_owl_validates_pattern",
                frequency: 23,
                successMetrics: [
                    "solution_quality": 0.88,
                    "time_to_resolution": 0.76,
                    "user_satisfaction": 0.91
                ],
                context: "architectural_decisions",
                timestamp: Date()
            )

            try await memoryArchitecture.store(
                interactionPattern,
                for: MemoryContextBuilder.relation(agentA: "raven_002", agentB: "owl_003")
            )

            // 3. Store truth assertion with mentor validation
            let truthAssertion = TruthAssertion(
                assertion: "Dependency injection patterns improve testability " +
                          "in Swift applications when properly implemented with protocol abstractions",
                confidence: 0.95,
                sources: ["swift_docs", "clean_architecture_book", "mentor_validation_session_042"],
                mentorValidated: true,
                domain: "ios_development",
                timestamp: Date(),
                corrections: []
            )

            try await memoryArchitecture.store(
                truthAssertion,
                for: MemoryContextBuilder.collective(isResolution: true)
            )

            print("✅ Complex multi-agent memory scenario completed")

        } catch {
            print("❌ Failed in complex scenario: \(error)")
        }
    }

    // MARK: - Memory Health Monitoring

    /// Example: Monitor memory health and take action
    func monitorMemoryHealth() async {
        let health = memoryArchitecture.memoryHealth

        print("🏥 Memory Health Report:")
        print("  Overall Health: \(String(format: "%.1f%%", health.overallHealth * 100))")
        print("  Short-term: \(health.shortTerm.isHealthy ? "✅" : "⚠️") (\(health.shortTerm.totalEntries) entries)")
        print("  Entity-bound: \(health.entityBound.isHealthy ? "✅" : "⚠️") (\(health.entityBound.totalEntries) agents)")
        print("  Relation: \(health.relation.isHealthy ? "✅" : "⚠️") (\(health.relation.totalEntries) relations)")
        print("  Collective: \(health.collective.isHealthy ? "✅" : "⚠️")")

        // Take action if health is degraded
        if health.overallHealth < 0.7 {
            print("⚠️ Memory health degraded - triggering maintenance")
            await performMemoryMaintenance()
        }
    }

    private func performMemoryMaintenance() async {
        print("🔧 Performing memory maintenance...")

        // Clear old short-term entries
        await memoryArchitecture.clearMemory(for: .shortTerm, condition: .systemRestart)

        // Synchronize collective memory
        try? await memoryArchitecture.synchronizeCollectiveMemory()

        print("✅ Memory maintenance completed")
    }

    // MARK: - Demo Runner

    /// Run all memory integration examples
    func runMemoryDemo() async {
        print("🧠 Starting NovaMind Memory Architecture Demo")
        print("=" * 50)

        await agentLearnsFromInteraction()
        await systemLearnsUserPreferences()
        await agentsResolveConflict()
        await complexMultiAgentScenario()

        print("\n🔍 Memory Retrieval Examples:")
        print("-" * 30)

        await findSimilarSolutions()
        await retrieveInteractionPatterns()
        await generatePersonalizationProfile()

        print("\n🏥 Memory Health Monitoring:")
        print("-" * 30)

        await monitorMemoryHealth()

        print("\n🎉 Memory Architecture Demo Complete!")
    }
}

// MARK: - String Extension for Demo

extension String {
    static func * (lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}

// MARK: - Memory Demo Usage Example

/*
// To run the memory demo:

let memoryDemo = MemoryIntegrationExample()
Task {
    await memoryDemo.runMemoryDemo()
}

// Example output:
🧠 Starting NovaMind Memory Architecture Demo
==================================================
✅ Agent learning stored successfully
✅ User preferences learned and stored
✅ Conflict resolution stored in collective memory
✅ Complex multi-agent memory scenario completed

🔍 Memory Retrieval Examples:
------------------------------
🔍 Found 2 similar solutions:
  • APIClient dependency management in multi-agent environment
    Solution: Dependency injection with shared factory pattern
    Validation: validated

  • Database connection pooling for concurrent agents
    Solution: Connection pool with agent-specific contexts
    Validation: validated

📊 Interaction Pattern Insights:
  Pattern: prefers_detailed_analysis_before_suggestions
  Frequency: 15
  Success Rate: 87.0%
  Recommendation: Continue using this interaction pattern - high success rate

👤 Personalization Profile for user_alice:
  Communication Style: detailed_explanations_with_code_examples
  Interface Preferences: detailed_code_examples, step_by_step_guidance
  Workflow Preferences: iterative_development_with_frequent_validation
  Privacy Settings:

🏥 Memory Health Monitoring:
------------------------------
🏥 Memory Health Report:
  Overall Health: 87.3%
  Short-term: ✅ (45 entries)
  Entity-bound: ✅ (8 agents)
  Relation: ✅ (12 relations)
  Collective: ✅
*/
