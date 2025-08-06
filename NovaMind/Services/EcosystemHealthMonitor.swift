import Combine
import Foundation
import SwiftUI

// MARK: - Ecosystem Health Monitor

/// Comprehensive health monitoring system for the entire NovaMind ecosystem
@MainActor
class EcosystemHealthMonitor: ObservableObject {
    static let shared = EcosystemHealthMonitor()

    // MARK: - Published State

    @Published private(set) var overallHealth: Double = 1.0
    @Published private(set) var componentHealth: [String: ComponentHealth] = [:]
    @Published private(set) var lastHealthCheck: Date = Date()
    @Published private(set) var isMonitoring: Bool = false
    @Published private(set) var healthHistory: [HealthSnapshot] = []

    // MARK: - Health Components

    private let ecosystemValidator = EcosystemValidator.shared
    private let memoryArchitecture = MemoryArchitecture.shared
    private let neuroMeshMemory = NeuroMeshMemorySystem.shared
    private let coralEngine = CoralEngine.shared
    private let resonanceRadar = AgentResonanceRadar.shared
    private let mentorRegistry = MentorRegistry.shared

    // MARK: - Monitoring Configuration

    private let healthCheckInterval: TimeInterval = 300.0 // 5 minutes
    private let maxHistoryEntries = 100
    private var healthTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupHealthMonitoring()
    }

    // MARK: - Public Interface

    /// Start continuous ecosystem health monitoring
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        
        healthTimer = Timer.scheduledTimer(withTimeInterval: healthCheckInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.performHealthCheck()
            }
        }
        
        // Perform initial health check
        Task {
            await performHealthCheck()
        }
        
        print("🏥 Ecosystem Health Monitor started")
    }

    /// Stop health monitoring
    func stopMonitoring() {
        isMonitoring = false
        healthTimer?.invalidate()
        healthTimer = nil
        
        print("🏥 Ecosystem Health Monitor stopped")
    }

    /// Force an immediate health check
    func forceHealthCheck() async {
        await performHealthCheck()
    }

    // MARK: - Health Check Implementation

    private func performHealthCheck() async {
        let startTime = Date()
        
        print("🔍 Performing ecosystem health check...")
        
        // Check all ecosystem components
        let memoryHealth = await checkMemoryHealth()
        let neuroMeshHealth = await checkNeuroMeshHealth()
        let coralHealth = await checkCoralHealth()
        let resonanceHealth = await checkResonanceHealth()
        let mentorHealth = await checkMentorHealth()
        let validationHealth = await checkValidationHealth()
        
        // Update component health
        componentHealth = [
            "memory": memoryHealth,
            "neuromesh": neuroMeshHealth,
            "coral": coralHealth,
            "resonance": resonanceHealth,
            "mentor": mentorHealth,
            "validation": validationHealth
        ]
        
        // Calculate overall health
        let healthValues = componentHealth.values.map { $0.score }
        overallHealth = healthValues.isEmpty ? 0.0 : healthValues.reduce(0, +) / Double(healthValues.count)
        
        // Update timing
        lastHealthCheck = Date()
        
        // Add to history
        let snapshot = HealthSnapshot(
            timestamp: lastHealthCheck,
            overallHealth: overallHealth,
            componentHealth: componentHealth,
            checkDuration: Date().timeIntervalSince(startTime)
        )
        
        healthHistory.append(snapshot)
        
        // Limit history size
        if healthHistory.count > maxHistoryEntries {
            healthHistory.removeFirst(healthHistory.count - maxHistoryEntries)
        }
        
        let healthPercentage = String(format: "%.1f%%", overallHealth * 100)
        print("✅ Health check completed - Overall: \(healthPercentage)")
        
        // Handle critical health issues
        if overallHealth < 0.5 {
            await handleCriticalHealthIssue()
        }
    }

    // MARK: - Component Health Checks

    private func checkMemoryHealth() async -> ComponentHealth {
        let health = memoryArchitecture.memoryHealth
        let score = health.overallHealth
        
        return ComponentHealth(
            score: score,
            status: score > 0.8 ? .healthy : score > 0.5 ? .degraded : .unhealthy,
            lastCheck: Date(),
            details: [
                "shortTerm": String(format: "%.2f", health.shortTerm.healthScore),
                "entityBound": String(format: "%.2f", health.entityBound.healthScore),
                "relation": String(format: "%.2f", health.relation.healthScore),
                "collective": String(format: "%.2f", health.collective.healthScore)
            ]
        )
    }

    private func checkNeuroMeshHealth() async -> ComponentHealth {
        let health = neuroMeshMemory.systemHealth
        let score = health.overallHealth
        
        return ComponentHealth(
            score: score,
            status: score > 0.8 ? .healthy : score > 0.5 ? .degraded : .unhealthy,
            lastCheck: Date(),
            details: [
                "entityLayer": String(format: "%.2f", health.entityLayer.healthScore),
                "relationLayer": String(format: "%.2f", health.relationLayer.healthScore),
                "collectiveLayer": String(format: "%.2f", health.collectiveLayer.healthScore),
                "ethicsCompliance": String(format: "%.2f", health.ethicsCompliance)
            ]
        )
    }

    private func checkCoralHealth() async -> ComponentHealth {
        let health = coralEngine.systemHealth
        let score = health.overallHealth
        
        return ComponentHealth(
            score: score,
            status: score > 0.8 ? .healthy : score > 0.5 ? .degraded : .unhealthy,
            lastCheck: Date(),
            details: [
                "nodeHealth": String(format: "%.2f", health.nodeHealth),
                "loadDistribution": String(format: "%.2f", health.loadDistribution),
                "swarmCoherence": String(format: "%.2f", health.swarmCoherence),
                "totalNodes": String(health.totalNodes)
            ]
        )
    }

    private func checkResonanceHealth() async -> ComponentHealth {
        let ecosystemHealth = resonanceRadar.ecosystemHealth
        let score = ecosystemHealth.overallScore
        
        return ComponentHealth(
            score: score,
            status: score > 0.8 ? .healthy : score > 0.5 ? .degraded : .unhealthy,
            lastCheck: Date(),
            details: [
                "resonanceMapSize": String(resonanceRadar.resonanceMap.count),
                "feedbackLoops": String(resonanceRadar.feedbackLoops.count),
                "activeAgents": String(resonanceRadar.pingMap.values.filter { $0.isActive }.count)
            ]
        )
    }

    private func checkMentorHealth() async -> ComponentHealth {
        let mentorCount = mentorRegistry.registeredMentors.count
        let pairingCount = mentorRegistry.activePairings.count
        let score = mentorCount > 0 ? min(1.0, Double(pairingCount) / Double(mentorCount)) : 0.0
        
        return ComponentHealth(
            score: score,
            status: score > 0.8 ? .healthy : score > 0.5 ? .degraded : .unhealthy,
            lastCheck: Date(),
            details: [
                "registeredMentors": String(mentorCount),
                "activePairings": String(pairingCount),
                "pairingRatio": String(format: "%.2f", score)
            ]
        )
    }

    private func checkValidationHealth() async -> ComponentHealth {
        let validator = ecosystemValidator
        let score = validator.overallValidationScore
        
        return ComponentHealth(
            score: score,
            status: score > 0.8 ? .healthy : score > 0.5 ? .degraded : .unhealthy,
            lastCheck: Date(),
            details: [
                "validationResults": String(validator.validationResults.count),
                "criticalIssues": String(validator.criticalIssuesCount)
            ]
        )
    }

    // MARK: - Health Monitoring Setup

    private func setupHealthMonitoring() {
        // Monitor for component state changes
        Publishers.CombineLatest4(
            memoryArchitecture.$memoryHealth,
            neuroMeshMemory.$systemHealth,
            coralEngine.$systemHealth,
            resonanceRadar.$ecosystemHealth
        )
        .debounce(for: .seconds(1), scheduler: RunLoop.main)
        .sink { [weak self] _, _, _, _ in
            Task { @MainActor in
                await self?.performHealthCheck()
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - Critical Health Handling

    private func handleCriticalHealthIssue() async {
        print("🚨 CRITICAL: Ecosystem health below 50%!")
        
        // Identify the most problematic components
        let unhealthyComponents = componentHealth.filter { $0.value.status == .unhealthy }
        
        for (component, health) in unhealthyComponents {
            print("🚨 Component '\(component)' is unhealthy (score: \(String(format: "%.2f", health.score)))")
            
            // Attempt automated recovery
            await attemptComponentRecovery(component: component)
        }
        
        // Send critical health notification
        NotificationCenter.default.post(
            name: .ecosystemCriticalHealth,
            object: self,
            userInfo: [
                "overallHealth": overallHealth,
                "unhealthyComponents": unhealthyComponents.keys.joined(separator: ", ")
            ]
        )
    }

    private func attemptComponentRecovery(component: String) async {
        print("🔧 Attempting recovery for component: \(component)")
        
        switch component {
        case "memory":
            // Trigger memory cleanup
            await memoryArchitecture.clearMemory(for: .all, condition: .lowHealth)
        case "coral":
            // Trigger coral self-healing
            coralEngine.startSelfHealingProcess()
        case "neuromesh":
            // Trigger neuromesh optimization
            await neuroMeshMemory.triggerSelfReflection(for: "system", trigger: .performanceDegradation)
        default:
            print("⚠️ No automated recovery available for component: \(component)")
        }
    }
}

// MARK: - Supporting Types

struct ComponentHealth {
    let score: Double
    let status: HealthStatus
    let lastCheck: Date
    let details: [String: String]
}

enum HealthStatus {
    case healthy
    case degraded
    case unhealthy
    
    var description: String {
        switch self {
        case .healthy: return "Healthy"
        case .degraded: return "Degraded"
        case .unhealthy: return "Unhealthy"
        }
    }
    
    var color: Color {
        switch self {
        case .healthy: return .green
        case .degraded: return .orange
        case .unhealthy: return .red
        }
    }
}

struct HealthSnapshot {
    let timestamp: Date
    let overallHealth: Double
    let componentHealth: [String: ComponentHealth]
    let checkDuration: TimeInterval
}

// MARK: - Notification Extensions

extension Notification.Name {
    static let ecosystemCriticalHealth = Notification.Name("ecosystemCriticalHealth")
}
