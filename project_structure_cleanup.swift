import Foundation

#!/usr/bin/env swift


// MARK: - Project Structure Cleanup Script

struct ProjectCleanup {
    private let workspaceURL: URL
    private let fileManager = FileManager.default
    
    init(workspacePath: String) {
        self.workspaceURL = URL(fileURLWithPath: workspacePath)
    }
    
    func cleanup() {
        print("🚀 Starting NovaMind Project Structure Cleanup...")
        
        // 1. Remove duplicated files
        removeDuplicatedFiles()
        
        // 2. Create clean project structure
        createCleanStructure()
        
        // 3. Move files to correct locations
        moveFilesToCorrectLocations()
        
        // 4. Clean up empty directories
        removeEmptyDirectories()
        
        print("✅ Project cleanup completed!")
    }
    
    // MARK: - Remove Duplicated Files
    private func removeDuplicatedFiles() {
        print("📂 Removing duplicated files...")
        
        let duplicates: [String: [String]] = [
            "OptimizedAppDelegate.swift": [
                "./NovaMind/Views/Components/OptimizedAppDelegate.swift",
                "./NovaMind/Views/OptimizedAppDelegate.swift", 
                "./Views/Components/OptimizedAppDelegate.swift",
                "./Views/OptimizedAppDelegate.swift"
                // Keep: ./NovaMind/App/OptimizedAppDelegate.swift
            ],
            "ProjectActionFormatters.swift": [
                "./NovaMind/Views/Components/ProjectActionFormatters.swift",
                "./UIComponents/ProjectActionFormatters.swift",
                "./Views/Components/ProjectActionFormatters.swift"
                // Keep: ./NovaMind/Components/ProjectActionFormatters.swift
            ],
            "NovaMindEcosystemTypes.swift": [
                "./Core/NovaMindEcosystemTypes.swift"
                // Keep: ./NovaMind/Core/NovaMindEcosystemTypes.swift
            ],
            "NovaMindSystemValidator.swift": [
                "./Core/NovaMindSystemValidator.swift"
                // Keep: ./NovaMind/Core/NovaMindSystemValidator.swift
            ]
        ]
        
        for (fileName, filesToRemove) in duplicates {
            print("  Cleaning \(fileName)...")
            for filePath in filesToRemove {
                let fullPath = workspaceURL.appendingPathComponent(filePath.replacingOccurrences(of: "./", with: ""))
                if fileManager.fileExists(atPath: fullPath.path) {
                    try? fileManager.removeItem(at: fullPath)
                    print("    ❌ Removed: \(filePath)")
                }
            }
        }
    }
    
    // MARK: - Create Clean Structure
    private func createCleanStructure() {
        print("🏗️ Creating clean project structure...")
        
        let directories = [
            "NovaMind/App",
            "NovaMind/Views",
            "NovaMind/Components", 
            "NovaMind/Core",
            "NovaMind/NeuroMesh",
            "NovaMind/Models",
            "NovaMind/Services",
            "NovaMind/Infrastructure",
            "NovaMind/Realtime",
            "NovaMindTests",
            "Resources"
        ]
        
        for directory in directories {
            let dirURL = workspaceURL.appendingPathComponent(directory)
            if !fileManager.fileExists(atPath: dirURL.path) {
                try? fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
                print("  ✅ Created: \(directory)")
            }
        }
    }
    
    // MARK: - Move Files to Correct Locations
    private func moveFilesToCorrectLocations() {
        print("📁 Moving files to correct locations...")
        
        // Move Services files
        moveDirectory(from: "Services", to: "NovaMind/Services")
        
        // Move Infrastructure files  
        moveDirectory(from: "Infrastructure", to: "NovaMind/Infrastructure")
        
        // Move Realtime files
        moveDirectory(from: "Realtime", to: "NovaMind/Realtime")
        
        // Move Models files
        moveDirectory(from: "Models", to: "NovaMind/Models")
        
        // Move remaining individual files
        let fileMovements: [String: String] = [
            "Info.plist": "NovaMind/Info.plist",
            "NovaMind.entitlements": "NovaMind/NovaMind.entitlements"
        ]
        
        for (source, destination) in fileMovements {
            moveFile(from: source, to: destination)
        }
    }
    
    // MARK: - Helper Methods
    private func moveDirectory(from source: String, to destination: String) {
        let sourceURL = workspaceURL.appendingPathComponent(source)
        let destinationURL = workspaceURL.appendingPathComponent(destination)
        
        if fileManager.fileExists(atPath: sourceURL.path) {
            // Remove destination if exists
            if fileManager.fileExists(atPath: destinationURL.path) {
                try? fileManager.removeItem(at: destinationURL)
            }
            
            do {
                try fileManager.moveItem(at: sourceURL, to: destinationURL)
                print("  📂 Moved directory: \(source) → \(destination)")
            } catch {
                print("  ❌ Failed to move \(source): \(error)")
            }
        }
    }
    
    private func moveFile(from source: String, to destination: String) {
        let sourceURL = workspaceURL.appendingPathComponent(source)
        let destinationURL = workspaceURL.appendingPathComponent(destination)
        
        if fileManager.fileExists(atPath: sourceURL.path) {
            // Remove destination if exists
            if fileManager.fileExists(atPath: destinationURL.path) {
                try? fileManager.removeItem(at: destinationURL)
            }
            
            do {
                try fileManager.moveItem(at: sourceURL, to: destinationURL)
                print("  📄 Moved file: \(source) → \(destination)")
            } catch {
                print("  ❌ Failed to move \(source): \(error)")
            }
        }
    }
    
    private func removeEmptyDirectories() {
        print("🧹 Removing empty directories...")
        
        let dirsToCheck = ["Views", "UIComponents", "Core", "Models", "Services", "Infrastructure", "Realtime"]
        
        for dir in dirsToCheck {
            let dirURL = workspaceURL.appendingPathComponent(dir)
            if fileManager.fileExists(atPath: dirURL.path) {
                do {
                    let contents = try fileManager.contentsOfDirectory(atPath: dirURL.path)
                    if contents.isEmpty {
                        try fileManager.removeItem(at: dirURL)
                        print("  🗑️ Removed empty directory: \(dir)")
                    }
                } catch {
                    print("  ❌ Error checking \(dir): \(error)")
                }
            }
        }
    }
}

// MARK: - Main Execution
let cleanup = ProjectCleanup(workspacePath: "/Users/kristoffersodersten/NovaMind")
cleanup.cleanup()
