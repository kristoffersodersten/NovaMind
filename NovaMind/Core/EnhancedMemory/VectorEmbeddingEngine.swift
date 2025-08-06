import Foundation
import Combine

// MARK: - Vector Embedding Engine

/// Vector Embedding Engine for semantic operations
class VectorEmbeddingEngine: ObservableObject {
    private let config: VectorConfig
    private var modelCache: [String: (data: Any, timestamp: Date)] = [:]
    private let maxCacheSize = 1000
    private let cacheExpiryInterval: TimeInterval = 3600 // 1 hour

    init(config: VectorConfig) {
        self.config = config
        setupCacheCleanup()
    }

    private func setupCacheCleanup() {
        Timer.scheduledTimer(withTimeInterval: cacheExpiryInterval, repeats: true) { [weak self] _ in
            self?.cleanupExpiredCache()
        }
    }

    private func cleanupExpiredCache() {
        let now = Date()
        let expiredKeys = modelCache.compactMap { key, value in
            now.timeIntervalSince(value.timestamp) > cacheExpiryInterval ? key : nil
        }
        
        for key in expiredKeys {
            modelCache.removeValue(forKey: key)
        }
        
        // LRU cleanup if still over limit
        if modelCache.count > maxCacheSize {
            let sortedByTimestamp = modelCache.sorted { $0.value.timestamp < $1.value.timestamp }
            let keysToRemove = sortedByTimestamp.prefix(modelCache.count - maxCacheSize).map { $0.key }
            for key in keysToRemove {
                modelCache.removeValue(forKey: key)
            }
        }
    }

    deinit {
        modelCache.removeAll()
    }

    func generateEmbeddings(for text: String, model: String) async throws -> [Double] {
        // In production, this would call the actual embedding model
        // For now, we'll simulate with random vectors of correct dimensionality
        let dimensions = config.dimensions
        return Array(repeating: 0, count: dimensions).map { _ in Double.random(in: -1...1) }
    }

    func getHealth() async -> ComponentHealth {
        return ComponentHealth(
            isHealthy: true,
            lastCheck: Date(),
            metrics: [
                "model_cache_size": Double(modelCache.count),
                "embedding_dimensions": Double(config.dimensions)
            ]
        )
    }

    func getPerformanceMetrics() async -> VectorPerformanceMetrics {
        return VectorPerformanceMetrics(
            embeddingsGenerated: 100,
            averageGenerationTime: 0.1,
            cacheHitRate: 0.8
        )
    }
}

// MARK: - Supporting Types

struct VectorPerformanceMetrics {
    let embeddingsGenerated: Int
    let averageGenerationTime: TimeInterval
    let cacheHitRate: Double
}
