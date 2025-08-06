#!/bin/bash

echo "🔧 Fixar Swift-kompileringsfel..."

# 1. Fixa unterminated comment i MemoryIntegrationExample.swift
echo "🔧 Fixar unterminated comment i MemoryIntegrationExample.swift..."
sed -i '' '401s/Collective: ✅/Collective: ✅\n*\//' NovaMind/Core/MemoryIntegrationExample.swift

# 2. Ta bort extra } i NeuroMeshIntegrationProcessors.swift 
echo "🔧 Tar bort extra } i NeuroMeshIntegrationProcessors.swift..."
sed -i '' '434d' NovaMind/NeuroMesh/NeuroMeshIntegrationProcessors.swift

# 3. Fixa dubbel import i APIConfig.swift
echo "🔧 Fixar dubbel import i APIConfig.swift..."
sed -i '' 's/import OSLog OSLog/import OSLog/' NovaMind/Services/APIConfig.swift

# 4. Ta bort NovaMindKit import (ej tillgänglig modul)
echo "🔧 Tar bort NovaMindKit import..."
sed -i '' '/import NovaMindKit/d' NovaMind/Services/NeuromeshIntegration.swift

# 5. Fixa EnhancedMemoryArchitecture_original.swift - lägg till saknad }
echo "🔧 Fixar missing } i EnhancedMemoryArchitecture_original.swift..."
echo "}" >> NovaMind/Core/EnhancedMemoryArchitecture_original.swift

echo "✅ Fel fixade! Testar kompilering igen..."
