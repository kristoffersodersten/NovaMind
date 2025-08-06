import Foundation

#!/usr/bin/env swift


// MARK: - Duplicate Cleanup Script

struct DuplicateCleanup {
    private let workspaceURL = URL(fileURLWithPath: "/Users/kristoffersodersten/NovaMind")
    private let fileManager = FileManager.default
    
    func cleanupDuplicates() {
        print("🧹 Starting duplicate cleanup...")
        
        // Identifierade dubletter baserat på analys
        let duplicateGroups: [String: [String]] = [
            // Views dubletter
            "QuantumEvolutionaryView.swift": [
                "Views/QuantumEvolutionaryView.swift",
                "NovaMind/Views/QuantumEvolutionaryView.swift"
            ],
            
            // Components dubletter
            "ActionButton.swift": [
                "UIComponents/ActionButton.swift", 
                "Views/Components/ActionButton.swift"
            ],
            "BrandIcon.swift": [
                "UIComponents/BrandIcon.swift",
                "Views/DesignSystem/BrandIcon.swift"
            ],
            "CanvasMinimapView.swift": [
                "UIComponents/CanvasMinimapView.swift",
                "Views/CanvasMinimapView.swift",
                "Views/Components/CanvasMinimapView.swift"
            ],
            "MemoryMinimapView.swift": [
                "UIComponents/MemoryMinimapView.swift",
                "Views/Components/MemoryMinimapView.swift"
            ],
            "MessageInputArea.swift": [
                "UIComponents/MessageInputArea.swift",
                "Views/Components/MessageInputArea.swift"
            ],
            "MessageRow.swift": [
                "UIComponents/MessageRow.swift",
                "Views/Components/MessageRow.swift"
            ],
            "MessageRowAttachments.swift": [
                "UIComponents/MessageRowAttachments.swift",
                "Views/Components/MessageRowAttachments.swift"
            ],
            "ModelPicker.swift": [
                "UIComponents/ModelPicker.swift",
                "Views/Components/ModelPicker.swift"
            ],
            "ParallaxElevation.swift": [
                "UIComponents/ParallaxElevation.swift",
                "Views/Components/ParallaxElevation.swift",
                "Theme/ParallaxElevation.swift"
            ],
            "ProjectAction.swift": [
                "UIComponents/ProjectAction.swift",
                "Views/Components/ProjectAction.swift"
            ],
            "ProjectAgentView.swift": [
                "UIComponents/ProjectAgentView.swift",
                "Views/Components/ProjectAgentView.swift"
            ],
            "View+Extensions.swift": [
                "UIComponents/View+Extensions.swift",
                "Views/Components/View+Extensions.swift"
            ],
            
            // Design System dubletter
            "KrilleCoreDesignSystem.swift": [
                "UIComponents/KrilleCoreDesignSystem.swift",
                "Views/DesignSystem/KrilleCoreDesignSystem.swift"
            ],
            "NovaMindDesignSystem.swift": [
                "UIComponents/NovaMindDesignSystem.swift",
                "Views/DesignSystem/NovaMindDesignSystem.swift"
            ],
            
            // Modifier dubletter
            "AISaveGlowModifier.swift": [
                "UIComponents/AISaveGlowModifier.swift",
                "Views/AISaveGlowModifier.swift"
            ],
            "VisualHoverEffect.swift": [
                "UIComponents/VisualHoverEffect.swift",
                "Theme/VisualHoverEffect.swift"
            ],
            
            // Chat dubletter
            "ChatBubble.swift": [
                "UIComponents/ChatBubble.swift",
                "Views/Chat/ChatBubble.swift"
            ],
            
            // Theme dubletter  
            "KrilleStyleDemoView.swift": [
                "Views/KrilleStyleDemoView.swift",
                "Views/DesignSystem/KrilleStyleDemoView.swift"
            ],
            
            // Empty files to remove
            "EmptyFiles": [
                "UIComponents/DragResizableModifier.swift",
                "UIComponents/UserActivityTracker.swift",
                "Views/Components/OptimizedDragResizableModifier.swift",
                "Views/Components/OptimizedInputBarView.swift",
                "Views/Components/OptimizedMainApp.swift",
                "Views/Components/OptimizedMemoryBlockView.swift",
                "Views/Components/TagCloudDemoView.swift",
                "Views/Demo/ColorUsageExamples.swift",
                "Views/Demo/OptimizedColorSystemDemo.swift",
                "Views/Demo/OptimizedGUIDemoView.swift",
                "Views/Demo/OptimizedThemeDemoView.swift",
                "Views/MemoryBlockView.swift",
                "Views/Models/MemoryItem.swift",
                "Views/NovaMainLayout.swift"
            ]
        ]
        
        processDuplicateGroups(duplicateGroups)
        removeEmptyDirectories()
        
        print("✅ Duplicate cleanup completed!")
    }
    
    private func processDuplicateGroups(_ groups: [String: [String]]) {
        for (fileName, paths) in groups {
            if fileName == "EmptyFiles" {
                // Remove empty files
                for path in paths {
                    removeFile(at: path)
                }
                continue
            }
            
            print("\n🔍 Processing \(fileName)...")
            
            // Find the best version (largest non-empty file)
            var bestPath: String?
            var bestSize: Int = 0
            
            for path in paths {
                let fullPath = workspaceURL.appendingPathComponent(path).path
                if fileManager.fileExists(atPath: fullPath) {
                    do {
                        let content = try String(contentsOfFile: fullPath, encoding: .utf8)
                        let size = content.count
                        
                        if size > bestSize && !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            bestSize = size
                            bestPath = path
                        }
                    } catch {
                        print("⚠️ Error reading \(path): \(error)")
                    }
                }
            }
            
            if let best = bestPath {
                print("✅ Keeping best version: \(best) (\(bestSize) chars)")
                
                // Remove other versions
                for path in paths where path != best {
                    removeFile(at: path)
                }
            } else {
                print("⚠️ No valid version found for \(fileName)")
            }
        }
    }
    
    private func removeFile(at path: String) {
        let fullPath = workspaceURL.appendingPathComponent(path).path
        if fileManager.fileExists(atPath: fullPath) {
            do {
                try fileManager.removeItem(atPath: fullPath)
                print("🗑️ Removed: \(path)")
            } catch {
                print("❌ Failed to remove \(path): \(error)")
            }
        }
    }
    
    private func removeEmptyDirectories() {
        print("\n🧹 Removing empty directories...")
        
        let emptyDirCandidates = [
            "Views/Demo",
            "Views/Models", 
            "Views/Chat"
        ]
        
        for dir in emptyDirCandidates {
            let fullPath = workspaceURL.appendingPathComponent(dir).path
            if fileManager.fileExists(atPath: fullPath) {
                do {
                    let contents = try fileManager.contentsOfDirectory(atPath: fullPath)
                    if contents.isEmpty {
                        try fileManager.removeItem(atPath: fullPath)
                        print("🗑️ Removed empty directory: \(dir)")
                    }
                } catch {
                    print("⚠️ Error checking directory \(dir): \(error)")
                }
            }
        }
    }
}

// Run cleanup
let cleanup = DuplicateCleanup()
cleanup.cleanupDuplicates()
