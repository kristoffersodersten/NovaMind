# NovaMind Clean Architecture & TCA Overview

This document describes the NovaMind Golden Standard enforcement for Clean Architecture + The Composable Architecture (TCA).

## Directory Structure
- Core: Business logic, state, reducers, models, protocols
- Presentation: SwiftUI views, UI components, modifiers
- Infrastructure: Integrations (network, persistence, keychain, Secure Enclave, ChromaDB, etc.)
- UIComponents: Reusable design system components (KrilleStyle.*)
- Tests: Unit tests, TCA TestStore, mocks, coverage enforcement
- DocumentationCatalog.docc: DocC documentation, Overview.md, Diagram.svg, Relationships.json

## Enforcement
- All logic and UI mapped 1:1 to specification
- No generative abstraction or speculative reasoning
- All validation and audit steps must be deterministic

## Next Steps
- Move and refactor code per structure above
- Implement TCA modules and protocol abstractions
- Integrate CI/CD, accessibility, localization, and security as specified
