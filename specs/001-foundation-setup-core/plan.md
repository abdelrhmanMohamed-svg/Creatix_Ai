# Implementation Plan: Foundation Setup - Core Architecture

**Branch**: `001-foundation-setup-core` | **Date**: 2026-04-18 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-foundation-setup-core/spec.md`

## Summary

Establish a production-ready Flutter application with Clean Architecture foundation. Create the core infrastructure including Supabase integration, dependency injection setup, centralized routing, and error handling system. All technical decisions follow the Flutter Implementation Plan and Creatix Constitution.

## Technical Context

**Language/Version**: Dart 3.x (latest stable Flutter SDK)  
**Primary Dependencies**: Flutter, flutter_bloc (Cubit), get_it, supabase_flutter, equatable, dartz, flutter_dotenv  
**Security**: Environment variables via flutter_dotenv to secure Supabase URL and anon key (never hardcoded)  
**Storage**: Supabase (PostgreSQL via supabase_flutter)  
**Testing**: flutter_test, mocktail  
**Target Platform**: Mobile (iOS 12+, Android API 21+)  
**Project Type**: mobile-app  
**Performance Goals**: Standard mobile app expectations (< 3s cold start, < 200ms UI interactions)  
**Constraints**: Offline-first architecture deferred to Phase 8  
**Scale/Scope**: Multi-feature mobile app (7 phases, 50+ screens projected)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- ✅ MUST follow Clean Architecture (Data/Domain/Presentation layers)
- ✅ MUST use Cubit for state management only
- ✅ MUST use get_it for dependency injection
- ✅ MUST use Supabase for backend (auth, db, storage, edge functions)
- ✅ MUST NEVER call external AI APIs from Flutter (use edge functions)
- ✅ MUST support provider system with user API keys and fallback default provider
- ✅ MUST keep API keys secure (no exposure in client)
- ✅ MUST enforce feature-based structure

**Gate Status**: PASSED - All constitution requirements satisfied by specification

## Project Structure

### Documentation (this feature)

```text
specs/001-foundation-setup-core/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (N/A for internal mobile app)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── di/
│   │   └── injection.dart          # get_it dependency injection setup
│   ├── error/
│   │   └── failures.dart           # Failure classes for error handling
│   ├── utils/
│   │   ├── validators.dart         # Input validation utilities
│   │   ├── formatters.dart         # Date/number formatting utilities
│   │   └── logger.dart             # Logging utility
│   ├── constants/
│   │   ├── app_routes.dart         # Route names and paths
│   │   └── api_endpoints.dart     # API endpoint constants
│   └── supabase/
│       └── supabase_client.dart   # Supabase initialization
│
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── cubits/
│
└── main.dart                          # App entry point with Supabase init
```

**Structure Decision**: Clean Architecture with feature-based folder structure as defined in Flutter Implementation Plan. Core module contains shared infrastructure, features directory organized by domain.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations - this is a foundational phase establishing the architecture patterns. All complexity is standard Clean Architecture implementation.