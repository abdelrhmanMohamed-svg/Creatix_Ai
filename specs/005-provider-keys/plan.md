# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Securely store and manage AI provider API keys (OpenAI, Gemini) using Supabase Vault, with server-side validation, support for up to two keys per user (one per provider), and ability for brands to reference specific provider keys. Follows Clean Architecture with Cubit state management and get_it dependency injection.

## Technical Context

**Language/Version**: Dart 3.x (latest stable Flutter SDK)  
**Primary Dependencies**: Flutter, flutter_bloc (Cubit), get_it, supabase_flutter, equatable, dartz  
**Storage**: Supabase (PostgreSQL)  
**Testing**: flutter_test  
**Target Platform**: Mobile (Flutter)  
**Project Type**: mobile-app  
**Performance Goals**: API key validation under 10 seconds, 95% success rate for validation requests  
**Constraints**: Must follow Clean Architecture, use Cubit for state management only, use get_it for dependency injection, use Supabase for all backend functionality (auth, db, storage, edge functions), never call external AI APIs from Flutter code, enforce feature-based structure, keep API keys secure (no exposure in client code), support provider system with user API keys (OpenAI/Gemini) and fallback default provider, enable Row Level Security (RLS)  
**Scale/Scope**: Supports up to 2 API keys per user (one for OpenAI, one for Gemini), brands can reference specific provider keys

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart 3.x (latest stable Flutter SDK)  
**Primary Dependencies**: Flutter, flutter_bloc (Cubit), get_it, supabase_flutter, equatable, dartz  
**Storage**: Supabase (PostgreSQL)  
**Testing**: flutter_test  
**Target Platform**: Mobile (Flutter)  
**Project Type**: mobile-app  
**Performance Goals**: API key validation under 10 seconds, 95% success rate for validation requests  
**Constraints**: Must follow Clean Architecture, use Cubit for state management only, use get_it for dependency injection, use Supabase for all backend functionality, never call external AI APIs from Flutter code, enforce feature-based structure, enable Row Level Security (RLS)  
**Scale/Scope**: Supports up to 2 API keys per user (one for OpenAI, one for Gemini), brands can reference specific provider keys

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- MUST follow Clean Architecture (Data/Domain/Presentation layers)
- MUST use Cubit for state management only
- MUST use get_it for dependency injection
- MUST use Supabase for backend (auth, db, storage, edge functions)
- MUST NEVER call external AI APIs from Flutter (use edge functions)
- MUST support provider system with user API keys and fallback default provider
- MUST keep API keys secure (no exposure in client)
- MUST enforce feature-based structure

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: Option 1: Single project (DEFAULT) - Following the Flutter project structure from docs/flutter_implementaion_plan.md with lib/ containing core/ and features/ directories, and tests/ at the repository root

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
