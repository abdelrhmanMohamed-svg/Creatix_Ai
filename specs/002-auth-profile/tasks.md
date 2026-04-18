# Tasks: Authentication + Profile

**Feature**: Authentication + Profile (002-auth-profile)
**Date**: 2026-04-18

## Phase 1: Setup

- [X] T001 Install Flutter dependencies (flutter_bloc, equatable, dartz, get_it, supabase_flutter)
- [X] T002 Configure Supabase in lib/core/supabase/supabase_client.dart
- [X] T003 Create profiles table in Supabase database (see data-model.md SQL)

## Phase 2: Foundational

- [X] T004 Create auth feature structure in lib/features/auth/
- [X] T005 Create profile feature structure in lib/features/profile/
- [X] T006 Register dependencies in lib/core/di/injection.dart

## Phase 3: User Story 1 - Registration (P1)

- [X] T007 [US1] Create User entity in lib/features/auth/domain/entities/user.dart
- [X] T008 [US1] Create AuthRepository interface in lib/features/auth/domain/repositories/auth_repository.dart
- [X] T009 [US1] Create AuthRemoteDatasource in lib/features/auth/data/datasources/auth_remote_datasource.dart
- [X] T010 [US1] Create AuthRepositoryImpl in lib/features/auth/data/repositories/auth_repository_impl.dart
- [X] T011 [US1] Create Register usecase in lib/features/auth/domain/usecases/register.dart
- [X] T012 [US1] Create AuthState in lib/features/auth/presentation/cubit/auth_state.dart
- [X] T013 [US1] Create AuthCubit in lib/features/auth/presentation/cubit/auth_cubit.dart
- [X] T014 [US1] Create RegisterPage in lib/features/auth/presentation/pages/register_page.dart

## Phase 4: User Story 2 - Login (P1)

- [X] T015 [US2] Create Login usecase in lib/features/auth/domain/usecases/login.dart
- [X] T016 [US2] Implement login method in AuthRepositoryImpl
- [X] T017 [US2] Add login to AuthCubit
- [X] T018 [US2] Create LoginPage in lib/features/auth/presentation/pages/login_page.dart

## Phase 5: User Story 3 - Logout (P2)

- [X] T019 [US3] Create Logout usecase in lib/features/auth/domain/usecases/logout.dart
- [X] T020 [US3] Implement logout in AuthRepositoryImpl
- [X] T021 [US3] Add logout to AuthCubit

## Phase 6: User Story 4 - Profile Viewing (P2)

- [X] T022 [US4] Create Profile entity in lib/features/profile/domain/entities/profile.dart
- [X] T023 [US4] Create ProfileRepository interface in lib/features/profile/domain/repositories/profile_repository.dart
- [X] T024 [US4] Create ProfileRemoteDatasource in lib/features/profile/data/datasources/profile_remote_datasource.dart
- [X] T025 [US4] Create ProfileRepositoryImpl in lib/features/profile/data/repositories/profile_repository_impl.dart
- [X] T026 [US4] Create GetProfile usecase in lib/features/profile/domain/usecases/get_profile.dart
- [X] T027 [US4] Create ProfileState in lib/features/profile/presentation/cubit/profile_state.dart
- [X] T028 [US4] Create ProfileCubit in lib/features/profile/presentation/cubit/profile_cubit.dart
- [X] T029 [US4] Create ProfilePage in lib/features/profile/presentation/pages/profile_page.dart

## Phase 7: User Story 5 - Profile Update (P2)

- [X] T030 [US5] Create UpdateProfile usecase in lib/features/profile/domain/usecases/update_profile.dart
- [X] T031 [US5] Implement update in ProfileRepositoryImpl
- [X] T032 [US5] Add update to ProfileCubit
- [X] T033 [US5] Create EditProfilePage in lib/features/profile/presentation/pages/edit_profile_page.dart

## Phase 8: Polish

- [X] T034 Add session persistence via Cubit checkAuth on app launch
- [X] T035 Add error handling for network failures
- [X] T036 Add loading states to all pages
- [X] T037 Verify RLS policies work correctly

## Summary

| Statistic | Value |
|-----------|-------|
| Total Tasks | 37 |
| User Stories | 5 |
| Phases | 8 |
| MVP Scope | User Story 1 + 2 (Registration + Login) |

## Independent Test Criteria

- **US1**: Can create account and is logged in automatically
- **US2**: Can log in and stay logged in after app restart
- **US3**: Can log out and session is cleared
- **US4**: Can view profile after login
- **US5**: Can update profile and changes persist