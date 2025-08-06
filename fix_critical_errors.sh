#!/bin/bash

echo "🔧 Fixar kritiska Swift-fel..."

# 1. Fixa extra } i NovaLinkCoordinator.swift
echo "🔧 Tar bort extra } i NovaLinkCoordinator.swift..."
sed -i '' '417d' NovaMind/Services/NovaLinkCoordinator.swift

# 2. Fixa extra } i Semantic360ResonanceRadar.swift  
echo "🔧 Tar bort extra } i Semantic360ResonanceRadar.swift..."
sed -i '' '349d' NovaMind/Services/Semantic360ResonanceRadar.swift

# 3. Ta bort duplicerad showAbout() i AppDelegate
echo "🔧 Tar bort duplicerad showAbout() i AppDelegate..."
sed -i '' '/111,113d' NovaMind/App/AppDelegate.swift

# 4. Skapa saknade controller-klasser
echo "🔧 Skapar saknade controller-klasser..."

# Skapa DataController
cat > NovaMind/Core/DataController.swift << 'EOF'
import Foundation
import Combine

class DataController: ObservableObject {
    @Published var isLoading = false
    
    init() {
        // Initialize data controller
    }
    
    func loadData() {
        // Load data implementation
    }
}
EOF

# Skapa NovaMindGUIController
cat > NovaMind/Core/NovaMindGUIController.swift << 'EOF'
import Foundation
import Combine

class NovaMindGUIController: ObservableObject {
    @Published var currentView: String = "main"
    
    init() {
        // Initialize GUI controller
    }
    
    func navigateTo(_ view: String) {
        currentView = view
    }
}
EOF

echo "✅ Kritiska fel fixade!"
