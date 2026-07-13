---
description: "Task list for Provider Keys System feature implementation"
---

# Tasks: Provider Keys System

**Input**: Design documents from `/specs/005-provider-keys/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create provider keys feature directory structure in lib/features/provider_keys
- [x] T002 Initialize Flutter project dependencies for provider_keys feature
- [x] T003 [P] Configure linting and formatting rules for Dart 3.x

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Setup Supabase provider_keys table schema with proper constraints
- [x] T005 [P] Configure Supabase Vault for secure API key storage
- [x] T006 [P] Set up base ProviderKey entity and repository interfaces
- [x] T007 Configure get_it dependency injection for provider_keys feature
- [x] T008 Set up Cubit state management foundation for provider keys

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

## Phase 3: User Story 1 - Securely Store AI Provider API Keys (Priority: P1) 🎯 MVP

**Goal**: Allow users to securely store OpenAI and Gemini API keys using Supabase Vault, with server-side validation and secure storage

**Independent Test**: Can be tested by attempting to store a valid API key and verifying that the raw key is never stored in the database or exposed in client-side code, while the system can still use the key for AI operations through edge functions.

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**
> **Skipped per user request - no tests for MVP phase**

- [-] T009 [P] [US1] Create unit tests for ProviderKey entity validation in test/features/provider_keys/domain/entities/provider_key_test.dart
- [-] T010 [P] [US1] Create contract tests for add-key edge function in tests/contracts/provider_keys/add_key_test.dart
- [-] T011 [P] [US1] Create integration test for key storage flow in tests/integration/provider_keys/key_storage_test.dart

### Implementation for User Story 1

- [x] T012 [P] [US1] Create ProviderKey entity in lib/features/provider_keys/domain/entities/provider_key.dart
- [x] T013 [P] [US1] Create ProviderKey repository interface in lib/features/provider_keys/domain/repositories/provider_key_repository.dart
- [x] T014 [US1] Implement ProviderKey Supabase repository in lib/features/provider_keys/data/repositories/provider_key_repository_impl.dart (depends on T012, T013)
- [x] T015 [US1] Create add-key Supabase edge function in supabase/functions/add-key/index.ts
- [x] T016 [US1] Create ProviderKey Cubit for state management in lib/features/provider_keys/presentation/cubit/provider_key_cubit.dart
- [x] T017 [US1] Create provider key storage page in lib/features/provider_keys/presentation/pages/provider_key_storage_page.dart
- [x] T018 [US1] Implement key validation logic in edge function with timeout handling
- [x] T019 [US1] Add error handling and user feedback for invalid keys
- [x] T020 [US1] Connect UI to Cubit for key submission flow

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

## Phase 4: User Story 2 - Manage Multiple Provider Keys (Priority: P2)

**Goal**: Allow users to store and manage multiple API keys for different AI providers simultaneously

**Independent Test**: Can be tested by storing keys for both OpenAI and Gemini providers and verifying that both can be active simultaneously while maintaining separate validation statuses.

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T021 [P] [US2] Create unit tests for provider key management logic in test/features/provider_keys/domain/usecases/manage_provider_keys_test.dart
- [ ] T022 [P] [US2] Create contract tests for list-keys edge function in tests/contracts/provider_keys/list_keys_test.dart
- [ ] T023 [P] [US2] Create integration test for multiple key management in tests/integration/provider_keys/multiple_keys_test.dart

### Implementation for User Story 2

- [x] T024 [P] [US2] Create ProviderKey use cases for key management in lib/features/provider_keys/domain/usecases/
- [x] T025 [US2] Implement list-keys Supabase edge function in supabase/functions/list-keys/index.ts
- [x] T026 [US2] Create provider key management page in lib/features/provider_keys/presentation/pages/provider_key_storage_page.dart
- [x] T027 [US2] Implement provider filtering logic (OpenAI vs Gemini)
- [x] T028 [US2] Add UI components for displaying multiple keys with provider badges
- [x] T029 [US2] Implement key activation/deactivation logic with provider constraints

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

## Phase 5: User Story 3 - Activate Specific Provider Key (Priority: P2)

**Goal**: Allow users to designate which API key should be used for each AI provider

**Independent Test**: Can be tested by activating a specific key and verifying that the system uses that key for subsequent AI operations through the provider resolution logic.

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T030 [P] [US3] Create unit tests for key activation logic in test/features/provider_keys/domain/usecases/activate_provider_key_test.dart
- [ ] T031 [P] [US3] Create contract tests for activate-key edge function in tests/contracts/provider_keys/activate_key_test.dart
- [ ] T032 [P] [US3] Create integration test for key activation flow in tests/integration/provider_keys/key_activation_test.dart

### Implementation for User Story 3

- [x] T033 [P] [US3] Create ProviderKey use cases for key activation in lib/features/provider_keys/domain/usecases/
- [x] T034 [US3] Implement activate-key Supabase edge function in supabase/functions/activate-key/index.ts
- [x] T035 [US3] Update provider key management page to include activation controls
- [x] T036 [US3] Implement single active key per provider constraint logic
- [x] T037 [US3] Add automatic deactivation of previous key when new key is activated
- [x] T038 [US3] Create provider resolution service for determining which key to use

**Checkpoint**: At this point, User Stories 1, 2, and 3 should all work independently

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T039 [P] Add comprehensive error handling and logging across all provider key operations
- [x] T040 [P] Implement periodic key validation using Supabase cron jobs
- [x] T041 [P] Add documentation and code comments for all provider key functionality
- [x] T042 [P] Run security audit to ensure no API key exposure in client code
- [x] T043 [P] Validate implementation against quickstart.md test scenarios
- [x] T044 [P] Perform code cleanup and refactoring based on linting results
- [ ] T045 [P] Add unit test coverage for edge cases and error conditions

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Create unit tests for ProviderKey entity validation in test/features/provider_keys/domain/entities/provider_key_test.dart"
Task: "Create contract tests for add-key edge function in tests/contracts/provider_keys/add_key_test.dart"
Task: "Create integration test for key storage flow in tests/integration/provider_keys/key_storage_test.dart"

# Launch all models for User Story 1 together:
Task: "Create ProviderKey entity in lib/features/provider_keys/domain/entities/provider_key.dart"
Task: "Create ProviderKey repository interface in lib/features/provider_keys/domain/repositories/provider_key_repository.dart"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently