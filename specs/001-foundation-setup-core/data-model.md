# Data Model: Foundation Setup - Core Architecture

**Phase**: 1 - Design  
**Date**: 2026-04-18  
**Feature**: 001-foundation-setup-core

## Entities

### SupabaseClient

**Description**: Main client for interacting with Supabase services (auth, database, storage, functions)

**Fields**: N/A (client wrapper class)

**Lifecycle**: Singleton, initialized on app startup

**Access**: Via get_it: `GetIt.instance.get<SupabaseClient>()`

---

### Failure

**Description**: Base class for error handling with categories

**Fields**:
- `message` (String): User-friendly error message
- `code` (String?): Optional error code for logging

**Categories**:
- `server` - Server-side errors
- `network` - Network connectivity issues
- `auth` - Authentication/authorization errors
- `cache` - Local storage errors
- `unknown` - Unclassified errors

**Usage**: Returned from UseCases via `Either<Failure, Success>`

---

### AppRoutes

**Description**: Constants defining all navigation route names and paths

**Structure**: Static class with route name constants

**Example Routes**:
- `/` - Initial route (redirects based on auth state)
- `/login` - Login screen
- `/home` - Home screen
- `/404` - Unknown route fallback

---

### Injection

**Description**: Central dependency injection container configuration

**Location**: `lib/core/di/injection.dart`

**Registrations**:
- `lazySingleton` - DataSources, external services
- `factory` - Cubits, UseCases where new instance needed

---

## Relationships

```
main.dart → Supabase.initialize() → SupabaseClient (singleton)
                                           ↓
                          get_it (Injection container)
                            ↓              ↓            ↓
                    DataSources      Repositories     Cubits
                            ↓              ↓
                        SupabaseClient
```

## Validation Rules

- All error messages must be user-friendly (no technical jargon)
- Route names must be defined as constants, not hardcoded strings
- All dependencies must be registered before `runApp()` completes