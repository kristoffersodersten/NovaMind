# Azure DevOps Integration Setup Guide

## 🚀 Setting up Azure Integration for NovaMind

This guide will help you configure Azure services to leverage your Azure credits and GitHub Enterprise subscription for AI-powered code optimization.

## 📋 Prerequisites

1. **Azure Subscription** with available credits
2. **GitHub Enterprise** subscription (already configured)
3. **Azure CLI** access
4. **GitHub repository** admin access

## 🔧 Step 1: Configure Azure Secrets

Add these secrets to your GitHub repository (`Settings > Secrets and variables > Actions`):

### Required Secrets:

```bash
# Azure Authentication
AZURE_SUBSCRIPTION_ID      # Your Azure subscription ID
AZURE_TENANT_ID            # Your Azure AD tenant ID  
AZURE_CLIENT_ID            # Service principal client ID
AZURE_CLIENT_SECRET        # Service principal client secret
AZURE_CREDENTIALS          # Complete Azure credentials JSON
```

### Getting Azure Credentials:

1. **Create Service Principal**:
```bash
az ad sp create-for-rbac \
  --name "NovaMind-GitHub-Actions" \
  --role contributor \
  --scopes /subscriptions/{subscription-id} \
  --sdk-auth
```

2. **Copy the output JSON** to `AZURE_CREDENTIALS` secret:
```json
{
  "clientId": "your-client-id",
  "clientSecret": "your-client-secret", 
  "subscriptionId": "your-subscription-id",
  "tenantId": "your-tenant-id"
}
```

3. **Individual secrets** from the same JSON:
- `AZURE_CLIENT_ID`: clientId value
- `AZURE_CLIENT_SECRET`: clientSecret value
- `AZURE_SUBSCRIPTION_ID`: subscriptionId value  
- `AZURE_TENANT_ID`: tenantId value

## 🧠 Step 2: Azure OpenAI Setup

1. **Request Azure OpenAI Access** (if not already available)
2. **Create OpenAI Service**:
```bash
az cognitiveservices account create \
  --name "novamind-openai" \
  --resource-group "novamind-rg" \
  --location "eastus" \
  --kind "OpenAI" \
  --sku "S0"
```

3. **Deploy GPT-4 Model**:
```bash
az cognitiveservices account deployment create \
  --name "novamind-openai" \
  --resource-group "novamind-rg" \
  --deployment-name "gpt-4" \
  --model-name "gpt-4" \
  --model-version "0613"
```

## ⚡ Step 3: Azure Load Testing (Optional)

For performance testing capabilities:

```bash
# Create Load Testing resource
az load test create \
  --name "novamind-loadtest" \
  --resource-group "novamind-rg" \
  --location "eastus"
```

## 🌐 Step 4: Azure Container & App Services

For deployment capabilities:

```bash
# Create Container Registry
az acr create \
  --resource-group "novamind-rg" \
  --name "novamindregistry" \
  --sku Basic

# Create App Service Plan
az appservice plan create \
  --name "novamind-plan" \
  --resource-group "novamind-rg" \
  --sku B1 \
  --is-linux

# Create Web App
az webapp create \
  --resource-group "novamind-rg" \
  --plan "novamind-plan" \
  --name "novamind-app" \
  --runtime "NODE|18-lts"
```

## 🎯 Step 5: Run Azure Optimization

Once secrets are configured, trigger the Azure optimization:

1. **Go to Actions tab** in your GitHub repository
2. **Select "Azure DevOps Integration"** workflow
3. **Click "Run workflow"**
4. **Choose your optimization type**:
   - `code_analysis`: AI-powered Swift code analysis
   - `performance_testing`: Azure Load Testing validation
   - `deployment_pipeline`: Full deployment setup
   - `full_optimization`: Complete Azure integration

## 💰 Credit Usage Optimization

The pipeline is designed to maximize your Azure credit value:

- **Smart Resource Management**: Creates resources only when needed
- **Efficient Compute**: Uses optimal instance sizes
- **Automated Cleanup**: Removes temporary resources
- **Cost Monitoring**: Tracks credit usage per optimization run

## 📊 Expected Outputs

After running the optimization, you'll get:

1. **AI Analysis Report**: Detailed code optimization recommendations
2. **Performance Metrics**: Azure Load Testing results
3. **Deployment Configuration**: Ready-to-use Azure pipelines
4. **Cost Summary**: Azure credit usage breakdown

## 🔄 Automation Schedule

The pipeline can run:

- **On-demand**: Manual workflow triggers
- **Weekly**: Automated optimization (Mondays at 09:00 UTC)
- **PR-triggered**: Analysis on pull requests
- **Release-triggered**: Full optimization on releases

## 🎉 Benefits

With this Azure integration, you get:

✅ **AI-Powered Analysis**: GPT-4 code optimization recommendations  
✅ **Performance Validation**: Azure Load Testing insights  
✅ **Deployment Automation**: One-click Azure deployment  
✅ **Cost Efficiency**: Optimized Azure credit utilization  
✅ **Enterprise Integration**: GitHub Enterprise workflow  

## 🚀 Next Steps

1. **Configure secrets** (Step 1)
2. **Run first optimization** (Step 5)
3. **Review AI recommendations**
4. **Implement suggested changes**
5. **Deploy to Azure** using generated pipelines

---

**Need Help?** The optimization workflows include detailed logging and error handling to guide you through any issues.

*Your Azure credits + GitHub Enterprise + AI optimization = Maximum development efficiency! 🎯*
