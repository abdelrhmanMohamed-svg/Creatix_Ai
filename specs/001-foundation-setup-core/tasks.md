# Implementation Tasks: Foundation Setup - Core Architecture

**Feature**: 001-foundation-setup-core  
**Generated**: 2026-04-18  
**Plan**: [plan.md](plan.md)

## Dependency Graph

```
Phase 1 (Setup)
    ↓
Phase 2 (Foundational)
    ↓
Phase 3 (US1: Clean Architecture)
    ↓
Phase 4 (US2: Supabase Connection)
    ↓
Phase 5 (US3: Dependency Injection)
    ↓
Phase 6 (US4: Navigation)
    ↓
Phase 7 (US5: Error Handling)
    ↓
Phase 8 (US6: Constants & Utilities)
    ↓
Phase 9 (Polish)
```

## Phase 1: Setup (Project Initialization)

**Goal**: Initialize Flutter project with all dependencies

**Independent Test**: `flutter build apk` / `flutter build ios` completes successfully

- [X] T001 Create Flutter project in `lib/` folder structure
- [X] T002 Add dependencies to `pubspec.yaml`: flutter_bloc, get_it, supabase_flutter, equatable, dartz, flutter_dotenv
- [X] T003 Add dev dependencies: flutter_test, mocktail, flutter_dotenv_generator, build_runner
- [X] T004 Verify project builds with `flutter build apk` (debug)

## Phase 2: Foundational (Blocking Prerequisites)

**Goal**: Create core infrastructure required before implementing user stories

**Independent Test**: Core module compiles without errors

- [X] T005 Create folder structure per plan.md: lib/core/{di,error,utils,constants,config,supabase}
- [X] T006 Create `.env` file with SUPABASE_URL and SUPABASE_ANON_KEY
- [X] T007 Add `.env` and `.env.local` to `.gitignore`
- [X] T008 Create `lib/core/config/env.dart` - environment variable loader
- [X] T009 Create `lib/core/supabase/supabase_client.dart` - Supabase initialization wrapper
- [X] T010 Create basic `lib/main.dart` with Supabase.initialize() call
- [X] T011 Setup flutter_dotenv: add assets to pubspec.yaml and configure in main()

## Phase 3: US1 - Clean Architecture

**Goal**: Establish three-layer folder structure per feature

**Independent Test**: New feature folder has Data/Domain/Presentation subfolders

- [X] T012 [US1] Create feature folder template in `lib/features/`
- [X] T013 [US1] Add placeholder feature folder demonstrating Clean Architecture
- [X] T014 [US1] Create example entity in `lib/features/example/domain/entities/`
- [X] T015 [US1] Create example repository interface in `lib/features/example/domain/repositories/`
- [X] T016 [US1] Create example use case in `lib/features/example/domain/usecases/`
- [X] T017 [US1] Create example model in `lib/features/example/data/models/`
- [X] T018 [US1] Create example datasource in `lib/features/example/data/datasources/`
- [X] T019 [US1] Create example repository implementation in `lib/features/example/data/repositories/`
- [X] T020 [US1] Create example cubit in `lib/features/example/presentation/cubits/`
- [X] T021 [US1] Create example page in `lib/features/example/presentation/pages/`

## Phase 4: US2 - Supabase Connection

**Goal**: Verify Supabase client is accessible app-wide via get_it

**Independent Test**: Supabase client accessible via `GetIt.instance.get<SupabaseClient>()`

- [X] T022 [US2] Register Supabase client in `lib/core/di/injection.dart` as lazySingleton
- [X] T023 [US2] Create auth state observer for session persistence
- [X] T024 [US2] Test Supabase initialization on cold start
- [X] T025 [US2] Verify client accessible from any feature via get_it

## Phase 5: US3 - Dependency Injection

**Goal**: Centralize all dependency registration in injection.dart

**Independent Test**: All dependencies retrievable via get_it throughout app

- [X] T026 [US3] Create use case base class template in `lib/core/error/failures.dart`
- [X] T027 [US3] Update injection.dart with registration patterns (lazySingleton, factory)
- [X] T028 [US3] Document registration patterns in injection.dart comments
- [X] T029 [US3] Test mock replacement capability with unit test

## Phase 6: US4 - Navigation

**Goal**: Implement centralized routing with onGenerateRoute and 404 fallback

**Independent Test**: Unknown route displays 404 fallback screen

- [X] T030 [US4] Create `lib/core/constants/app_routes.dart` route constants
- [X] T031 [US4] Create placeholder login page at `lib/features/auth/presentation/pages/login_page.dart`
- [X] T032 [US4] Create placeholder home page at `lib/features/home/presentation/pages/home_page.dart`
- [X] T033 [US4] Create 404 fallback page at `lib/core/presentation/pages/not_found_page.dart`
- [X] T034 [US4] Create router with onGenerateRoute in `lib/core/router.dart`
- [X] T035 [US4] Update main.dart to use onGenerateRoute
- [X] T036 [US4] Implement initial route based on auth state check
- [X] T037 [US4] Test navigation to unknown route shows 404

## Phase 7: US5 - Error Handling

**Goal**: Implement consistent error messaging system

**Independent Test**: User sees friendly message on errors without seeing technical details

- [X] T038 [US5] Create core Failure class with error categories in `lib/core/error/failures.dart`
- [X] T039 [US5] Add server, network, auth, cache, unknown error categories
- [X] T040 [US5] Implement error-to-message mapping in failures.dart
- [X] T041 [US5] Create error display widget at `lib/core/presentation/widgets/error_view.dart`
- [X] T042 [US5] Handle network errors: "Unable to connect. Please check your internet connection."
- [X] T043 [US5] Handle auth errors: Appropriate auth-related messages
- [X] T044 [US5] Handle unknown errors: Generic fallback without technical details
- [X] T045 [US5] Test error display with intentional error trigger

## Phase 8: US6 - Constants & Utilities

**Goal**: Centralize constants and utility functions

**Independent Test**: New endpoint uses constant, not hardcoded string; date formatting uses utils

- [X] T046 [US6] Create API endpoint constants in `lib/core/constants/api_endpoints.dart`
- [X] T047 [US6] Create validators in `lib/core/utils/validators.dart`
- [X] T048 [US6] Create formatters in `lib/core/utils/formatters.dart`
- [X] T049 [US6] Create logger utility in `lib/core/utils/logger.dart`
- [X] T050 [US6] Update app_routes.dart to reference api_endpoints.dart constants
- [X] T051 [US6] Test validator with sample input
- [X] T052 [US6] Test formatter with sample date

## Phase 9: Polish & Cross-Cutting Concerns

**Goal**: Verify all Success Criteria and prepare for subsequent phases

**Independent Test**: All success criteria verifiable; app ready for Phase 2

- [X] T053 [P] Add feature folder README explaining Clean Architecture layers
- [X] T054 [P] Verify all dependencies use get_it (not manual instantiation)
- [X] T055 [P] Verify no direct Supabase calls outside Data layer
- [X] T056 [P] Ensure failure messages are user-friendly
- [X] T057 [P] Final smoke test: app launches without crash
- [X] T058 [P] Create placeholder screens for upcoming phases (login, home placeholders)

## Summary

| Phase | User Story | Tasks | Independent Test |
|-------|----------|------|----------------|
| 1 | Setup | 4 | `flutter build` succeeds |
| 2 | Foundational | 7 | Core module compiles |
| 3 | US1 | 10 | Feature folder has all layers |
| 4 | US2 | 4 | Supabase client via get_it |
| 5 | US3 | 4 | Dependencies registered |
| 6 | US4 | 8 | Unknown route → 404 |
| 7 | US5 | 8 | Friendly error messages |
| 8 | US6 | 7 | Constants referenced |
| 9 | Polish | 6 | All SC verified |

**Total Tasks**: 58  
**MVP Scope**: Phases 1-3 (Setup, Foundational, Clean Architecture foundation) = 21 tasks

## Parallel Opportunities

- T003 (deps) parallel to T004 (build) no shared files
- T006, T007, T008 can run in parallel (different files)
- Phase 9: T053-T058 can run in parallel after Phase 8 complete

## Implementation Strategy

**MVP First** (Core Architecture Foundation):
- Complete Phases 1-3 (T001-T021)
- App builds but features are placeholder
- Enables subsequent phases to build on Clean Architecture

**Incremental Delivery**:
- Phase 1-2: Working project with dependencies
- Phase 3: Structured feature template ready
- Phase 4-8: Infrastructure completing per priority
- Phase 9: Production-ready foundation