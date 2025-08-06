#!/usr/bin/env python3
"""
Test script för Azure OpenAI konfiguration
Testar anslutning till Krilles Azure OpenAI deployment
"""

import os
from openai import AzureOpenAI

def test_azure_openai_connection():
    """Test Azure OpenAI anslutning med Krilles konfiguration"""
    
    print("🧠 Testing Azure OpenAI Connection...")
    print("=" * 50)
    
    # Krilles Azure OpenAI konfiguration
    api_key = "DITT_AZURE_OPENAI_API_KEY_HÄR"
    endpoint = "https://krilles.cognitiveservices.azure.com/"
    deployment = "gpt-4.1"
    
    print(f"🔗 Endpoint: {endpoint}")
    print(f"🚀 Deployment: {deployment}")
    print(f"🔑 API Key: {api_key[:10]}...{api_key[-10:]}")
    
    try:
        # Initialize Azure OpenAI client - try different API versions
        api_versions = ["2025-01-01-preview", "2024-10-01-preview", "2024-08-01-preview", "2024-06-01"]
        
        for api_version in api_versions:
            try:
                print(f"🔄 Trying API version: {api_version}")
                
                client = AzureOpenAI(
                    api_key=api_key,
                    api_version=api_version,
                    azure_endpoint=endpoint
                )
                
                print("\n🧪 Sending test Swift code analysis request...")
                
                # Test med enkel Swift kod
                test_swift_code = """
struct EmotionalState {
    let primaryEmotion: EmotionType
    let intensity: Double
    let timestamp: Date
}
"""
                
                response = client.chat.completions.create(
                    model=deployment,
                    messages=[
                        {
                            "role": "system", 
                            "content": "Du är en expert Swift-utvecklare. Analysera kod kortfattat på svenska."
                        },
                        {
                            "role": "user", 
                            "content": f"Analysera denna Swift-kod och ge 3 korta förbättringsförslag:\n\n{test_swift_code}"
                        }
                    ],
                    max_tokens=500,
                    temperature=0.1
                )
                
                print("✅ Azure OpenAI Connection SUCCESS!")
                print(f"✅ Working API version: {api_version}")
                print("\n📝 AI Response:")
                print("-" * 30)
                print(response.choices[0].message.content)
                print("-" * 30)
                
                print(f"\n📊 Usage:")
                print(f"   Prompt tokens: {response.usage.prompt_tokens}")
                print(f"   Completion tokens: {response.usage.completion_tokens}")
                print(f"   Total tokens: {response.usage.total_tokens}")
                
                print("\n🎉 READY FOR SWIFT OPTIMIZATION!")
                return True
                
            except Exception as version_error:
                print(f"❌ API version {api_version} failed: {str(version_error)}")
                continue
        
        print("❌ All API versions failed")
        return False
        
    except Exception as e:
        print(f"❌ Connection failed: {str(e)}")
        return False

def create_github_secrets_script():
    """Skapa script för att sätta GitHub secrets"""
    
    script_content = '''#!/bin/bash
# GitHub Secrets Setup Script för NovaMind Azure AI

echo "🔧 Setting up GitHub Secrets for NovaMind Azure AI..."

# Sätt GitHub secrets (kräver GitHub CLI: gh auth login)
gh secret set AZURE_OPENAI_API_KEY --body "DITT_AZURE_OPENAI_API_KEY_HÄR"
gh secret set AZURE_OPENAI_ENDPOINT --body "https://krilles.cognitiveservices.azure.com/"
gh secret set AZURE_OPENAI_DEPLOYMENT --body "gpt-4.1"

echo "✅ GitHub Secrets configured!"
echo "🚀 Ready to trigger Azure AI Swift optimization!"

# Trigga första optimeringen
echo "🧠 Triggering first optimization..."
git add .
git commit -m "🧠 Activate Azure AI Swift optimization with GPT-4.1"
git push origin main

echo "🎉 Azure AI Swift optimization is now ACTIVE!"
'''
    
    with open('setup_github_secrets.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('setup_github_secrets.sh', 0o755)
    print("📝 Created: setup_github_secrets.sh")

if __name__ == "__main__":
    print("🎯 NovaMind Azure AI - Configuration Test")
    print("=" * 60)
    
    # Test anslutning
    success = test_azure_openai_connection()
    
    if success:
        print("\n🔧 Creating GitHub setup script...")
        create_github_secrets_script()
        
        print("\n" + "=" * 60)
        print("🎉 AZURE AI SETUP COMPLETE!")
        print("=" * 60)
        print()
        print("✅ Azure OpenAI connection verified")
        print("✅ GPT-4.1 deployment working")  
        print("✅ GitHub secrets script created")
        print()
        print("🚀 Next steps:")
        print("1. Run: ./setup_github_secrets.sh")
        print("2. Or manually add secrets in GitHub")
        print("3. Push to main branch to trigger optimization")
        print()
        print("🧠 Your Swift code will be optimized by GPT-4.1 on every push!")
    else:
        print("\n❌ Setup incomplete - check Azure configuration")
