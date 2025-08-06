# NovaMind CI/CD Pipeline Documentation

## Overview
This directory contains the complete CI/CD pipeline for NovaMind, implementing modern DevOps practices with GitHub Actions.

## Workflows

### 1. CI Pipeline (`ci.yml`)
**Trigger**: Push/PR to main/develop branches
- ✅ Code quality checks with SwiftLint
- ✅ Swift format validation
- ✅ Build and test for macOS/iOS
- ✅ Security scanning
- ✅ Performance analysis
- ✅ Integration testing

### 2. Deployment Pipeline (`deploy.yml`)  
**Trigger**: Successful CI completion or manual dispatch
- 🚀 Staging deployment
- 🎯 Production deployment with health checks
- 📊 Post-deployment reporting

### 3. Quality Gates (`quality-gates.yml`)
**Trigger**: All pushes and PRs
- 📏 Apple coding standards enforcement
- 🏗️ Architecture validation
- 🔒 Security dependency checks
- ⚡ Performance guidelines
- 🧠 NovaMind component integration

### 4. Code Decomposition (`decomposition.yml`)
**Trigger**: Manual dispatch
- 🔍 Automatic detection of large files (>400 lines)
- 📋 Decomposition strategy analysis
- 🔧 Automated decomposition planning
- 📝 PR creation for systematic refactoring

## Key Features

### Apple Standards Compliance
- **File size**: ≤ 400 lines
- **Type bodies**: ≤ 350 lines
- **Function bodies**: ≤ 50 lines
- **Swift API Design Guidelines** adherence

### NovaMind-Specific Integration
- Enhanced Memory Architecture validation
- NeuroMesh Emotional Model testing
- Semantic360 Resonance Radar checks
- Bird Agent Orchestrator deployment
- CI/CD Pipeline Executor integration

### Security & Performance
- Dependency vulnerability scanning
- Secret detection
- Performance pattern analysis
- Async/await usage optimization
- Memory architecture validation

## Usage

### Running CI Pipeline
```bash
# Automatically triggered on push/PR
git push origin main
```

### Manual Deployment
```bash
# Via GitHub Actions UI
# Workflows → NovaMind Deployment Pipeline → Run workflow
# Select environment: staging | production
```

### Code Decomposition
```bash
# Via GitHub Actions UI  
# Workflows → NovaMind Code Decomposition → Run workflow
# Options:
#   - target_files: "all" or specific files
#   - max_lines: 400 (Apple standard)
#   - create_pr: true/false
```

### Quality Gate Validation
```bash
# Automatically runs on all PRs
# Manual trigger via Actions UI available
```

## Environment Configuration

### Secrets Required
- `GITHUB_TOKEN`: Automatic (provided by GitHub)
- App signing certificates (for production deployment)
- Deployment target credentials

### Environment Variables
- `XCODE_VERSION`: "15.4"
- `APP_NAME`: "NovaMind"
- `BUNDLE_ID`: "com.novamind.app"

## Deployment Environments

### Staging
- **Purpose**: Integration testing and validation
- **Trigger**: Successful CI on main branch
- **Features**: Full NovaMind system activation for testing

### Production  
- **Purpose**: Live deployment
- **Trigger**: Manual approval after staging validation
- **Features**: Production health checks and monitoring

## Quality Metrics

### Code Quality Score
The pipeline tracks a comprehensive quality score based on:
- Swift code quality (SwiftLint compliance)
- Architecture validation (modular structure)
- Security checks (dependency scanning)
- Performance guidelines (async/await patterns)
- NovaMind integration (component validation)

**Passing Score**: 3/5 minimum for deployment eligibility
**Perfect Score**: 5/5 for optimal quality

### Decomposition Tracking
- Automatic detection of files exceeding Apple standards
- Systematic decomposition planning
- Progress tracking with PR integration
- Compliance validation

## Best Practices

### For Developers
1. **Keep files small**: Target ≤400 lines per file
2. **Use MARK comments**: For clear section boundaries
3. **Async/await preferred**: For concurrent operations
4. **Security first**: No hardcoded secrets
5. **Test coverage**: Maintain comprehensive test suites

### For Releases
1. **Quality gates first**: Ensure all checks pass
2. **Staging validation**: Test in staging before production
3. **Health monitoring**: Monitor post-deployment metrics
4. **Rollback ready**: Have rollback procedures prepared

## Troubleshooting

### Common Issues

**SwiftLint Failures**
```bash
# Fix common issues
swiftlint lint --fix
```

**Large File Detection**
```bash
# Run decomposition workflow
# Follow generated decomposition plan
```

**Build Failures**
```bash
# Check Xcode version compatibility
# Validate Swift package dependencies
# Review code signing configuration
```

### Support
- Check workflow logs in GitHub Actions
- Review quality gate summary reports
- Consult decomposition plans for refactoring guidance

---

**NovaMind CI/CD**: Where modern DevOps meets AI-powered productivity 🚀
