import Foundation

// MARK: - Clustering and Machine Learning Utilities

class ClusteringEngine {
    
    func findOptimalClusterCount(_ vectors: [FeatureVector], maxClusters: Int) -> Int {
        // Use elbow method to find optimal k
        var wcss: [Double] = [] // Within-cluster sum of squares
        
        for clusterCount in 1...min(maxClusters, vectors.count) {
            let clusters = performKMeansClustering(vectors, clusterCount: clusterCount)
            let totalWCSS = clusters.map { cluster in
                cluster.points.map { point in
                    distance(point, cluster.centroid)
                }.reduce(0, +)
            }.reduce(0, +)
            wcss.append(totalWCSS)
        }
        
        // Find elbow point
        return findElbowPoint(wcss) + 1
    }
    
    func performKMeansClustering(_ vectors: [FeatureVector], clusterCount: Int) -> [Cluster] {
        guard clusterCount > 0 && !vectors.isEmpty else { return [] }
        
        // Initialize centroids randomly
        var centroids = (0..<clusterCount).map { _ in
            vectors.randomElement() ?? FeatureVector.zero
        }
        
        var clusters: [Cluster] = []
        let maxIterations = 100
        
        for iteration in 0..<maxIterations {
            // Assign points to nearest centroids
            var newClusters: [Cluster] = centroids.map { centroid in
                Cluster(centroid: centroid, points: [])
            }
            
            for vector in vectors {
                let nearestClusterIndex = centroids.enumerated().min { pair1, pair2 in
                    distance(vector, pair1.element) < distance(vector, pair2.element)
                }?.offset ?? 0
                
                newClusters[nearestClusterIndex].points.append(vector)
            }
            
            // Update centroids
            var newCentroids: [FeatureVector] = []
            for cluster in newClusters {
                if cluster.points.isEmpty {
                    newCentroids.append(cluster.centroid)
                } else {
                    let avgAmplitude = cluster.points.map(\.amplitude).reduce(0, +) / Double(cluster.points.count)
                    let avgFrequency = cluster.points.map(\.frequency).reduce(0, +) / Double(cluster.points.count)
                    let avgPhase = cluster.points.map(\.phase).reduce(0, +) / Double(cluster.points.count)
                    let avgDuration = cluster.points.map(\.duration).reduce(0, +) / Double(cluster.points.count)
                    let avgTrend = cluster.points.map(\.trend).reduce(0, +) / Double(cluster.points.count)
                    
                    newCentroids.append(FeatureVector(
                        amplitude: avgAmplitude,
                        frequency: avgFrequency,
                        phase: avgPhase,
                        duration: avgDuration,
                        trend: avgTrend
                    ))
                }
            }
            
            // Check for convergence
            let hasConverged = zip(centroids, newCentroids).allSatisfy { old, new in
                distance(old, new) < 0.001
            }
            
            centroids = newCentroids
            clusters = newClusters
            
            if hasConverged {
                break
            }
        }
        
        return clusters
    }
    
    func calculateClusterStability(_ clusters: [Cluster]) -> [Double] {
        return clusters.map { cluster in
            guard cluster.points.count > 1 else { return 0.0 }
            
            let distances = cluster.points.map { distance($0, cluster.centroid) }
            let meanDistance = distances.reduce(0, +) / Double(distances.count)
            let variance = distances.map { pow($0 - meanDistance, 2) }.reduce(0, +) / Double(distances.count)
            
            // Stability is inverse of coefficient of variation
            return meanDistance > 0 ? 1.0 / (sqrt(variance) / meanDistance) : 0.0
        }
    }
    
    func analyzeClusterCharacteristics(_ clusters: [Cluster]) -> [ClusterCharacteristics] {
        return clusters.map { cluster in
            guard !cluster.points.isEmpty else {
                return ClusterCharacteristics(
                    size: 0,
                    density: 0.0,
                    cohesion: 0.0,
                    separation: 0.0,
                    confidence: 0.0
                )
            }
            
            let size = cluster.points.count
            let distances = cluster.points.map { distance($0, cluster.centroid) }
            let cohesion = distances.reduce(0, +) / Double(distances.count)
            
            return ClusterCharacteristics(
                size: size,
                density: Double(size) / (cohesion + 1.0), // Avoid division by zero
                cohesion: cohesion,
                separation: 1.0 / (cohesion + 1.0), // Simplified separation metric
                confidence: min(1.0, Double(size) / 10.0) // Confidence increases with size
            )
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func distance(_ vector1: FeatureVector, _ vector2: FeatureVector) -> Double {
        let amplitudeDiff = vector1.amplitude - vector2.amplitude
        let frequencyDiff = vector1.frequency - vector2.frequency
        let phaseDiff = vector1.phase - vector2.phase
        let durationDiff = vector1.duration - vector2.duration
        let trendDiff = vector1.trend - vector2.trend
        
        return sqrt(
            amplitudeDiff * amplitudeDiff +
            frequencyDiff * frequencyDiff +
            phaseDiff * phaseDiff +
            durationDiff * durationDiff +
            trendDiff * trendDiff
        )
    }
    
    private func findElbowPoint(_ wcss: [Double]) -> Int {
        guard wcss.count > 2 else { return 0 }
        
        var maxCurvature = 0.0
        var elbowPoint = 1
        
        for index in 1..<(wcss.count - 1) {
            let curvature = wcss[index - 1] - 2 * wcss[index] + wcss[index + 1]
            if curvature > maxCurvature {
                maxCurvature = curvature
                elbowPoint = index
            }
        }
        
        return elbowPoint
    }
}
