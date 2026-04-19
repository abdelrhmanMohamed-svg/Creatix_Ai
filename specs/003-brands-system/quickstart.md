# Quick Start: Brands System

## Overview
This guide provides a quick overview of how to work with the Brands System feature in the Creatix mobile application.

## Feature Purpose
The Brands System allows users to manage their business identities by creating, viewing, updating, and deleting brands. Each brand represents a business entity that belongs to a specific user.

## Key Components

### Data Model
- **Brand Entity**: Represents a business with id, userId, name, optional logoUrl, and creation timestamp
- **Uniqueness Constraint**: Brand names must be unique per user (combination of userId and name must be unique)
- **Validation**: Brand names must be 1-100 characters containing only letters, numbers, spaces, hyphens, and underscores

### Architecture Layers
Following Clean Architecture principles:

1. **Data Layer**: 
   - Supabase client for database operations
   - BrandModel for data transfer
   - BrandRepositoryImpl for Supabase-specific implementations

2. **Domain Layer**:
   - BrandEntity for domain representation
   - BrandRepository interface (contract)
   - UseCases: GetBrands, CreateBrand, UpdateBrand, DeleteBrand

3. **Presentation Layer**:
   - BrandCubit for state management
   - Brand UI components (screens, widgets, dialogs)
   - Brand states: BrandLoading, BrandLoaded, BrandError, BrandEmpty

## Getting Started

### Prerequisites
- Flutter SDK installed
- Supabase project configured with brands table
- get_it dependency injection initialized
- User authentication system in place

### Key Implementation Files

```
lib/features/brands/
├── data/
│   ├── models/
│   │   └── brand_model.dart
│   ├── datasources/
│   │   └── brand_remote_data_source.dart
│   └── repositories/
│       └── brand_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── brand_entity.dart
│   ├── repositories/
│   │   └── brand_repository.dart
│   └── usecases/
│       ├── get_brands.dart
│       ├── create_brand.dart
│       ├── update_brand.dart
│       └── delete_brand.dart
└── presentation/
    ├── cubit/
    │   └── brand_cubit.dart
    └── pages/
        ├── brands_page.dart
        ├── create_brand_page.dart
        └── update_brand_page.dart
```

### Usage Example

#### Creating a Brand
```dart
// Through the usecase
final createBrand = sl<CreateBrand>();
await createBrand(BrandParams(
  name: 'My Business',
  logoUrl: 'https://example.com/logo.png',
));

// Refresh brand list
final getBrands = sl<GetBrands>();
final brands = await getBrands(NoParams());
```

#### Updating a Brand
```dart
final updateBrand = sl<UpdateBrand>();
await updateBrand(BrandParams(
  id: 'brand-id',
  name: 'Updated Business Name',
  logoUrl: 'https://example.com/new-logo.png',
));
```

#### Deleting a Brand
```dart
final deleteBrand = sl<DeleteBrand>();
await deleteBrand(BrandParams(id: 'brand-id'));
```

## State Management

The BrandCubit manages the state of brand operations:
- BrandLoading: When operations are in progress
- BrandLoaded: When brands are successfully retrieved
- BrandError: When an operation fails
- BrandEmpty: When user has no brands

## Dependencies

This feature relies on:
- flutter_bloc: For Cubit state management
- get_it: For dependency injection
- supabase_flutter: For Supabase integration
- equatable: For value-based equality checks
- dartz: For functional error handling

## Testing

Unit tests should cover:
- All usecases (success and failure cases)
- Repository implementations
- Cubit state transitions
- Validation functions

Widget tests should cover:
- Brand UI components
- Form validation and submission
- Loading and error states
- Empty state handling