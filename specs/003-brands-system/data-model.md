# Data Model: Brands System

## Entities

### Brand
Represents a business entity in the system that belongs to a user.

**Fields**:
- `id` (string): Unique identifier for the brand (UUID)
- `userId` (string): Reference to the user who owns the brand (UUID)
- `name` (string): Brand name (1-100 characters, letters/numbers/spaces/hyphens/underscores only)
- `logoUrl` (string?): Optional URL to the brand logo image stored in Supabase storage
- `createdAt` (DateTime): Timestamp when the brand was created

**Constraints**:
- Combination of `userId` and `name` must be unique (no duplicate brand names per user)
- `name` cannot be empty and must follow validation pattern: `^[a-zA-Z0-9 _-]{1,100}$`
- `logoUrl`, if provided, must be a valid URL pointing to an image asset

**Relationships**:
- Belongs to a User (one-to-many: User has many Brands)

## State Transitions

The Brand entity follows a simple lifecycle:
1. **Created**: Brand is added to the system via create operation
2. **Updated**: Brand properties (name, logoUrl) can be modified
3. **Deleted**: Brand is removed from the system (soft delete or hard delete based on implementation choice)

Note: For this implementation, we'll use hard delete as there's no indication that historical brand data needs to be preserved beyond the deletion operation.

## Database Schema (Supabase)

### brands table
```sql
create table brands (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  logo_url text null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  
  constraint brands_user_id_name_unique unique (user_id, name)
);
```

**Indexes**:
- Primary key on `id`
- Foreign key index on `user_id` (automatically created by reference)
- Unique constraint index on `(user_id, name)` for duplicate prevention
- Consider adding index on `created_at` for sorting if frequently queried by date

## Validation Rules

### Brand Name Validation
- Required field
- Length: 1-100 characters
- Pattern: `^[a-zA-Z0-9 _-]+$` (letters, numbers, spaces, hyphens, underscores)
- No leading/trailing whitespace (trimmed before validation)

### Logo URL Validation (Optional)
- If provided, must be a valid URL format
- Should point to an image asset (validation can be basic URL format check)
- Actual image validation can be handled by display components

## Data Transfer Objects (DTOs)

### BrandModel (Data Layer)
```dart
class BrandModel {
  final String id;
  final String userId;
  final String name;
  final String? logoUrl;
  final DateTime createdAt;

  BrandModel({
    required this.id,
    required this.userId,
    required this.name,
    this.logoUrl,
    required this.createdAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        logoUrl: json['logo_url'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'logo_url': logoUrl,
        'created_at': createdAt.toIso8601String(),
      };
}
```

### BrandEntity (Domain Layer)
```dart
class BrandEntity {
  final String id;
  final String userId;
  final String name;
  final String? logoUrl;
  final DateTime createdAt;

  BrandEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.logoUrl,
    required this.createdAt,
  });

  // Factory to create from model
  factory BrandEntity.fromModel(BrandModel model) => BrandEntity(
        id: model.id,
        userId: model.userId,
        name: model.name,
        logoUrl: model.logoUrl,
        createdAt: model.createdAt,
      );
}
```