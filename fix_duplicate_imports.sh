#!/bin/bash

# Script to fix all duplicate import statements in Swift files

echo "Fixing duplicate imports across the codebase..."

# Fix SwiftUI SwiftUI duplicates
find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f -exec sed -i '' 's/import SwiftUI SwiftUI/import SwiftUI/g' {} \;

# Fix Foundation Foundation duplicates
find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f -exec sed -i '' 's/import Foundation Foundation/import Foundation/g' {} \;

# Fix Combine Combine duplicates
find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f -exec sed -i '' 's/import Combine Combine/import Combine/g' {} \;

# Fix any other common duplicate imports
find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f -exec sed -i '' 's/import UIKit UIKit/import UIKit/g' {} \;
find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f -exec sed -i '' 's/import AppKit AppKit/import AppKit/g' {} \;
find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f -exec sed -i '' 's/import CoreData CoreData/import CoreData/g' {} \;
find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f -exec sed -i '' 's/import CoreML CoreML/import CoreML/g' {} \;

echo "Duplicate import fixes completed!"

# Now let's organize imports alphabetically and remove true duplicates within files
echo "Organizing and deduplicating imports within files..."

find "/Users/kristoffersodersten/NovaMind" -name "*.swift" -type f | while read -r file; do
    # Create a temporary file to store the processed content
    temp_file=$(mktemp)
    
    # Extract import lines, sort them, and remove duplicates
    import_lines=$(grep "^import " "$file" | sort -u)
    
    # Extract non-import lines
    non_import_lines=$(grep -v "^import " "$file")
    
    # Combine them back together
    {
        echo "$import_lines"
        echo
        echo "$non_import_lines"
    } > "$temp_file"
    
    # Replace the original file with the processed content
    mv "$temp_file" "$file"
done

echo "Import organization completed!"
