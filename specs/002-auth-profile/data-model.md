# Data Model: Authentication + Profile

**Phase**: 1 - Design  
**Date**: 2026-04-18  
**Feature**: Authentication + Profile (002-auth-profile)

## Entities

### User (Supabase Auth)

Represents the authenticated user account in Supabase Auth.

| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| id | uuid | Unique user identifier | Primary key, auto-generated |
| email | string | User email address | Required, unique, valid email format |
| created_at | timestamp | Account creation timestamp | Auto-generated |
| updated_at | timestamp | Last update timestamp | Auto-updated |
| email_confirmed_at | timestamp | Email verification timestamp | Nullable |

**Relationships**: 
- Links to Profile via id (foreign key)
- Managed by Supabase Auth

---

### Profile

Stores additional user profile data in the database.

| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| id | uuid | Profile unique identifier | Primary key, auto-generated |
| user_id | uuid | Reference to auth user | Required, foreign key to auth.users |
| full_name | string | User's display name | Optional, max 255 chars |
| avatar_url | string | URL to user avatar | Optional, valid URL format |
| created_at | timestamp | Profile creation timestamp | Auto-generated |
| updated_at | timestamp | Last profile update | Auto-updated |

**Relationships**:
- One-to-one with User (user_id → auth.users.id)
- RLS: Users can only read/write their own profile

---

## State Machines

### Auth State Transitions

```
initial → loading → authenticated
initial → loading → unauthenticated  
initial → loading → error
```

| From State | Event | To State |
|------------|-------|----------|
| initial | Start auth check | loading |
| loading | Session valid | authenticated |
| loading | No session | unauthenticated |
| loading | Auth error | error |
| authenticated | User logs out | unauthenticated |
| error | Retry | loading |

---

## Database Schema (SQL)

```sql
-- Profiles table (RLS protected)
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

---

## Validation Rules

From functional requirements:

1. **Email validation**: Valid email format required
2. **Password strength**: Minimum length and complexity requirements
3. **Profile fields**: 
   - full_name: max 255 characters
   - avatar_url: valid URL format (optional)

---

## Data Flow

1. **Registration**: Supabase Auth creates user → Trigger creates profile record
2. **Login**: Supabase Auth validates credentials → Return session
3. **Profile fetch**: Query profiles table using auth.uid()
4. **Profile update**: Update profiles table, trigger updates updated_at