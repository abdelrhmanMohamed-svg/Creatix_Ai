# Feature Specification: Provider Keys System

**Feature Branch**: `[005-provider-keys]`  
**Created**: 2026-04-22  
**Status**: Draft  
**Input**: User description: "in C:\rich_Sonic\Creatix\docs\flutter_implementaion_plan.md create a spec for # 🔑 Phase 5 — Provider Keys System (Production-Ready)
only and ask me qustions to make a spec very clear"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Securely Store AI Provider API Keys (Priority: P1)

As a user, I want to securely store my OpenAI and Gemini API keys so that I can use premium AI services for image generation without exposing my keys to potential security threats.

**Why this priority**: API key security is fundamental to the system's trustworthiness and prevents unauthorized access to paid AI services.

**Independent Test**: Can be tested by attempting to store a valid API key and verifying that the raw key is never stored in the database or exposed in client-side code, while the system can still use the key for AI operations through edge functions.

**Acceptance Scenarios**:
1. **Given** user is authenticated, **When** user submits a valid OpenAPI key through the UI, **Then** the key is stored in Supabase Vault and only the vault secret ID is stored in the database
2. **Given** user submits an invalid API key, **When** the key validation fails, **Then** the system rejects the key and shows an appropriate error message

### User Story 2 - Manage Multiple Provider Keys (Priority: P2)

As a user, I want to store and manage multiple API keys for different AI providers so that I can switch between services based on my needs and availability.

**Why this priority**: Flexibility to use different AI providers enhances user experience and provides fallback options when one service has issues.

**Independent Test**: Can be tested by storing keys for both OpenAI and Gemini providers and verifying that both can be active simultaneously while maintaining separate validation statuses.

**Acceptance Scenarios**:
1. **Given** user has an active OpenAI key, **When** user adds a Gemini key, **Then** both keys can be active simultaneously
2. **Given** user has keys for both providers, **When** user requests their key list, **Then** system returns both keys with their respective providers and statuses

### User Story 3 - Activate Specific Provider Key (Priority: P2)

As a user, I want to designate which API key should be used for each AI provider so that I can control which service is used for image generation.

**Why this priority**: Allows users to prefer one service over another or rotate keys for rate limit management.

**Independent Test**: Can be tested by activating a specific key and verifying that the system uses that key for subsequent AI operations through the provider resolution logic (handled in Phase 6).

**Acceptance Scenarios**:
1. **Given** user has multiple keys for the same provider, **When** user activates one of them, **Then** only that key is marked as active for that provider
2. **Given** user activates a new key for a provider, **When** system checks for active keys, **Then** previously active key for same provider is automatically deactivated

### Edge Cases

- What happens when user tries to add a key that's already stored?
- How does system handle network timeouts during key validation?
- What occurs when Supabase Vault service is temporarily unavailable?
- How are keys handled when user account is deleted?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST follow Clean Architecture with separate Data, Domain, and Presentation layers
- **FR-002**: System MUST use Cubit for state management only
- **FR-003**: System MUST use get_it for dependency injection
- **FR-004**: System MUST use Supabase for all backend functionality (auth, db, storage, edge functions)
- **FR-005**: System MUST NEVER call external AI APIs from Flutter code (use edge functions instead)
- **FR-006**: System MUST support secure storage of AI provider API keys (OpenAI, Gemini) using Supabase Vault
- **FR-007**: System MUST NEVER store raw API keys in the database or expose them to client-side code
- **FR-008**: System MUST validate API keys server-side through Edge Functions before storage
- **FR-009**: System MUST support up to two API keys per user (one for OpenAI, one for Gemini)
- **FR-010**: System MUST enforce only one active key per AI provider per user
- **FR-016**: System MUST allow brands to optionally reference a specific provider key (enabling different brands to use different provider keys)
- **FR-017**: System MUST map API validation responses to internal statuses: 200→valid, 401/403→invalid, 429→rate_limited
- **FR-018**: System MUST handle key validation timeouts (5 seconds) with one retry attempt

### Key Entities

- **ProviderKey**: Represents an AI provider API key owned by a user, containing provider type (OpenAI or Gemini), validation status, active status, and reference to securely stored key in Vault
- **Brand**: Business entity that may optionally reference a specific provider key for AI generation, allowing different brands to use different provider keys

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can successfully store and validate an API key in under 10 seconds
- **SC-002**: 95% of API key validation requests are completed successfully without errors
- **SC-003**: System prevents any exposure of raw API keys in client-side code, network requests, or logs
- **SC-004**: Users can switch between active keys for different providers without application restart
- **SC-005**: System handles rate limiting gracefully, showing appropriate status when providers return 429 responses
- **SC-006**: Brands can be assigned specific provider keys, allowing different brands to use different AI providers

## Assumptions

- Users have access to valid API keys from OpenAI or Gemini providers
- Supabase Vault service is available and properly configured for the project
- Users understand the difference between AI providers and their respective pricing/models
- The system will be used in conjunction with Phase 6 (Image Generation System) for actual AI operations
- Network connectivity is reliable for Edge Function calls to validate keys

## Clarifications

### Session 2026-04-22

**Question 1: Data Scale Expectations**
**Context**: The specification mentions supporting multiple API keys per user but doesn't specify expected scale.
**What we need to know**: What is the expected maximum number of API keys a single user might store?
**Suggested Answer**: 5 - Reasonable balance between flexibility and resource management
**Options**:
A. 3 - Conservative limit to minimize complexity
B. 5 - Moderate limit allowing flexibility for major providers
C. 10 - Higher limit for power users
D. Unlimited - No artificial constraints

**Answer**: 2 (one for Gemini, one for OpenAI) - User can store one key per provider type and assign different keys to different brands