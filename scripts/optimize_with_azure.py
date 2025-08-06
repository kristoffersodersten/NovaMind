#!/usr/bin/env python3
"""
Azure OpenAI Swift Code Optimizer
Automated Swift code analysis and optimization using GPT-4.1 with Code Interpreter
"""

import os
import sys
import json
import zipfile
from datetime import datetime
from pathlib import Path
from openai import AzureOpenAI

def extract_swift_files(zip_path):
    """Extract Swift files from zip and organize them"""
    extract_path = "swift_extracted"
    os.makedirs(extract_path, exist_ok=True)
    
    print(f"📂 Extracting Swift files from {zip_path}...")
    
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_path)
    
    # Collect all Swift files with metadata
    swift_files = []
    total_lines = 0
    
    for root, _, files in os.walk(extract_path):
        for file in files:
            if file.endswith(".swift"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    lines = len(content.split('\n'))
                    total_lines += lines
                    
                    swift_files.append({
                        'name': file,
                        'path': file_path,
                        'content': content,
                        'lines': lines,
                        'size_category': 'large' if lines > 400 else 'medium' if lines > 200 else 'small'
                    })
    
    print(f"✅ Found {len(swift_files)} Swift files ({total_lines} total lines)")
    return swift_files, total_lines

def create_optimization_prompt(swift_files, total_lines):
    """Create a comprehensive optimization prompt for Azure OpenAI"""
    
    # Categorize files by size
    large_files = [f for f in swift_files if f['lines'] > 400]
    medium_files = [f for f in swift_files if 200 < f['lines'] <= 400]
    small_files = [f for f in swift_files if f['lines'] <= 200]
    
    # Build code payload (limit to prevent token overflow)
    code_sections = []
    included_files = 0
    max_files = 15  # Limit to prevent token overflow
    
    # Prioritize large files for analysis
    for file in (large_files + medium_files + small_files)[:max_files]:
        code_sections.append(f"""
// ===== FILE: {file['name']} ({file['lines']} lines) =====
{file['content']}
""")
        included_files += 1
    
    combined_code = "\n".join(code_sections)
    
    prompt = f"""Du är en expert Swift-utvecklare och kodoptimerare för macOS/iOS-appar. 

PROJEKTÖVERSIKT:
- Totalt {len(swift_files)} Swift-filer ({total_lines} rader kod)
- {len(large_files)} stora filer (>400 rader) 
- {len(medium_files)} medelstora filer (200-400 rader)
- {len(small_files)} små filer (<200 rader)
- Analyserar {included_files} filer i denna körning

OPTIMERINGSMÅL:
1. 🎯 Apple Coding Standards: Håll filer under 400 rader
2. ⚡ Prestanda: Optimera för snabbhet och minnesanvändning
3. 🔋 Energieffektivitet: Minimera batterianvändning
4. 📖 Läsbarhet: Förbättra kodkvalitet och underhållbarhet
5. 🏗️ Arkitektur: Föreslå förbättringar av kodstruktur

ANALYSERA OCH OPTIMERA:

{combined_code}

LEVERERA RESULTAT I FÖLJANDE FORMAT:

## 🎯 Optimeringssammanfattning

### 📊 Kodanalys
- [Sammanfattning av nuvarande tillstånd]

### ⚡ Prestandaförbättringar  
- [Specifika förbättringsförslag]

### 🏗️ Strukturella förändringar
- [Arkitekturförbättringar]

### 🔧 Konkreta åtgärder
- [Prioriterad lista av förändringar]

### 📁 Fildekomponering (för filer >400 rader)
- [Förslag på hur stora filer ska delas upp]

Fokusera på praktiska, implementerbara förbättringar som följer Swift best practices och Apple's riktlinjer."""

    return prompt

def analyze_with_azure_openai(prompt):
    """Send code to Azure OpenAI for analysis"""
    
    print("🧠 Connecting to Azure OpenAI...")
    
    # Initialize Azure OpenAI client
    client = AzureOpenAI(
        api_key=os.getenv("AZURE_OPENAI_API_KEY"),
        api_version="2025-01-01-preview",  # From your endpoint URL
        azure_endpoint="https://krilles.cognitiveservices.azure.com/"  # Base endpoint
    )
    
    # Use gpt-4.1 as the model name
    model_name = "gpt-4.1"
    
    print(f"🚀 Sending Swift code to Azure OpenAI (gpt-4.1)...")
    
    try:
        response = client.chat.completions.create(
            model="gpt-4.1",  # Your deployment name
            messages=[
                {
                    "role": "system", 
                    "content": "Du är en expert Swift-utvecklare som specialiserar sig på kodoptimering för macOS och iOS. Du fokuserar på prestanda, energieffektivitet, läsbarhet och följer Apple's kodstandarder."
                },
                {
                    "role": "user", 
                    "content": prompt
                }
            ],
            max_tokens=4000,
            temperature=0.1  # Low temperature for consistent, focused analysis
        )
        
        return response.choices[0].message.content
        
    except Exception as e:
        error_msg = f"❌ Azure OpenAI Error: {str(e)}"
        print(error_msg)
        return error_msg

def save_results(optimization_result, swift_files, total_lines):
    """Save optimization results to files"""
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")
    
    # Create markdown report
    markdown_report = f"""# 🧠 Azure AI Swift Optimization Report

**Generated:** {timestamp}  
**Trigger:** GitHub Actions Workflow  
**Azure Service:** OpenAI GPT-4.1 with Code Interpreter  

## 📊 Code Analysis Summary

- **Total Files:** {len(swift_files)}
- **Total Lines:** {total_lines:,}
- **Large Files (>400 lines):** {len([f for f in swift_files if f['lines'] > 400])}
- **Optimization Priority:** {'HIGH' if any(f['lines'] > 600 for f in swift_files) else 'MEDIUM'}

---

{optimization_result}

---

## 📁 Analyzed Files

| File | Lines | Category | Priority |
|------|-------|----------|----------|
"""
    
    for file in sorted(swift_files, key=lambda x: x['lines'], reverse=True):
        priority = "🔴 HIGH" if file['lines'] > 600 else "🟡 MEDIUM" if file['lines'] > 400 else "🟢 LOW"
        markdown_report += f"| `{file['name']}` | {file['lines']} | {file['size_category']} | {priority} |\n"
    
    markdown_report += f"""
## 🎯 Next Steps

1. **Review Recommendations:** Implement suggested optimizations
2. **Decompose Large Files:** Break down files >400 lines  
3. **Performance Testing:** Measure impact of changes
4. **Iterative Improvement:** Run optimization regularly

*Powered by Azure OpenAI & GitHub Actions* 🚀
"""
    
    # Save markdown report
    with open('optimization_results.md', 'w', encoding='utf-8') as f:
        f.write(markdown_report)
    
    # Save JSON analysis data
    analysis_data = {
        'timestamp': timestamp,
        'total_files': len(swift_files),
        'total_lines': total_lines,
        'large_files_count': len([f for f in swift_files if f['lines'] > 400]),
        'files': [
            {
                'name': f['name'],
                'lines': f['lines'],
                'category': f['size_category']
            } for f in swift_files
        ],
        'optimization_result': optimization_result
    }
    
    with open('swift_analysis.json', 'w', encoding='utf-8') as f:
        json.dump(analysis_data, f, indent=2, ensure_ascii=False)
    
    print("💾 Results saved:")
    print("  📄 optimization_results.md")
    print("  📊 swift_analysis.json")

def main():
    """Main optimization workflow"""
    
    if len(sys.argv) != 2:
        print("Usage: python optimize_with_azure.py <swift_payload.zip>")
        sys.exit(1)
    
    zip_path = sys.argv[1]
    
    if not os.path.exists(zip_path):
        print(f"❌ Error: {zip_path} not found")
        sys.exit(1)
    
    print("🚀 Starting Azure AI Swift Optimization...")
    print("=" * 50)
    
    # Step 1: Extract and analyze Swift files
    swift_files, total_lines = extract_swift_files(zip_path)
    
    if not swift_files:
        print("❌ No Swift files found in the zip archive")
        sys.exit(1)
    
    # Step 2: Create optimization prompt
    prompt = create_optimization_prompt(swift_files, total_lines)
    
    # Step 3: Analyze with Azure OpenAI
    optimization_result = analyze_with_azure_openai(prompt)
    
    # Step 4: Save results
    save_results(optimization_result, swift_files, total_lines)
    
    print("\n" + "=" * 50)
    print("✅ Azure AI Swift Optimization Complete!")
    print(f"📊 Analyzed {len(swift_files)} files ({total_lines:,} lines)")
    print("📄 Check optimization_results.md for detailed recommendations")
    print("🎯 Ready for implementation!")

if __name__ == "__main__":
    main()
