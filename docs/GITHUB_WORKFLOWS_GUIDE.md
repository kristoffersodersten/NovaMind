# 🚀 NovaMind GitHub Actions Workflows Guide

## 📁 Dina Workflows:

### 🧠 **azure-ai-simple.yml** - Grundläggande Azure AI-analys
```
Triggers: Push till main, Manual
Purpose: Snabb Azure OpenAI Swift-kodanalys
Output: Optimeringsrapport som artifacts
```

### 🔍 **comprehensive-ci-cd.yml** - Komplett CI/CD Pipeline
```
Triggers: Push/PR till main/develop, Manual
Jobs: 
  1. Quality Check (metrics, lint)
  2. Build & Test (Xcode build, unit tests)
  3. Azure AI Analysis (GPT-4.1 optimization)
  4. Final Report (summary, notifications)
```

### ⚡ **azure-ai-swift-optimize.yml** - Original Azure AI Workflow
```
Triggers: Push/PR till main/dev
Purpose: Detaljerad Swift-optimering med Azure OpenAI
Features: Smart filprioritering, tokenoptimering
```

## 🎯 **Rekommenderat användande:**

### **För att börja:**
1. **Använd `azure-ai-simple.yml`** först för att testa Azure AI-integrationen
2. **Kontrollera att secrets fungerar** och att rapporter genereras
3. **Gradvis övergå** till `comprehensive-ci-cd.yml` för fullständig automation

### **För utveckling:**
```bash
# Trigga enkel Azure AI-analys
git push origin main

# Trigga komplett CI/CD
git push origin develop

# Manuell analys
# Gå till Actions → azure-ai-simple → Run workflow
```

## 🔧 **Workflow-funktioner:**

### **Quality Gates:**
- ✅ Swift-fil räkning och metrics
- ✅ Identifiering av stora filer (>400 rader)
- ✅ SwiftLint integration (om installerat)

### **Build Process:**
- ✅ Xcode 15.0 setup
- ✅ Swift Package Manager dependencies
- ✅ Clean build utan code signing
- ✅ Unit test execution

### **Azure AI Integration:**
- ✅ Automatisk Swift-filsamling
- ✅ GPT-4.1 kodanalys
- ✅ Optimeringsrapporter
- ✅ GitHub artifact upload
- ✅ PR kommentarer med sammanfattningar

## 📊 **Vad du får:**

### **Artifacts som laddas upp:**
1. **`azure-ai-analysis-{run_number}`**
   - `azure_optimization_report.md` - Detaljerad optimeringsrapport
   - `azure_analysis_*.json` - Strukturerad data
   - `swift_code_payload.zip` - Analyserad kod

2. **`pipeline-summary-{run_number}`**
   - `pipeline_summary.md` - Översikt av hela CI/CD-körningen

### **GitHub Integrationer:**
- 🔗 **Automatic PR comments** med Azure AI-analys sammanfattningar
- 📊 **Workflow status badges** för build/test/analysis
- 📁 **Downloadable reports** från varje körning

## 🚀 **Nästa steg:**

1. **Testa grundläggande workflow:**
```bash
git add .
git commit -m "🧠 Add comprehensive GitHub Actions workflows"
git push origin main
```

2. **Kontrollera workflow-resultat:**
   - Gå till GitHub → Actions
   - Klicka på senaste workflow-körning
   - Ladda ner artifacts för Azure AI-rapporter

3. **Optimera baserat på feedback:**
   - Granska Azure AI-rekommendationer
   - Implementera föreslagna förbättringar
   - Upprepa processen för kontinuerlig förbättring

## ⚙️ **Anpassningar:**

### **För att aktivera fler workflows:**
```yaml
# I workflow-filer, ändra triggers:
on:
  push:
    branches: [ main, develop, feature/* ]  # Fler branches
  schedule:
    - cron: '0 2 * * 1'  # Veckovis måndag 02:00
```

### **För att justera Azure AI-frekvens:**
```yaml
# Endast för stora changes:
if: github.event.commits[0].message contains '[azure-ai]'

# Eller endast för PR:
if: github.event_name == 'pull_request'
```

**Din Azure OpenAI GPT-4.1 integration är nu redo för automatisk Swift-kodoptimering!** 🧠✨
