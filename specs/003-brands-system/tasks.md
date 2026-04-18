# Tasks: Brands System

**Input**: Design documents from `/specs/003-brands-system/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

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

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize Dart Flutter project with flutter_bloc, get_it, supabase_flutter, equatable, dartz dependencies
- [ ] T003 [P] Configure linting and formatting tools (dartfmt)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T004 Setup Supabase brands table schema with proper constraints
- [ ] T005 [P] Initialize get_it dependency injection container
- [ ] T006 [P] Configure Supabase client singleton
- [ ] T007 Create base exception handling for Supabase operations
- [ ] T008 Setup environment configuration management for Supabase credentials
- [ ] T009 Create abstract BrandRepository interface

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - View Brand List (Priority: P1) 🎯 MVP

**Goal**: As a user, I want to view my list of brands so that I can manage my business identities

**Independent Test**: Can be fully tested by navigating to the brands screen and verifying that the list of brands is displayed correctly

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

### Implementation for User Story 1

- [ ] T010 [P] [US1] Create BrandEntity in lib/features/brands/domain/entities/brand_entity.dart
- [ ] T011 [P] [US1] Create BrandModel in lib/features/brands/data/models/brand_model.dart
- [ ] T012 [P] [US1] Create BrandRemoteDataSource in lib/features/brands/data/datasources/brand_remote_data_source.dart
- [ ] T013 [P] [US1] Create BrandRepositoryImpl in lib/features/brands/data/repositories/brand_repository_impl.dart
- [ ] T014 [US1] Create GetBrands usecase in lib/features/brands/domain/usecases/get_brands.dart
- [ ] T015 [US1] Create BrandCubit in lib/features/brands/presentation/cubit/brand_cubit.dart
- [ ] T016 [US1] Create BrandsPage in lib/features/brands/presentation/pages/brands_page.dart
- [ ] T017 [US1] Implement brand list loading states (loading, loaded, error, empty)
- [ ] T018 [US1] Add Supabase query to fetch brands by user_id
- [ ] T019 [US1] Implement loading and error UI states
- [ ] T020 [US1] Implement empty state message when no brands exist
- [ ] T021 [US1] Display brand name and logo in list items

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Create Brand (Priority: P1)

**Goal**: As a user, I want to create a new brand so that I can add a new business identity to the system

**Independent Test**: Can be fully tested by attempting to create a brand with valid data and verifying it appears in the brand list

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

### Implementation for User Story 2

- [ ] T022 [P] [US2] Create CreateBrand usecase in lib/features/brands/domain/usecases/create_brand.dart
- [ ] T023 [P] [US2] Create brand name validation function (1-100 chars, letters/numbers/spaces/hyphens/underscores)
- [ ] T024 [US2] Create CreateBrandPage in lib/features/brands/presentation/pages/create_brand_page.dart
- [ ] T025 [US2] Implement form with name input and optional logo upload
- [ ] T026 [US2] Add real-time validation feedback for brand name
- [ ] T027 [US2] Implement form submission with loading state
- [ ] T028 [US2] Handle unique constraint violation error (duplicate brand name)
- [ ] T029 [US2] Show success message and navigate back to brands list
- [ ] T030 [US2] Integrate with BrandCubit to refresh brand list after creation

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Update Brand (Priority: P2)

**Goal**: As a user, I want to edit an existing brand so that I can keep my business information up to date

**Independent Test**: Can be fully tested by selecting an existing brand, modifying its details, and verifying the changes are persisted

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

### Implementation for User Story 3

- [ ] T031 [P] [US3] Create UpdateBrand usecase in lib/features/brands/domain/usecases/update_brand.dart
- [ ] T032 [US3] Create UpdateBrandPage in lib/features/brands/presentation/pages/update_brand_page.dart
- [ ] T033 [US3] Implement form pre-filled with existing brand data
- [ ] T034 [US3] Add real-time validation feedback for brand name
- [ ] T035 [US3] Implement form submission with loading state
- [ ] T036 [US3] Handle unique constraint violation error (duplicate brand name)
- [ ] T037 [US3] Show success message and navigate back to brands list
- [ ] T038 [US3] Integrate with BrandCubit to refresh brand list after update

**Checkpoint**: At this point, User Stories 1, 2, AND 3 should all work independently

---

## Phase 6: User Story 4 - Delete Brand (Priority: P2)

**Goal**: As a user, I want to remove a brand so that I can clean up unused business identities

**Independent Test**: Can be fully tested by deleting a brand and verifying it no longer appears in the brand list

### Tests for User Story 4 (OPTIONAL - only if tests requested) ⚠️

### Implementation for User Story 4

- [ ] T039 [P] [US4] Create DeleteBrand usecase in lib/features/brands/domain/usecases/delete_brand.dart
- [ ] T040 [US4] Implement swipe-to-delete gesture in BrandsPage
- [ ] T041 [US4] Add confirmation dialog before deletion
- [ ] T042 [US4] Implement deletion with loading state
- [ ] T043 [US4] Handle deletion errors gracefully
- [ ] T044 [US4] Show success message and update brand list
- [ ] T045 [US4] Integrate with BrandCubit to refresh brand list after deletion

**Checkpoint**: At this point, all User Stories (1, 2, 3, 4) should work independently

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T046 [P] Add unit tests for all usecases and repository implementations
- [ ] T047 [P] Add widget tests for all UI components
- [ ] T048 [P] Documentation updates in docs/
- [ ] T049 [P] Code cleanup and refactoring
- [ ] T050 [P] Performance optimization across all stories
- [ ] T51 [P] Additional unit tests (if requested) in tests/
- [ ] T052 [P] Security hardening (verify API keys never exposed in client)
- [ ] T053 [P] Run quickstart.md validation
- [ ] T054 [P] Implement skeleton loading states for better perceived performance
- [ ] T055 [P] Add proper error logging for Supabase operations
- [ ] T056 [P] Handle network failure scenarios gracefully
- [ ] T057 [P] Implement brand logo upload/storage functionality (basic implementation)
- [ ] T058 [P] Validate Supabase RLS policies match user_id restrictions
- [ ] T059 [P] Add analytics tracking for brand operations (optional)
- [ ] T060 [P] Implement brand search/filter functionality (stretch goal)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3 → P4)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable
- **User Story 4 (P4)**: Can start after Foundational (Phase 2) - May integrate with US1/US2/US3 but should be independently testable

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

---

## Parallel Example: User Story 1

```bash
# Launch all tasks for User Story 1 together:
Task: "Create BrandEntity in lib/features/brands/domain/entities/brand_entity.dart"
Task: "Create BrandModel in lib/features/brands/data/models/brand_model.dart"
Task: "Create BrandRemoteDataSource in lib/features/brands/data/datasources/brand_remote_data_source.dart"
```

---

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
5. Add User Story 4 → Test independently → Deploy/Demo
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (View Brand List)
   - Developer B: User Story 2 (Create Brand)
   - Developer C: User Story 3 (Update Brand)
   - Developer D: User Story 4 (Delete Brand)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing (if tests are included)
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence