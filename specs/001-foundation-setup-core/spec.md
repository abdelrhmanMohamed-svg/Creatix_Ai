# Feature Specification: Foundation Setup - Core Architecture

**Feature Branch**: `001-foundation-setup-core`  
**Created**: 2026-04-18  
**Status**: Draft  
**Input**: User description: "C:\rich_Sonic\Creatix\docs\flutter_implementaion_plan.md create a specify for # 🧱 Phase 1 — Foundation Setup (Core Architecture) only and make it very clean and detailed"

## User Scenarios & Testing

### User Story 1 - Development Team Uses Clean Architecture (Priority: P1)

As a Flutter developer, I want a well-organized codebase with clear separation of concerns, so that I can efficiently implement features without mixing business logic with UI code.

**Why this priority**: Clean Architecture is the foundation for the entire application. Without it, the codebase becomes unmaintainable as features grow. This enables independent testing, easier onboarding, and sustainable development velocity.

**Independent Test**: Can verify by checking that any feature follows the Data → Domain → Presentation flow, and no direct Supabase calls exist outside the Data layer.

**Acceptance Scenarios**:

1. **Given** a new feature request, **When** a developer creates the feature folder structure, **Then** it must contain Presentation (UI/Cubit), Domain (Entities/UseCases/Repository contracts), and Data (Repository implementations/DataSources) folders
2. **Given** any business logic code, **When** reviewing the file location, **Then** it must be in the Domain layer (UseCases) and not in Presentation (Cubits) or Data layers
3. **Given** a state management implementation, **When** examining the Cubit, **Then** it must only orchestrate calls to UseCases and emit states, never contain business rules

---

### User Story 2 - Application Connects to Supabase (Priority: P1)

As a mobile developer, I want the application to initialize and connect to Supabase on startup, so that authentication, database, storage, and edge functions are available throughout the app.

**Why this priority**: Supabase is the core backend infrastructure. Without proper initialization, no feature can function. This is a critical dependency for all subsequent phases.

**Independent Test**: Can verify by launching the app and confirming Supabase client is accessible via `Supabase.instance.client` throughout the app.

**Acceptance Scenarios**:

1. **Given** the application starts, **When** the main method runs, **Then** Supabase.initialize() must be called with valid URL and anon key before runApp()
2. **Given** a feature needs backend access, **When** it requests the Supabase client, **Then** the client must be available via dependency injection (get_it), not created directly
3. **Given** authentication is required, **When** the app checks auth state, **Then** Supabase auth must be properly configured and session persistence enabled

---

### User Story 3 - Dependency Injection Manages All Services (Priority: P1)

As a developer, I want all dependencies registered in a central location, so that I can easily swap implementations, manage singletons, and control object creation throughout the application.

**Why this priority**: Dependency injection enables loose coupling, testability, and maintainability. Using get_it as a central registry ensures consistent dependency management across all features.

**Independent Test**: Can verify by checking that all classes (DataSources, Repositories, UseCases, Cubits) are registered in the injection.dart file and retrieved via `GetIt.instance.get<SomeClass>()`.

**Acceptance Scenarios**:

1. **Given** a new DataSource is created, **When** the app starts, **Then** it must be registered in injection.dart with appropriate lifecycle (lazySingleton for external services, factory for transient objects)
2. **Given** a Cubit needs a UseCase, **When** the Cubit is instantiated, **Then** the UseCase must be injected via constructor, not created internally
3. **Given** testing is required, **When** writing unit tests, **Then** any dependency can be replaced with a mock by registering it in get_it before the test

---

### User Story 4 - Navigation Routes Are Centralized (Priority: P2)

As a user, I want consistent and predictable navigation throughout the app, so that I can move between screens without confusion and maintain context.

**Why this priority**: Centralized routing ensures maintainability as the app grows. Using onGenerateRoute allows type-safe route handling and 404 fallback.

**Independent Test**: Can verify by navigating to any route and confirming it resolves correctly, including invalid routes showing the fallback.

**Acceptance Scenarios**:

1. **Given** a route is defined in AppRoutes, **When** Navigator.pushNamed is called, **Then** onGenerateRoute must match the route to the correct screen widget
2. **Given** an unknown route is accessed, **When** the router receives the route, **Then** it must display a fallback screen (404) rather than crashing
3. **Given** the app launches, **When** determining the initial route, **Then** the router must check authentication state and route to the appropriate first screen (login or home)

---

### User Story 5 - Error Handling Is Consistent (Priority: P2)

As a user, I want clear and consistent error messages when something goes wrong, so that I understand what happened and can take appropriate action.

**Why this priority**: Consistent error handling improves user experience and reduces support burden. Centralized Failure classes enable proper error categorization and messaging.

**Independent Test**: Can verify by triggering various error conditions and confirming appropriate, user-friendly messages are displayed.

**Acceptance Scenarios**:

1. **Given** a network error occurs, **When** the error propagates to the UI, **Then** users must see a friendly message like "Unable to connect. Please check your internet connection."
2. **Given** an authentication error occurs, **When** the error propagates to the UI, **Then** users must see an appropriate auth-related message
3. **Given** an unknown error occurs, **When** the error propagates to the UI, **Then** users must see a generic fallback message without exposing technical details

---

### User Story 6 - Constants and Utilities Are Centralized (Priority: P3)

As a developer, I want all constants and utility functions in predictable locations, so that I can easily find and update them without searching through multiple files.

**Why this priority**: Centralized constants and utilities reduce duplication and ensure consistency across the codebase.

**Independent Test**: Can verify by checking that API endpoints, route names, and common utilities (validators, formatters) are in designated core folders.

**Acceptance Scenarios**:

1. **Given** a new API endpoint is added, **When** other code needs to call it, **Then** the endpoint must be referenced from constants, not hardcoded as a string
2. **Given** date formatting is needed, **When** displaying timestamps, **Then** a consistent formatter from utils must be used

---

### Edge Cases

- What happens when Supabase initialization fails due to invalid credentials?
- How does the app handle offline mode during dependency injection setup?
- What occurs when an unregistered dependency is requested from get_it?
- How does the router handle deep links that don't match any defined route?
- What displays when the core error handling system itself throws an exception?

## Requirements

### Functional Requirements

- **FR-001**: System MUST follow Clean Architecture with separate Data, Domain, and Presentation layers
- **FR-002**: System MUST use Cubit for state management only (no business logic in Cubits)
- **FR-003**: System MUST use get_it for dependency injection
- **FR-004**: System MUST initialize Supabase on app startup with valid URL and anon key
- **FR-005**: System MUST provide Supabase client access via dependency injection, not direct instantiation
- **FR-006**: System MUST implement centralized routing using onGenerateRoute
- **FR-007**: System MUST define all route names in AppRoutes constants
- **FR-008**: System MUST handle unknown routes with a fallback screen (404)
- **FR-009**: System MUST determine initial route based on authentication state
- **FR-010**: System MUST implement core Failure classes for error handling
- **FR-011**: System MUST implement utility functions (validators, formatters, loggers)
- **FR-012**: System MUST implement feature-based folder structure under lib/features/
- **FR-013**: System MUST use lazySingleton for external services (DataSources) in get_it
- **FR-014**: System MUST use factory for transient objects (Cubits) in get_it
- **FR-015**: System MUST organize code with clear separation: UI in Presentation, business logic in Domain, data access in Data

### Key Entities

- **SupabaseClient**: The main client for interacting with Supabase services (auth, database, storage, functions)
- **Failure**: Base class for error handling with categories (server, network, auth, cache, unknown)
- **AppRoutes**: Constants defining all navigation route names and paths
- **Injection**: Central dependency injection container configuration

## Success Criteria

### Measurable Outcomes

- **SC-001**: Developers can create a new feature following the three-layer structure without confusion
- **SC-002**: Any Supabase operation can be accessed via `GetIt.instance.get<SupabaseClient>()` throughout the app
- **SC-003**: All navigation routes are defined in a single location (AppRoutes) and handled by onGenerateRoute
- **SC-004**: Error scenarios display user-friendly messages within 500ms of error occurrence
- **SC-005**: Dependency injection setup completes before runApp() completes, ensuring all services are ready
- **SC-006**: No direct Supabase calls exist outside the Data layer (verifiable via code review)

## Assumptions

- Supabase project is already created with valid credentials (URL and anon key) available in environment config
- Flutter SDK is installed and configured at the latest stable version
- All team members understand Clean Architecture principles
- Provider key management (Phase 5) will handle API key security separately
- Edge Functions are created separately (not part of this phase) and called via Supabase functions client
- Feature development will follow the folder structure: lib/features/[feature_name]/
- No authentication check exists yet; initial route will default to a placeholder until Phase 2 implements auth