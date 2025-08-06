import Foundation
import SwiftUI


// MARK: - Mentor Registry for Multi-Agent Ecosystem

/// Manages mentor-agent relationships and resonance tracking
@MainActor
class MentorRegistry: ObservableObject {
    static let shared = MentorRegistry()

    @Published var registeredMentors: [AgentMentor] = []
    @Published var activePairings: [MentorAgentPairing] = []
    @Published var resonanceHistory: [ResonanceEvent] = []

    private let resonanceRadar = AgentResonanceRadar.shared
    private var reflectionTimer: Timer?

    // MARK: - Initialization

    private init() {
        setupDefaultMentors()
        startResonanceMonitoring()
    }

    // MARK: - Mentor Registration

    func registerMentor(id: String, traits: [MentorTrait], specialty: AgentSpecialty) {
        let mentor = AgentMentor(
            id: id,
            traits: traits,
            specialty: specialty,
            registrationDate: Date(),
            performanceMetrics: MentorPerformanceMetrics()
        )

        registeredMentors.append(mentor)

        // Log registration for resonance tracking
        let event = ResonanceEvent(
            type: .mentorRegistration,
            mentorId: id,
            timestamp: Date(),
            resonanceScore: 1.0
        )
        resonanceHistory.append(event)
    }

    func createPairing(mentorId: String, agentId: String) -> MentorAgentPairing? {
        guard let mentor = registeredMentors.first(where: { $0.id == mentorId }) else {
            return nil
        }

        let pairing = MentorAgentPairing(
            id: UUID().uuidString,
            mentorId: mentorId,
            agentId: agentId,
            createdAt: Date(),
            resonanceScore: 0.0,
            reflectionLog: []
        )

        activePairings.append(pairing)
        resonanceRadar.startTracking(pairing: pairing)

        return pairing
    }

    // MARK: - Reflection Logging

    func logReflection(pairingId: String, reflection: MentorReflection) {
        guard let index = activePairings.firstIndex(where: { $0.id == pairingId }) else {
            return
        }

        activePairings[index].reflectionLog.append(reflection)

        // Update resonance score based on reflection quality
        let qualityScore = calculateReflectionQuality(reflection)
        activePairings[index].resonanceScore = (activePairings[index].resonanceScore + qualityScore) / 2.0

        // Check for performance drift
        detectPerformanceDrift(pairingId: pairingId)
    }

    // MARK: - Performance Drift Detection

    private func detectPerformanceDrift(pairingId: String) {
        guard let pairing = activePairings.first(where: { $0.id == pairingId }) else {
            return
        }

        let recentReflections = Array(pairing.reflectionLog.suffix(5))
        let averageQuality = recentReflections.map { calculateReflectionQuality($0) }.reduce(0, +) / Double(recentReflections.count)

        if averageQuality < 0.7 { // Drift threshold
            injectMemoryCorrection(pairingId: pairingId, driftLevel: 1.0 - averageQuality)
        }
    }

    private func injectMemoryCorrection(pairingId: String, driftLevel: Double) {
        // Memory injection to correct performance drift
        let correctionMemory = MemoryItem(
            title: "Performance Correction",
            content: "Agent performance drift detected. Injecting corrective guidance with drift level: \(driftLevel)",
            tags: ["performance", "correction", "mentor"],
            isImportant: true,
            memoryType: .midTerm
        )

        // Inject to memory system (assuming MemoryCanvasView integration)
        NotificationCenter.default.post(
            name: .memoryInjectionRequired,
            object: correctionMemory,
            userInfo: ["pairingId": pairingId]
        )
    }

    // MARK: - Private Methods

    private func setupDefaultMentors() {
        // Register core mentors for the ecosystem
        registerMentor(
            id: "deepseek-mentor",
            traits: [.analytical, .codeOptimized, .resourceEfficient],
            specialty: .codeGeneration
        )

        registerMentor(
            id: "claude-mentor",
            traits: [.creative, .contextuallyAware, .ethicallyGuided],
            specialty: .reasoning
        )

        registerMentor(
            id: "phi-mentor",
            traits: [.compact, .efficient, .localOptimized],
            specialty: .lightweightProcessing
        )
    }

    private func startResonanceMonitoring() {
        reflectionTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.performPeriodicResonanceCheck()
        }
    }

    private func performPeriodicResonanceCheck() {
        for pairing in activePairings {
            let currentResonance = resonanceRadar.measureResonance(for: pairing)

            if let index = activePairings.firstIndex(where: { $0.id == pairing.id }) {
                activePairings[index].resonanceScore = currentResonance
            }

            let event = ResonanceEvent(
                type: .periodicCheck,
                mentorId: pairing.mentorId,
                agentId: pairing.agentId,
                timestamp: Date(),
                resonanceScore: currentResonance
            )
            resonanceHistory.append(event)
        }
    }

    private func calculateReflectionQuality(_ reflection: MentorReflection) -> Double {
        // Calculate quality based on reflection content and effectiveness
        let lengthScore = min(Double(reflection.content.count) / 500.0, 1.0)
        let keywordScore = reflection.insights.count > 0 ? 1.0 : 0.5
        let actionScore = reflection.recommendedActions.count > 0 ? 1.0 : 0.5

        return (lengthScore + keywordScore + actionScore) / 3.0
    }
}

// MARK: - Supporting Types

struct AgentMentor: Identifiable, Codable {
    let id: String
    let traits: [MentorTrait]
    let specialty: AgentSpecialty
    let registrationDate: Date
    var performanceMetrics: MentorPerformanceMetrics
}

struct MentorAgentPairing: Identifiable, Codable {
    let id: String
    let mentorId: String
    let agentId: String
    let createdAt: Date
    var resonanceScore: Double
    var reflectionLog: [MentorReflection]
}

struct MentorReflection: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let content: String
    let insights: [String]
    let recommendedActions: [String]
    let effectivenessScore: Double

    init(content: String, insights: [String] = [], recommendedActions: [String] = [], effectivenessScore: Double = 0.0) {
        self.timestamp = Date()
        self.content = content
        self.insights = insights
        self.recommendedActions = recommendedActions
        self.effectivenessScore = effectivenessScore
    }
}

struct MentorPerformanceMetrics: Codable {
    var totalReflections: Int = 0
    var averageEffectiveness: Double = 0.0
    var driftCorrections: Int = 0
    var successfulPairings: Int = 0
}

struct ResonanceEvent: Identifiable, Codable {
    let id = UUID()
    let type: ResonanceEventType
    let mentorId: String
    let agentId: String?
    let timestamp: Date
    let resonanceScore: Double

    init(type: ResonanceEventType, mentorId: String, agentId: String? = nil, timestamp: Date, resonanceScore: Double) {
        self.type = type
        self.mentorId = mentorId
        self.agentId = agentId
        self.timestamp = timestamp
        self.resonanceScore = resonanceScore
    }
}

enum MentorTrait: String, CaseIterable, Codable {
    case analytical
    case creative
    case codeOptimized
    case resourceEfficient
    case contextuallyAware
    case ethicallyGuided
    case compact
    case efficient
    case localOptimized
}

enum AgentSpecialty: String, CaseIterable, Codable {
    case codeGeneration
    case reasoning
    case lightweightProcessing
    case memoryManagement
    case userInterface
    case systemIntegration
}

enum ResonanceEventType: String, CaseIterable, Codable {
    case mentorRegistration
    case pairingCreated
    case periodicCheck
    case driftDetected
    case correctionApplied
}

// MARK: - Notification Names

extension Notification.Name {
    static let memoryInjectionRequired = Notification.Name("memoryInjectionRequired")
}
