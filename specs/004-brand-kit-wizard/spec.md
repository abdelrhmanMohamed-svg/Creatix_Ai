# Feature Specification: Brand Kit Wizard

**Feature Branch**: `004-brand-kit-wizard`  
**Created**: 2026-04-19  
**Status**: Draft  

## Constitution Compliance *(mandatory)*

This feature strictly adheres to the Creatix Constitution:

- [x] MUST follow Clean Architecture (Data/Domain/Presentation layers)

- [x] MUST use Cubit for state management only

- [x] MUST use get_it for dependency injection

- [x] MUST use Supabase for backend (auth, db, storage, edge functions)

- [x] MUST NEVER call external AI APIs from Flutter (use edge functions)

- [x] MUST support provider system with user API keys and fallback default provider

- [x] MUST keep API keys secure (no exposure in client)

- [x] MUST enforce feature-based structure


**Input**: User description: "C:\rich_Sonic\Creatix\docs\flutter_implementaion_plan.md create a fully detailed spec for 🎨 Phase 4 — Brand Kit Wizard only"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Complete Brand Kit Wizard for a Specific Brand (Priority: P1)

As a user creating or managing a brand, I want to complete a step-by-step wizard to define that specific brand's identity so that I can establish a consistent foundation for AI-generated content scoped to that brand.

**Why this priority**: This is the core onboarding experience for establishing brand-specific configurations that enable all subsequent brand-related features.

**Independent Test**: Can be fully tested by completing all wizard steps for a specific brand and verifying that a BrandKit entity is created and linked to that brand via brand_id.

**Acceptance Scenarios**:
1. **Given** a user has selected or created a brand, **When** they access the brand kit wizard for that brand and select a business type then proceed, **Then** they are shown the tone of voice selection screen
2. **Given** a user is on the tone of voice screen for a specific brand, **When** they select a tone and proceed, **Then** they are shown the color palette selection screen for that brand
3. **Given** a user is on the color palette screen for a specific brand, **When** they select colors and proceed, **Then** they are shown the target audience definition screen for that brand
4. **Given** a user is on the target audience screen for a specific brand, **When** they define their audience and proceed, **Then** they are shown a summary screen with AI-generated brand description for that brand
5. **Given** a user is on the summary screen for a specific brand, **When** they confirm their brand kit, **Then** the brand kit is saved and linked to that specific brand via brand_id

### User Story 2 - Navigate Between Wizard Steps for Brand Configuration (Priority: P2)

As a user configuring a brand's kit, I want to navigate back and forth between wizard steps so that I can review and modify my previous selections for that specific brand.

**Why this priority**: Provides flexibility in the brand configuration process and improves user experience by allowing corrections to brand-specific settings.

**Independent Test**: Can be tested by navigating through the wizard steps forward and backward for a specific brand while verifying that previously entered brand data is preserved.

**Acceptance Scenarios**:
1. **Given** a user has completed steps 1-3 of the wizard for a specific brand, **When** they navigate back to step 2 for that brand, **Then** their tone of voice selection for that brand is still present
2. **Given** a user has modified their tone of voice selection in step 2 for a specific brand after navigating back, **When** they proceed forward again for that brand, **Then** their updated selection is preserved

### User Story 3 - Brand-Specific Brand Kit Wizard Skipping (Priority: P3)

As a user who has already completed the brand kit wizard for a specific brand, I want to skip the wizard when accessing that brand's configuration so that I can directly work with that brand's established identity.

**Why this priority**: Prevents frustration for users who have already completed the onboarding process for specific brands while allowing them to configure multiple brands separately.

**Independent Test**: Can be tested by completing the wizard for a specific brand, accessing brand configuration for that brand, and verifying that the wizard is not shown again for that brand (while remaining available for other brands).

**Acceptance Scenarios**:
1. **Given** a user has completed and saved their brand kit for a specific brand, **When** they access that brand's configuration interface, **Then** they are taken directly to the brand's configured features interface
2. **Given** a user has not completed the brand kit wizard for a specific brand, **When** they access that brand's configuration interface, **Then** they are shown the wizard start screen for that brand
3. **Given** a user has completed the brand kit wizard for Brand A but not Brand B, **When** they switch to Brand B's configuration, **Then** they are shown the wizard start screen for Brand B

