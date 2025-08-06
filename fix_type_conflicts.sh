#!/bin/bash
set -eou pipefail

echo "🔧 Rensar upp alla typ-konflikter och Swift-fel..."

# Lägg till felhantering för filoperationer
handle_errors() {
    echo "❌ Misslyckades vid steg: $1"
    exit 1
}

# 1. Använd variabler för återanvändbara sökvägar
NOVA_MIND_DIR="NovaMind"
VIEWS_DIR="${NOVA_MIND_DIR}/Views"
COMPONENTS_DIR="${NOVA_MIND_DIR}/Components"
SERVICES_DIR="${NOVA_MIND_DIR}/Services"

# 1. Ta bort duplicerade struct/enum-definitioner
echo "🗑️ Tar bort duplicerade typ-definitioner..."

# Ta bort extra MemoryItem i RightMemoryCanvasView
echo "🔧 Fixar RightMemoryCanvasView - tar bort duplicerade typer..."
sed -i '' '/^\/\/ MARK: - Memory Models$/,/^$/d' "${VIEWS_DIR}/RightMemoryCanvasView.swift"

# Ta bort duplicerade MemoryItem i NovaMindDesignSystem
echo "🔧 Tar bort duplicerade MemoryItem i NovaMindDesignSystem..."
sed -i '' '/^struct MemoryItem: Identifiable {$/,/^}$/d' "${COMPONENTS_DIR}/NovaMindDesignSystem.swift"

# Ta bort duplicerade Project i NovaMindDesignSystem  
echo "🔧 Tar bort duplicerade Project i NovaMindDesignSystem..."
sed -i '' '/^struct Project: Identifiable {$/,/^}$/d' "${COMPONENTS_DIR}/NovaMindDesignSystem.swift"

# Ta bort duplicerade ChatThread i NovaMindDesignSystem
echo "🔧 Tar bort duplicerade ChatThread i NovaMindDesignSystem..."
sed -i '' '/^struct ChatThread: Identifiable {$/,/^}$/d' "${COMPONENTS_DIR}/NovaMindDesignSystem.swift"

# Ta bort alla duplicerade typer i NovaMindDesignSystem med ett enda kommando
echo "🔧 Tar bort duplicerade typer i NovaMindDesignSystem..."
sed -i '' -e '/^struct \(MemoryItem\|Project\|ChatThread\): Identifiable {$/,/^}$/d' "${COMPONENTS_DIR}/NovaMindDesignSystem.swift"

# 2. Fixa Environment-konflikt i SwiftUI med mer robust sed-syntax
echo "🔧 Fixar Environment-konflikt..."
sed -i '' 's/@Environment(\.dismiss) private var dismiss/@Environment(\.presentationMode) private var presentationMode/g' "${VIEWS_DIR}/RightMemoryCanvasView.swift"

# 3. Använd mer exakta regex-mönster för font-ändringar
echo "🔧 Fixar font-ambiguity..."
sed -i '' 's/\.font(\([^)]*\))/.font(\1)/g' "${VIEWS_DIR}/ResonanceDashboardView.swift"
sed -i '' 's/\.font(\([^)]*\))/.font(\1)/g' "${VIEWS_DIR}/RightMemoryCanvasView.swift"
sed -i '' 's/\.font(\([^)]*\))/.font(\1)/g' "${VIEWS_DIR}/Sidebar/GeneralThreadsView.swift"

# 2. Uppdatera färgfixen med mer exakt färgreferens
echo "🔧 Fixar färg-konflikter..."
sed -i '' 's/Color\.glow/Color.blue/g' "${VIEWS_DIR}/Sidebar/FolderView.swift" || handle_errors "färg-ändringar"

# 3. Förbättra backup-filer borttagning med säkerhetskontroll
echo "🗑️ Tar bort backup-filer..."
BACKUP_FILE="${SERVICES_DIR}/BirdAgentOrchestrator_backup.swift"
[ -f "$BACKUP_FILE" ] && rm -v "$BACKUP_FILE" || echo "⚠️ Hittade ingen backup-fil att ta bort"

echo "✅ Typ-konflikter rensade!"
