# 🎯 Repository Secrets vs Environment Secrets - KLARGÖRANDE

## ✅ **För Azure AI Swift-optimering: Använd REPOSITORY SECRETS**

### 🔧 **Steg-för-steg instruktion:**

1. **Gå till GitHub Repository**
   - Öppna ditt NovaMind repository på GitHub

2. **Navigera till Settings**
   - Klicka på "Settings" (längst till höger i repository-menyn)

3. **Gå till Secrets and variables**
   - I vänstermenyn: klicka "Secrets and variables" → "Actions"

4. **Välj Repository secrets-fliken**
   - ⭐ **Klicka på "Repository secrets"** (överst på sidan)
   - ❌ **INTE** "Environment secrets"

5. **Lägg till secrets**
   - Klicka "New repository secret"
   - Lägg till var och en av de 3 Azure secrets

## 🤔 **Skillnaden mellan Repository vs Environment secrets:**

### 📁 **Repository Secrets** ← **Använd denna**
- **Tillgängliga för:** Alla GitHub Actions i detta repository
- **Bäst för:** API-nycklar, tokens, konfiguration
- **Vår Azure AI workflow:** Kommer automatiskt hitta dessa secrets

### 🌍 **Environment Secrets** 
- **Tillgängliga för:** Specifika deployment environments (prod, staging, etc.)
- **Bäst för:** Environment-specifika konfigurationer
- **Problem:** Vår workflow är inte konfigurerad för specifika environments

## ✅ **Sammanfattning:**

**Använd:** Repository secrets  
**Lägg till:** De 3 Azure OpenAI secrets  
**Resultat:** GitHub Actions kommer automatiskt hitta och använda dem  

När du lagt till de 3 repository secrets, gör bara en commit så triggas Azure AI-optimeringen! 🚀