### Edge Cases
- What happens when a user closes the app mid-wizard for a specific brand? (Should save progress for that brand and resume from last step when returning to that brand's configuration)
- How does system handle network failures during wizard completion for a specific brand? (Should show error and allow retry for that brand's configuration)
- What happens when AI summary generation fails for a specific brand? (Should show error but allow manual summary input for that brand)
- What happens when a user attempts to access brand-scoped features without selecting a brand? (Should prompt user to select or create a brand first)
- How does the system handle a user configuring multiple brands sequentially? (Should maintain separate BrandKit entities for each brand)
- What happens when a user wants to update an existing brand kit? (Should allow re-running the wizard to modify the existing BrandKit for that brand)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST guide users through exactly 5 sequential steps when configuring a brand's kit: business type, tone of voice, color palette, target audience, and summary generation
- **FR-002**: System MUST allow users to navigate freely between completed steps while preserving all entered data for the specific brand being configured
- **FR-003**: System MUST validate that all required fields are completed before allowing progression to the next step in the brand kit wizard
- **FR-004**: System MUST generate an AI-powered brand summary based on user inputs from all previous steps for the specific brand being configured
- **FR-005**: System MUST store the completed BrandKit entity linked to a specific brand via brand_id (each brand has exactly one BrandKit)
- **FR-006**: System MUST prevent users from accessing brand-scoped features (generation, history, provider management) until the brand kit wizard is completed for that specific brand
- **FR-007**: System MUST allow users to skip the brand kit wizard on subsequent accesses to a specific brand after initial completion for that brand
- **FR-008**: System MUST provide clear visual indicators of current step and overall progress through the wizard for the specific brand being configured
- **FR-009**: System MUST support selection from predefined options for business type and tone of voice when configuring a brand's kit
- **FR-010**: System MUST allow both predefined and custom color selection for the color palette step when configuring a brand's kit
- **FR-011**: System MUST accept free-text input for target audience definition when configuring a brand's kit
- **FR-012**: System MUST display the AI-generated summary in a read-only format before final confirmation for the specific brand being configured
- **FR-013**: System MUST maintain a "current selected brand" state in the frontend that scopes all brand-specific operations
- **FR-014**: System MUST require brand_id as a parameter for all brand-scoped APIs and Edge Functions (including generation, history, and provider key management)
- **FR-015**: System MUST ensure that all brand-scoped features (image generation, history retrieval, provider key usage) operate exclusively within the context of the current selected brand
- **FR-016**: System MUST allow users to update an existing BrandKit by re-running the wizard, which will overwrite the existing BrandKit for that brand

### Key Entities *(include if feature involves data)*

- **Brand**: Represents a user's brand entity (defined in Phase 3)
  - Attributes: id (brand_id), user_id (reference to User), name, logo_url, created_at
- **BrandKit**: Represents a specific brand's complete identity definition containing business type, tone of voice, color palette, target audience, and AI-generated summary
  - Attributes: id, brand_id (reference to Brand), businessType (string), toneOfVoice (string), colors (list of color codes), targetAudience (string), aiSummary (string), createdAt (timestamp), updatedAt (timestamp)
  - Constraints: Each brand has exactly one BrandKit (one-to-one relationship with Brand)
    - **Clarification**: Uniqueness enforced at database level with unique constraint on brand_id
  - Lifecycle: BrandKit can be created via the wizard and updated by re-running the wizard (which overwrites the existing record)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete the brand kit wizard for a specific brand in under 4 minutes on first attempt
- **SC-002**: 80% of users who start the brand kit wizard for a specific brand complete all steps and save that brand's BrandKit
- **SC-003**: 90% of users report the brand kit wizard helped them clearly define a specific brand's identity (measured via post-wizard survey per brand)
- **SC-004**: AI-generated brand summaries receive an average rating of 4/5 or higher for relevance and usefulness to the specific brand
- **SC-005**: Users can successfully configure and switch between multiple brands, each with their own distinct BrandKit
- **SC-006**: System updates an existing BrandKit in under 2 seconds when re-running the wizard for the same brand

## Assumptions

- Users have basic understanding of their business type and target audience for each brand they configure
- The AI service for summary generation is available and responsive
- Users will complete the wizard for a specific brand in a single session (though progress is saved per brand)
- Predefined options for business type and tone of voice cover the majority of use cases across different brands
- Color selection uses standard hexadecimal color codes
- Users can clearly distinguish between different brands they manage
- Brand selection/persistence mechanism is handled by the application state management (outside scope of this feature but required for its function)
- Updates to BrandKit overwrite the previous version (no audit trail of historical BrandKit versions is maintained)

## Clarifications

### Session 2026-04-19
- Q: How should the uniqueness constraint (each brand has exactly one BrandKit) be implemented and enforced in the system?
  A: Database level constraint (unique index on brand_id in BrandKit table) - Chosen for strongest data integrity guarantees and prevention of race conditions
- Q: Which AI service should be used for generating the brand summary in the wizard?
  A: Use the same provider resolution system as image generation (user OpenAI/Gemini keys or Pixazo fallback) - **Reasoning**: Consistency with existing AI provider architecture in the system prevents duplication and leverages established patterns