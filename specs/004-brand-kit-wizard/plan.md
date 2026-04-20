# Implementation Plan: Brand Kit Wizard

**Branch**: `004-brand-kit-wizard` | **Date**: 2026-04-19 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/004-brand-kit-wizard/spec.md`

## Summary

Implement a brand-centric onboarding wizard that guides users through defining their brand identity (business type, tone of voice, color palette, target audience, and AI-generated summary) for a specific brand. The wizard stores a BrandKit entity linked to each brand via brand_id, enforcing a one-to-one relationship. All brand-scoped features require brand_id parameter and operate within the context of a "current selected brand" state in the frontend.

## Technical Context

**Language/Version**: Dart 3.x (latest stable Flutter SDK)  
**Primary Dependencies**: Flutter, flutter_bloc (Cubit), get_it, supabase_flutter, equatable, dartz  
**Storage**: Supabase PostgreSQL (brands table, brand_kits table)  
**Testing**: flutter_test, mockito, bloc_test  
**Target Platform**: Mobile (iOS/Android)  
**Project Type**: Mobile-app with backend services (Supabase)  
**Performance Goals**: Wizard completion under 4 minutes, BrandKit updates under 2 seconds  
**Constraints**: Must follow Clean Architecture, use Cubit for state management only, use get_it for dependency injection, use Supabase for all backend functionality  
**Scale/Scope**: Designed for individual users managing multiple brands, each with distinct BrandKit entities

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] MUST follow Clean Architecture (Data/Domain/Presentation layers)
- [x] MUST use Cubit for state management only
- [x] MUST use get_it for dependency injection
- [x] MUST use Supabase for backend (auth, db, storage, edge functions)
- [x] MUST NEVER call external AI APIs from Flutter (use edge functions)
- [x] MUST support provider system with user API keys and fallback default provider
- [x] MUST keep API keys secure (no exposure in client)
- [x] MUST enforce feature-based structure