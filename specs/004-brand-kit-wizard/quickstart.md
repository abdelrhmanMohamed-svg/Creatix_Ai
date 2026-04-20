# Quick Start: Brand Kit Wizard

## Overview
This guide provides developers with the essential information to implement the Brand Kit Wizard feature following the established patterns and architecture of the Creatix application.

## Prerequisites
- Completed Phase 3 (Brands System) implementation
- Understanding of Clean Architecture, Cubit, get_it, and Supabase integration
- Development environment set up per docs/flutter_implementaion_plan.md

## Implementation Steps

### 1. Database Setup
Apply the brand_kits table schema from data-model.md to your Supabase instance:
```sql
-- Execute this in your Supabase SQL editor
create table brand_kits (
  id uuid primary key default gen_random_uuid(),
  brand_id uuid references brands(id) on delete cascade not null unique,
  business_type text not null,
  tone_of_voice text not null,
  colors text[] not null,
  target_audience text not null,
  ai_summary text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable real-time subscriptions
alter publication supabase_realtime add table brand_kits;

-- Updated at trigger
create trigger update_brand_kits_updated_at
before update on brand_kits
for each row
execute procedure moddatetime (updated_at);

-- RLS Policies (copy from data-model.md)
```

### 2. Edge Function Deployment
Deploy the generate-brand-summary edge function:
1. Create the function in Supabase Edge Functions
2. Implement the provider resolution logic (identical to generate-image function)
3. Set appropriate secrets for Pixazo API key
4. Verify the function can access the brands table for ownership verification

### 3. Domain Layer Implementation
Create the following files in `lib/src/domain/brand_kit/`:

#### Entities
- `lib/src/domain/brand_kit/entities/brand_kit.dart`
- `lib/src/domain/brand_kit/entities/brand.dart` (if not already imported from brands feature)

#### UseCases
- `lib/src/domain/brand_kit/use_cases/create_brand_kit.dart`
- `lib/src/domain/brand_kit/use_cases/get_brand_kit.dart`
- `lib/src/domain/brand_kit/use_cases/update_brand_kit.dart`

### 4. Data Layer Implementation
Create the following files in `lib/src/data/brand_kit/`:

#### Data Sources
- `lib/src/data/brand_kit/sources/brand_kit_remote_data_source.dart`

#### Repositories
- `lib/src/data/brand_kit/repository/brand_kit_repository.dart`
- `lib/src/data/brand_kit/repository/brand_kit_repository_impl.dart`

#### Models
- `lib/src/data/brand_kit/models/brand_kit_model.dart`

### 5. Presentation Layer Implementation
Create the following files in `lib/src/presentation/brand_kit/`:

#### Cubits
- `lib/src/presentation/brand_kit/cubit/brand_kit_cubit.dart`
- `lib/src/presentation/brand_kit/cubit/brand_kit_state.dart`

#### Pages/Wizards
- `lib/src/presentation/brand_kit/pages/brand_kit_wizard.dart`
- `lib/src/presentation/brand_kit/pages/step/business_type_step.dart`
- `lib/src/presentation/brand_kit/pages/step/tone_of_voice_step.dart`
- `lib/src/presentation/brand_kit/pages/step/color_palette_step.dart`
- `lib/src/presentation/brand_kit/pages/step/target_audience_step.dart`
- `lib/src/presentation/brand_kit/pages/step/summary_step.dart`

#### Widgets
- Reusable form fields, validation widgets, navigation controls

### 6. Dependency Injection
Register new dependencies in `lib/src/core/di/injection.dart`:
```dart
// BrandKit UseCases
sl.registerLazySingleton(() => CreateBrandKit(sl()));
sl.registerLazySingleton(() => GetBrandKit(sl()));
sl.registerLazySingleton(() => UpdateBrandKit(sl()));

// BrandKit Repository
sl.registerLazySingleton<BrandKitRepository>(
  () => BrandKitRepositoryImpl(sl()),
);

// BrandKit DataSource
sl.registerLazySingleton(
  () => BrandKitRemoteDataSource(sl()),
);

// BrandKit Cubit
sl.registerFactory(() => BrandKitCubit(
  sl(), // GetBrandKit
  sl(), // CreateBrandKit
  sl(), // UpdateBrandKit
));
```

### 7. Integration Points
#### Update BrandCubit (from Phase 3) to:
- Track current selected brand ID
- Provide methods to update selected brand
- Listen for brand selection changes

#### Update App Routing to:
- Protect brand-scoped routes behind brand selection
- Redirect to brand kit wizard when accessing brand configuration without completed BrandKit

#### Update Provider Keys and Generation features to:
- Require brand_id parameter for all operations
- Verify BrandKit exists before allowing access to features

## Key Implementation Notes

### State Management
- BrandKitCubit should manage:
  - Current wizard step index
  - Form data for each step
  - Loading/error states
  - Success state upon completion
- Consider using a separate BrandSelectionCubit (or extending BrandCubit) for tracking current selected brand

### Navigation Logic
- Wizard should support free navigation between completed steps
- Validate required fields before allowing step progression
- On completion, save BrandKit and navigate to brand configuration dashboard
- Implement back button handling appropriately

### Form Validation
- Each step should validate its specific fields
- Show clear error messages for missing/invalid data
- Enable next button only when current step is valid

### AI Summary Generation
- Call generate-brand-summary edge function on final step
- Show loading state during generation
- Allow manual edit/override of generated summary
- Handle API errors gracefully with retry options

### Updates vs Creation
- Same wizard flow used for both creating and updating BrandKit
- Pre-populate form with existing data when updating
- Use update use case instead of create use case when BrandKit exists

## Testing Guidelines

### Unit Tests
- Test all UseCases with mocked repositories
- Test Cubit state transitions
- Test form validation logic
- Test edge function request/response handling

### Widget Tests
- Test each wizard step UI
- Test navigation between steps
- Test form submission and validation display

### Integration Tests
- Test complete wizard flow with mocked Supabase
- Test BrandKit persistence and retrieval
- Test edge case scenarios (network failures, etc.)

## Performance Considerations
- Debounce form validation where appropriate
- Lazy load heavy assets (color pickers, etc.)
- Optimize edge function execution time
- Consider caching frequently accessed BrandKit data

## Security Checklist
- [ ] All Supabase calls go through repositories (no direct client access in UI/Cubit)
- [ ] API keys never exposed in client code or logs
- [ ] Brand ownership verified for all operations
- [ ] Input validation on both client and server sides
- [ ] RLS policies properly configured and tested
- [ ] Error messages don't leak sensitive information