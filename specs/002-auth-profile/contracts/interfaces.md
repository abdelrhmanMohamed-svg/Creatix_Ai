# Contracts: Authentication + Profile

**Phase**: 1 - Design  
**Date**: 2026-04-18  
**Feature**: Authentication + Profile (002-auth-profile)

## Interface Contracts

This feature is a mobile application with Supabase as the backend. No external API contracts are exposed to other systems.

### Internal Contracts (between features)

#### Auth Feature → Profile Feature

The auth feature creates users in Supabase Auth. The profile feature reads/writes to the profiles table.

| Contract | Direction | Description |
|----------|-----------|-------------|
| User Session | Auth → Profile | Provides current user ID via `auth.uid()` |
| Profile Query | Profile → Supabase | RLS-protected queries using session |

#### Auth Feature → App Shell

| Contract | Direction | Description |
|----------|-----------|-------------|
| Auth State | Auth → Shell | Emits auth state changes (authenticated/unauthenticated) |
| Protected Route | Shell → Auth | Guards routes requiring authentication |

---

## Data Access Patterns

### Supabase Auth (managed externally)

- `signUp()` - Create new user
- `signInWithPassword()` - Login with email/password
- `signOut()` - Logout
- `getUser()` - Get current session
- `refreshSession()` - Refresh expired session
- `resetPasswordForEmail()` - Password reset flow

### Profile Repository

```dart
// Contract: ProfileRepository
abstract class ProfileRepository {
  Future<Profile> getProfile(String userId);
  Future<Profile> updateProfile(Profile profile);
  Stream<Profile> observeProfile(String userId);
}
```

---

## Notes

- All authentication is handled by Supabase Auth (no custom auth logic)
- Profile data accessed via RLS-protected queries
- No REST/GraphQL APIs exposed externally