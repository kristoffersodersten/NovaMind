# 🔧 GitHub Secrets Syntax - Exakt hur det ska se ut

## 📋 **I GitHub Web Interface:**

När du klickar "New repository secret" ser du två fält:

### **Secret 1: AZURE_OPENAI_API_KEY**

```
┌─────────────────────────────────────────────┐
│ Name *                                      │
│ ┌─────────────────────────────────────────┐ │
│ │ AZURE_OPENAI_API_KEY                    │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ Secret *                                    │
│ ┌─────────────────────────────────────────┐ │
│ │ 73kEbeeDCdoZqgVGtl0NgNJIYq2SoLEEgsItF │ │
│ │ KyXUKUkGHSVb77aJQQJ99BGACfhMk5XJ3w3A │ │
│ │ AABACOGgufX                             │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│           [Add secret]                      │
└─────────────────────────────────────────────┘
```

### **Secret 2: AZURE_OPENAI_ENDPOINT**

```
┌─────────────────────────────────────────────┐
│ Name *                                      │
│ ┌─────────────────────────────────────────┐ │
│ │ AZURE_OPENAI_ENDPOINT                   │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ Secret *                                    │
│ ┌─────────────────────────────────────────┐ │
│ │ https://krilles.cognitiveservices.      │ │
│ │ azure.com/                              │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│           [Add secret]                      │
└─────────────────────────────────────────────┘
```

### **Secret 3: AZURE_OPENAI_DEPLOYMENT**

```
┌─────────────────────────────────────────────┐
│ Name *                                      │
│ ┌─────────────────────────────────────────┐ │
│ │ AZURE_OPENAI_DEPLOYMENT                 │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ Secret *                                    │
│ ┌─────────────────────────────────────────┐ │
│ │ gpt-4.1                                 │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│           [Add secret]                      │
└─────────────────────────────────────────────┘
```

## ✅ **Viktiga detaljer:**

### **Name-fältet:**
- **Exakt text:** `AZURE_OPENAI_API_KEY` (inga backticks `` ` ``)
- **Versaler:** Ja, precis som det står
- **Understreck:** Ja, `_` mellan orden

### **Secret-fältet:**
- **API-nyckel:** Hela den långa strängen (inga backticks)
- **Endpoint:** `https://YOUR-RESOURCE.cognitiveservices.azure.com/`
- **Deployment:** `gpt-4.1`

## 🚨 **Vanliga misstag att undvika:**

❌ **Lägg INTE till:**
- Backticks: `` `AZURE_OPENAI_API_KEY` ``
- Citattecken: `"AZURE_OPENAI_API_KEY"`
- Mellanslag före/efter
- Extra radbrytningar

✅ **Lägg till:**
- Bara rena texten
- Exakt som visas ovan
- Inga extra tecken

## 🎯 **Copy-paste värden:**

**Name 1:** `AZURE_OPENAI_API_KEY`  
**Secret 1:** `PLACEHOLDER_API_KEY`

**Name 2:** `AZURE_OPENAI_ENDPOINT`  
**Secret 2:** `https://YOUR-RESOURCE.cognitiveservices.azure.com/`

**Name 3:** `AZURE_OPENAI_DEPLOYMENT`  
**Secret 3:** `gpt-4.1`

Klar att lägga till i GitHub nu? 🚀
