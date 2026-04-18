# Quickstart: Authentication + Profile

**Phase**: 1 - Design  
**Date**: 2026-04-18  
**Feature**: Authentication + Profile (002-auth-profile)

## Prerequisites

- Flutter SDK 3.x installed
- Supabase project configured
- Supabase credentials in environment variables

## Setup Steps

### 1. Install Dependencies

```bash
flutter pub add flutter_bloc equatable dartz get_it supabase_flutter
```

### 2. Configure Supabase

In your app initialization:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
  runApp(const MyApp());
}
```

### 3. Database Setup

Run the SQL from `data-model.md` in Supabase SQL Editor:

```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
-- (Add RLS policies as shown in data-model.md)
```

### 4. Feature Structure

After implementation, the structure will be:

```
lib/features/auth/
├── data/
│   ├── datasources/auth_remote_datasource.dart
│   ├── models/user_model.dart
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/user.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/
│       ├── login.dart
│       ├── logout.dart
│       ├── register.dart
│       └── observe_auth_state.dart
└── presentation/
    ├── cubit/auth_cubit.dart
    ├── cubit/auth_state.dart
    └── pages/
        ├── login_page.dart
        └── register_page.dart

lib/features/profile/
├── data/
├── domain/
└── presentation/
```

### 5. Dependency Injection

Register in `injection.dart`:

```dart
// Auth
sl.registerFactory(() => AuthCubit(sl(), sl()));
sl.registerLazySingleton(() => Login(sl()));
sl.registerLazySingleton(() => Logout(sl()));
sl.registerLazySingleton(() => Register(sl()));
sl.registerLazySingleton(() => ObserveAuthState(sl()));
sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

// Profile
sl.registerFactory(() => ProfileCubit(sl(), sl()));
sl.registerLazySingleton(() => GetProfile(sl()));
sl.registerLazySingleton(() => UpdateProfile(sl()));
sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
```

## Testing

```bash
# Run tests
flutter test

# Run specific feature tests
flutter test test/features/auth/
```

## Next Steps

After implementation, proceed to:
1. Verify auth flow (register → login → logout)
2. Test profile CRUD operations
3. Verify session persistence
4. Run integration tests