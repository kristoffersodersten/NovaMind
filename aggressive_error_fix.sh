#!/bin/bash

echo "🚀 AGGRESSIVE ERROR ELIMINATION SCRIPT"
echo "======================================="

# Count initial errors
INITIAL_ERRORS=$(swift build 2>&1 | grep "error:" | wc -l | tr -d ' ')
echo "📊 Initial errors: $INITIAL_ERRORS"

echo ""
echo "🔧 Step 1: Fixing font ambiguity issues..."
# Fix .font() ambiguity by using explicit Font.
find NovaMind -name "*.swift" -type f -exec sed -i '' 's/\.font(\./\.font(Font\./g' {} \;
find NovaMind -name "*.swift" -type f -exec sed -i '' 's/\.font(\([^F][^o][^n][^t]\)/\.font(Font\.\1/g' {} \;

# Count after font fixes
FONT_ERRORS=$(swift build 2>&1 | grep "error:" | wc -l | tr -d ' ')
FONT_REDUCTION=$((INITIAL_ERRORS - FONT_ERRORS))
echo "   ✅ Font fixes completed. Reduced by: $FONT_REDUCTION errors"

echo ""
echo "🔧 Step 2: Fixing opacity ambiguity..."
# Fix opacity ambiguity 
find NovaMind -name "*.swift" -type f -exec sed -i '' 's/\.opacity(\([0-9.]*\))/.opacity(\1 as Double)/g' {} \;

echo ""
echo "🔧 Step 3: Removing duplicate extensions..."
# Remove duplicate View extensions that cause conflicts
find NovaMind -name "*.swift" -type f -exec grep -l "extension View" {} \; | while read file; do
    if [[ $(grep -c "extension View" "$file") -gt 1 ]]; then
        echo "   🗑️  Found multiple View extensions in: $file"
        # Keep only the first extension View
        awk '/extension View/{if(++count>1) skip=1} skip && /^}$/{skip=0; next} !skip' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    fi
done

echo ""
echo "🔧 Step 4: Consolidating Color extensions..."
# Remove duplicate Color extensions
find NovaMind -name "*Color*.swift" -type f | head -1 | while read mainFile; do
    echo "   📁 Main color file: $mainFile"
    find NovaMind -name "*Color*.swift" -type f | grep -v "$(basename "$mainFile")" | while read dupFile; do
        echo "   🗑️  Removing duplicate: $dupFile"
        rm "$dupFile" 2>/dev/null || true
    done
done

echo ""
echo "🔧 Step 5: Type annotation fixes..."
# Add explicit type annotations for common ambiguous cases
find NovaMind -name "*.swift" -type f -exec sed -i '' 's/\.frame(width: \([0-9]*\), height: \([0-9]*\))/.frame(width: CGFloat(\1), height: CGFloat(\2))/g' {} \;
find NovaMind -name "*.swift" -type f -exec sed -i '' 's/\.cornerRadius(\([0-9.]*\))/.cornerRadius(CGFloat(\1))/g' {} \;

echo ""
echo "🔧 Step 6: SwiftUI modifier fixes..."
# Fix common SwiftUI modifiers that cause ambiguity
find NovaMind -name "*.swift" -type f -exec sed -i '' 's/\.padding(\([0-9.]*\))/.padding(EdgeInsets(top: \1, leading: \1, bottom: \1, trailing: \1))/g' {} \;

echo ""
echo "📊 Final count..."
FINAL_ERRORS=$(swift build 2>&1 | grep "error:" | wc -l | tr -d ' ')
TOTAL_REDUCTION=$((INITIAL_ERRORS - FINAL_ERRORS))
PERCENTAGE=$(echo "scale=1; $TOTAL_REDUCTION * 100 / $INITIAL_ERRORS" | bc -l)

echo "======================================="
echo "🎯 RESULTS:"
echo "   Initial errors: $INITIAL_ERRORS"
echo "   Final errors:   $FINAL_ERRORS"
echo "   Reduced by:     $TOTAL_REDUCTION ($PERCENTAGE%)"
echo "======================================="

if [ $TOTAL_REDUCTION -gt 1000 ]; then
    echo "🚀 EXCELLENT! Major progress made!"
elif [ $TOTAL_REDUCTION -gt 500 ]; then
    echo "👍 Good progress!"
else
    echo "📈 Some progress, need more targeted fixes"
fi
