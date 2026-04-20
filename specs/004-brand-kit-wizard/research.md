# Research Findings: Brand Kit Wizard

## Research Tasks Completed

### 1. Best practices for implementing multi-step wizards in Flutter with Bloc/Cubit
**Decision**: Use a step-based approach with a BrandKitCubit that manages current step index and form data  
**Rationale**: 
- Provides clear state management for wizard progression
- Allows easy navigation between steps (forward/backward)
- Centralizes form data storage and validation
- Follows Bloc/Cubit best practices for form-like interfaces
**Alternatives considered**: 
- Separate Cubit for each step (overly complex, poor data sharing)
- Using only setState in StatefulWidgets (violates Cubit-only constraint)
- Using form-specific packages like flutter_form_bloc (adds unnecessary dependency)

### 2. Supabase edge function patterns for AI summary generation
**Decision**: Create a dedicated edge function that uses the same provider resolution logic as the image generation function  
**Rationale**: 
- Maintains consistency with existing AI provider architecture
- Centralizes provider selection logic in one place
- Follows the principle of never calling external AI APIs from Flutter
- Allows reuse of existing provider key management infrastructure
**Alternatives considered**:
- Creating a completely new provider resolution system (duplication of effort)
- Calling AI services directly from Flutter (violates constitution)
- Using a third-party summarization service (increases external dependencies)

### 3. Database schema design for BrandKit entity with proper constraints
**Decision**: 
- Table: brand_kits
- Columns: id (uuid, primary key), brand_id (uuid, unique, foreign key to brands.id), business_type (text), tone_of_voice (text), colors (text array), target_audience (text), ai_summary (text), created_at (timestamp), updated_at (timestamp)
- Unique constraint on brand_id to enforce one-to-one relationship
- Foreign key constraint with CASCADE on delete for brand_id  
**Rationale**:
- UUID primary keys match existing brands table pattern
- Unique constraint on brand_id enforces the business rule at database level
- Array type for colors allows multiple color selections per brand
- Timestamps for tracking creation and modification
- CASCADE delete ensures BrandKit is removed when brand is deleted
**Alternatives considered**:
- JSONB column for all attributes (less queryable, harder to validate)
- Separate tables for each attribute type (over-normalization)
- No unique constraint (application-level only, risk of race conditions)

### 4. State management patterns for "current selected brand" in frontend
**Decision**: Use a BrandCubit that maintains the currently selected brand ID and provides methods to update it  
**Rationale**:
- Centralizes brand selection state management
- Allows easy access to current brand ID throughout the app
- Follows existing patterns from BrandCubit in Phase 3
- Can be extended to include brand metadata as needed
**Alternatives considered**:
- Using a simple global variable (violates state management best practices)
- Storing in local storage only (not reactive, doesn't update UI)
- Passing brand_id through constructor parameters everywhere (prop drilling)

### 5. Provider resolution system consistency checks
**Decision**: Reuse the existing provider resolution logic from the image generation edge function exactly  
**Rationale**:
- Ensures identical behavior between image generation and brand summary generation
- Reduces code duplication and maintenance burden
- Leverages tested, existing infrastructure
- Maintains security boundaries (API keys never exposed to client)
**Alternatives considered**:
- Creating a separate resolution function for brand summaries (increases surface area)
- Allowing different provider configurations for different features (increases complexity)
- Hardcoding a specific provider for brand summaries (inflexible)

## Key Technical Decisions Summary

1. **Wizard Implementation**: BrandKitCubit with step index and form data management
2. **AI Generation**: Reuse existing image generation edge function provider resolution
3. **Database Design**: brand_kits table with unique constraint on brand_id
4. **Frontend State**: BrandCubit for tracking current selected brand
5. **Provider Consistency**: Exact reuse of existing provider resolution logic

All research tasks completed successfully. No outstanding NEEDS CLARIFICATION items remain from technical context evaluation.