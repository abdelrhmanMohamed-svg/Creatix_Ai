<!-- Sync Impact Report:
- Version change: 1.0.0 (initial version based on template)
- Modified principles: All principles updated to reflect Flutter/Supabase/Cubit/get_it requirements
- Added sections: Technical Constraints, Development Practices, Governance
- Removed sections: None (template sections retained but renamed)
- Templates requiring updates:
  ✅ .specify/templates/plan-template.md (Constitution Check added)
  ✅ .specify/templates/spec-template.md (Functional Requirements updated)
  ✅ .specify/templates/tasks-template.md (Foundational phase validation tasks added)
  ✅ .specify/templates/checklist-template.md (Constitution validation checklist added)
- Follow-up TODOs: RATIFICATION_DATE needs to be determined
-->

# Creatix Constitution

## Core Principles

### I. Clean Architecture
MUST follow Clean Architecture with strict separation: Data layer (models, datasources, repositories), Domain layer (entities, usecases, repository contracts), Presentation layer (UI, Cubits, states). NO mixing of responsibilities between layers.

### II. State Management
MUST use Cubit (Bloc) for state management ONLY. NO direct setState, NO Provider, NO Riverpod, NO Redux. State changes MUST happen through Cubit methods.

### III. Dependency Injection
MUST use get_it for dependency injection. ALL dependencies MUST be registered through get_it. NO manual instantiation, NO ServiceLocator anti-patterns, NO inheritance for DI.

### IV. Backend Integration
MUST use Supabase for ALL backend functionality (auth, database, storage, edge functions). MUST NEVER call external AI APIs (OpenAI, Gemini, etc.) from Flutter code. ALL external API calls MUST go through Supabase edge functions. API keys MUST be stored ONLY in Supabase Vault/edge function environment.

### V. Provider System & Security
MUST support provider system with user API keys (OpenAI, Gemini) and fallback default provider (Pixazo). API keys MUST be kept secure - NO exposure in client code, NO hardcoding, NO logging. Provider resolution MUST happen in edge functions. Feature-based structure MUST be enforced with clear separation between features.

## Technical Constraints
- MUST use Flutter + Dart as specified in implementation plan
- MUST follow the project structure outlined in docs/flutter_implementaion_plan.md
- MUST implement features in phases as outlined: Foundation, Auth+Profile, Brands, Brand Kit, Provider Keys, Generation, History
- MUST enable Row Level Security (RLS) matching backend plan
- MUST implement proper error handling and loading states in all Cubits

## Development Practices
- MUST write unit tests for all usecases and repository implementations
- MUST write widget tests for all UI components
- MUST conduct code reviews for all changes
- MUST keep commits atomic and focused
- MUST update documentation when changing architecture or APIs
- MUST follow Dart formatting standards (dartfmt)

## Governance
This constitution supersedes all other documentation and practices. Amendments MUST be documented with rationale, approved by maintainers, and include a migration plan if breaking changes are introduced. All PRs/reviews MUST verify compliance with this constitution. Complexity MUST be justified with clear benefits. Use docs/flutter_implementaion_plan.md for runtime development guidance.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): Original adoption date unknown | **Last Amended**: 2026-04-18