# Tasks: Brand Kit Wizard

**Input**: Design documents from `/specs/004-brand-kit-wizard/`
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

- [x] T001 Create feature directory structure for Brand Kit Wizard
- [x] T002 [P] Add required dependencies to pubspec.yaml (flutter_bloc, get_it, supabase_flutter, equatable, dartz)
- [x] T003 [P] Configure linting rules for Dart in analysis_options.yaml

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 [P] Set up Supabase client initialization in lib/core/services/supabase_service.dart
- [x] T005 [P] Configure get_it dependency injection container in lib/core/di/service_locator.dart
- [x] T006 [P] Create base Cubit state management classes in lib/core/state/
- [x] T007 [P] Implement secure storage service for API keys in lib/core/services/secure_storage.dart
- [x] T008 [P] Create base API exception handling in lib/core/exceptions/
- [x] T009 [P] Set up logging infrastructure in lib/core/services/logger.dart

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

## Phase 3: User Story 1 - Complete Brand Kit Wizard for a Specific Brand (Priority: P1) 🎯 MVP

**Goal**: Implement the 5-step wizard UI that guides users through defining a specific brand's identity (business type, tone of voice, color palette, target audience, and AI-generated summary) and stores the BrandKit entity linked to that brand via brand_id.

**Independent Test**: Can be fully tested by completing all wizard steps for a specific brand and verifying that a BrandKit entity is created and linked to that brand via brand_id in the Supabase database.

### Implementation for User Story 1

#### Step 1: Business Type Selection UI
- [x] T010 [P] [US1] Create business type selection screen in lib/features/brand_kit_wizard/ui/steps/business_type_step.dart
- [x] T011 [P] [US1] Implement business type options list with predefined values (restaurant, tech startup, consulting, etc.) in business_type_step.dart
- [x] T012 [US1] Add validation to ensure business type is selected before proceeding
- [x] T013 [US1] Connect business type selection to BrandKitWizardCubit state management

#### Step 2: Tone of Voice Selection UI
- [x] T014 [P] [US1] Create tone of voice selection screen in lib/features/brand_kit_wizard/ui/steps/tone_of_voice_step.dart
- [x] T015 [P] [US1] Implement tone of voice options list with predefined values (professional, friendly, authoritative, playful, etc.) in tone_of_voice_step.dart
- [x] T016 [US1] Add validation to ensure tone of voice is selected before proceeding
- [x] T017 [US1] Connect tone of voice selection to BrandKitWizardCubit state management

#### Step 3: Color Palette Selection UI
- [x] T018 [P] [US1] Create color palette selection screen in lib/features/brand_kit_wizard/ui/steps/color_palette_step.dart
- [x] T019 [P] [US1] Implement predefined color palette options with visual swatches in color_palette_step.dart
- [x] T020 [P] [US1] Add custom color picker functionality using hexadecimal input in color_palette_step.dart
- [x] T021 [US1] Add validation to ensure at least one color is selected before proceeding
- [x] T022 [US1] Connect color palette selection to BrandKitWizardCubit state management

#### Step 4: Target Audience Definition UI
- [x] T023 [P] [US1] Create target audience input screen in lib/features/brand_kit_wizard/ui/steps/target_audience_step.dart
- [x] T024 [US1] Implement multi-line text input field for target audience description in target_audience_step.dart
- [x] T025 [US1] Add validation to ensure target audience is not empty before proceeding
- [x] T026 [US1] Connect target audience input to BrandKitWizardCubit state management

#### Step 5: AI Summary Generation and Confirmation UI
- [x] T027 [P] [US1] Create brand summary generation screen in lib/features/brand_kit_wizard/ui/steps/summary_step.dart
- [x] T028 [US1] Implement display of AI-generated summary in read-only format in summary_step.dart
- [x] T029 [US1] Add edit functionality for manual summary override in summary_step.dart
- [x] T030 [US1] Add confirm button to save BrandKit in summary_step.dart
- [x] T031 [US1] Connect summary display and confirmation to BrandKitWizardCubit state management

#### Wizard Navigation and State Management
- [x] T032 [P] [US1] Create BrandKitWizardCubit to manage wizard state and step navigation in lib/features/brand_kit_wizard/state/brand_kit_wizard_cubit.dart
- [x] T033 [US1] Implement step progression logic (forward/backward navigation) in BrandKitWizardCubit
- [x] T034 [US1] Add data preservation between steps in BrandKitWizardCubit
- [x] T035 [US1] Implement current step and progress indicators in BrandKitWizardCubit
- [x] T036 [US1] Connect all wizard steps to BrandKitWizardCubit for state synchronization

#### BrandKit Data Model and Persistence
- [x] T037 [P] [US1] Create BrandKit data model in lib/features/brand_kit_wizard/models/brand_kit.dart
- [x] T038 [P] [US1] Implement BrandKit creation DTO in lib/features/brand_kit_wizard/models/brand_kit_creation_dto.dart
- [x] T039 [P] [US1] Implement BrandKit response DTO in lib/features/brand_kit_wizard/models/brand_kit_response_dto.dart
- [x] T040 [US1] Create BrandKit repository interface in lib/features/brand_kit_wizard/repository/brand_kit_repository.dart
- [x] T041 [US1] Implement BrandKit repository with Supabase persistence in lib/features/brand_kit_wizard/repository/brand_kit_repository_impl.dart
- [x] T042 [US1] Add unique constraint handling for brand_id in BrandKit repository implementation
- [x] T043 [US1] Implement create, read, update, delete operations for BrandKit in repository

#### Brand Detail Page Integration (Additional Work)
- [x] T044 [US1] Add TabBar with "Details" and "Brand Kit" tabs to update_brand_page.dart
- [x] T045 [US1] Implement empty state with "Create Brand Kit" button when no Brand Kit exists
- [x] T046 [US1] Implement Brand Kit summary view with "Edit Brand Kit" button
- [x] T047 [US1] Fix navigation from wizard after edit (Navigator.pop issue)
- [x] T048 [US1] Fix brand_summary field not saving to database
- [x] T049 [US1] Fix create vs update logic (duplicate key error)

**Status**: ✅ COMPLETED - All tasks for User Story 1 are done