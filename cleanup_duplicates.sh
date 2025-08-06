#!/bin/bash

echo "🧹 Rensar upp duplicerade Swift-filer..."

# Lista över filer som har dubbletter
declare -a files=(
    "ChatBubble.swift"
    "ProjectAgentView.swift" 
    "InputBarView.swift"
    "EnhancedMemoryArchitecture.swift"
    "QuantumEvolutionaryComponents.swift"
    "NeuroMeshIntegrationProcessors.swift"
    "NeuroMeshIntegrationTypes.swift"
    "BirdAgentPipelineExecutor.swift"
    "BirdAgentTypes.swift"
)

# Ta bort dubbletter, behåll den som är i bästa platsen
for filename in "${files[@]}"; do
    echo "🔍 Letar efter dubbletter av $filename..."
    
    # Hitta alla kopior av filen och ta bort alla utom en
    locations=($(find . -name "$filename" -type f))
    
    if [ ${#locations[@]} -gt 1 ]; then
        echo "� Hittade ${#locations[@]} kopior:"
        for loc in "${locations[@]}"; do
            echo "   - $loc"
        done
        
        # Behåll den första, ta bort resten
        keep="${locations[0]}"
        echo "✅ Behåller: $keep"
        
        for ((i=1; i<${#locations[@]}; i++)); do
            echo "🗑️  Tar bort dubblett: ${locations[i]}"
            rm "${locations[i]}"
        done
    else
        echo "ℹ️  Inga dubbletter hittades för $filename"
    fi
done

echo "✅ Dubbletter rensade!"
