# Implementation Plan: Authentication + Profile

**Branch**: `002-auth-profile` | **Date**: 2026-04-18 | **Spec**: [link](spec.md)
**Input**: Feature specification from `/specs/002-auth-profile/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Implement user authentication (email/password) and profile management using Supabase Auth and database, following Clean Architecture with Cubit state management and get_it dependency injection. Feature includes registration, login, logout, profile viewing, and profile update capabilities.

## Technical Context

**Language/Version**: Flutter + Dart 3.x  
**Primary Dependencies**: flutter_bloc (Cubit), get_it, supabase_flutter, equatable, dartz  
**Storage**: Supabase Database (profiles table) + Supabase Auth  
**Testing**: Flutter test framework  
**Target Platform**: Mobile (iOS/Android)  
**Project Type**: Mobile App (Flutter)  
**Performance Goals**: Sub-second authentication flows, instant state transitions  
**Constraints**: Offline-capable session handling, secure token storage  
**Scale/Scope**: Single user, typical mobile app patterns

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

**Result**: All gates pass - no violations.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | - | - |

---

## Constitution Check (Post-Design)

*Re-evaluated after Phase 1 design*

- ✅ MUST follow Clean Architecture (Data/Domain/Presentation layers) - **Verified in data-model.md and contracts/**
- ✅ MUST use Cubit for state management only - **Verified in plan structure**
- ✅ MUST use get_it for dependency injection - **Verified in quickstart.md**
- ✅ MUST use Supabase for backend (auth, db, storage, edge functions) - **Verified in data-model.md**
- ✅ MUST NEVER call external AI APIs from Flutter (use edge functions) - **N/A for this feature**
- ✅ MUST support provider system with user API keys and fallback default provider - **N/A for this feature**
- ✅ MUST keep API keys secure (no exposure in client) - **N/A for this feature**
- ✅ MUST enforce feature-based structure - **Verified in project structure**

**Result**: All gates pass - no violations. Design aligns with constitution requirements.
