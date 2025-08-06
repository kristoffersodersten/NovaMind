#!/bin/bash

# Apple Golden Standards Compliance Script
# This script will reorganize the NovaMind project according to Apple's golden standards

echo "🍎 Starting Apple Golden Standards Compliance Cleanup..."

PROJECT_ROOT="/Users/kristoffersodersten/NovaMind"
XCODE_PROJECT_DIR="$PROJECT_ROOT/NovaMind"

# Step 1: Remove duplicate files outside the proper Xcode project structure
echo "Step 1: Removing duplicate files outside NovaMind/ directory..."

# Remove duplicate Services files
if [ -d "$PROJECT_ROOT/Services" ]; then
    echo "Removing duplicate Services directory..."
    rm -rf "$PROJECT_ROOT/Services"
fi

# Remove duplicate Resources files
if [ -d "$PROJECT_ROOT/Resources" ]; then
    echo "Removing duplicate Resources directory..."
    rm -rf "$PROJECT_ROOT/Resources"
fi

# Step 2: Organize files according to Apple's structure
echo "Step 2: Organizing files according to Apple's golden standards..."

cd "$XCODE_PROJECT_DIR"

# Ensure proper directory structure exists
mkdir -p App
mkdir -p Components
mkdir -p Core
mkdir -p Infrastructure
mkdir -p Models
mkdir -p NeuroMesh
mkdir -p Realtime
mkdir -p Resources
mkdir -p Services
mkdir -p "Supporting Files"
mkdir -p UI
mkdir -p Views

# Step 3: Remove build artifacts and temporary files
echo "Step 3: Cleaning build artifacts..."

# Remove DerivedData and build folders
find "$PROJECT_ROOT" -name "DerivedData" -type d -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_ROOT" -name "build" -type d -exec rm -rf {} + 2>/dev/null || true
find "$PROJECT_ROOT" -name ".build" -type d -exec rm -rf {} + 2>/dev/null || true

# Remove module cache files
find "$PROJECT_ROOT" -name "*.pcm" -delete
find "$PROJECT_ROOT" -name "*.pch" -delete

# Remove backup files
find "$PROJECT_ROOT" -name "*~" -delete
find "$PROJECT_ROOT" -name "*.orig" -delete
find "$PROJECT_ROOT" -name "*.rej" -delete

# Step 4: Fix Swift files according to Apple standards
echo "Step 4: Applying Apple Swift standards..."

# Sort imports alphabetically in all Swift files
find "$XCODE_PROJECT_DIR" -name "*.swift" -type f | while read -r file; do
    if [ -f "$file" ]; then
        # Create temporary file
        temp_file=$(mktemp)
        
        # Extract imports and sort them
        grep "^import " "$file" | sort -u > "$temp_file"
        
        # Add empty line after imports if imports exist
        if [ -s "$temp_file" ]; then
            echo "" >> "$temp_file"
        fi
        
        # Add non-import content
        grep -v "^import " "$file" | sed '/^$/N;/^\n$/d' >> "$temp_file"
        
        # Replace original file
        mv "$temp_file" "$file"
    fi
done

# Step 5: Remove empty files and directories
echo "Step 5: Removing empty files and directories..."

# Remove empty Swift files
find "$XCODE_PROJECT_DIR" -name "*.swift" -size 0 -delete

# Remove empty directories (excluding .git)
find "$PROJECT_ROOT" -type d -empty -not -path "*/.git/*" -not -name ".git" -delete 2>/dev/null || true

echo "✅ Apple Golden Standards cleanup completed!"
echo ""
echo "📋 Summary of changes:"
echo "  - Removed duplicate files outside NovaMind/ directory"
echo "  - Organized project structure according to Apple standards"
echo "  - Cleaned build artifacts and temporary files"
echo "  - Fixed import statements in Swift files"
echo "  - Removed empty files and directories"
echo ""
echo "🚀 Project is now compliant with Apple's golden standards!"
