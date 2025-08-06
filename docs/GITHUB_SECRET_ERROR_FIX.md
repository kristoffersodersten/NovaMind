# 🚨 GitHub Secret Error Fix

## ❌ **Fel: "Secret names must not start with GITHUB_"**

Detta fel uppstår vanligtvis när:

1. **Secret name börjar med `GITHUB_`** (våra gör inte det)
2. **Copy-paste innehåller osynliga tecken**
3. **Extra mellanslag eller radbrytningar**

## ✅ **Lösning: Rensa och försök igen**

### **Exakt copy-paste värden (testade):**

**Secret 1:**
```
Name: AZURE_OPENAI_API_KEY
Secret: PLACEHOLDER_API_KEY
```

**Secret 2:**
```
Name: AZURE_OPENAI_ENDPOINT
Secret: https://YOUR-RESOURCE.cognitiveservices.azure.com/
```

**Secret 3:**
```
Name: AZURE_OPENAI_DEPLOYMENT
Secret: gpt-4.1
```

## 🔧 **Felsökning:**

### **Steg 1: Kontrollera Name-fältet**
- Ser du några osynliga tecken före `AZURE_OPENAI_API_KEY`?
- Markera allt i Name-fältet och radera, skriv sedan: `AZURE_OPENAI_API_KEY`

### **Steg 2: Kontrollera Secret-fältet**
- Markera allt i Secret-fältet och radera
- Copy-paste denna exakta text: `PLACEHOLDER_API_KEY`

### **Steg 3: Lägg till secrets en i taget**
Istället för att fylla i alla 3 på en gång, försök:

1. **Lägg till bara AZURE_OPENAI_API_KEY först**
2. **Klicka "Add secret"**
3. **Sedan nästa secret**

## 💡 **Alternativ lösning:**

Om problemet kvarstår, prova dessa secret-namn istället:

```
AZURE_OPENAI_KEY          (istället för AZURE_OPENAI_API_KEY)
AZURE_ENDPOINT            (istället för AZURE_OPENAI_ENDPOINT)
AZURE_DEPLOYMENT          (istället för AZURE_OPENAI_DEPLOYMENT)
```

Då måste vi uppdatera GitHub Actions workflow också, men det löser vi efter.

## 🎯 **Försök igen:**

1. **Rensa alla fält**
2. **Skriv in namnen manuellt** (använd inte copy-paste för namnet)
3. **Copy-paste bara secret-värdet**
4. **Lägg till en secret i taget**

Vilket av secrets får du felet på? 🔍
