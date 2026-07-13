# Security Documentation: Provider Keys System

## Overview

The Provider Keys System securely manages AI provider API keys (OpenAI, Gemini) for users. This document outlines the security measures implemented to protect API keys.

## Security Principles

### 1. Never Expose Secrets in Client Code

**Implementation:**
- API keys are validated server-side via Supabase Edge Functions
- Secrets are stripped from all API responses (`{ secret, ...keyWithoutSecret }`)
- Client code only receives key metadata (id, status, provider, etc.)

**Files that MUST NOT contain key secrets:**
- `lib/features/provider_keys/` (Dart code)
- Supabase Edge Function responses (TypeScript)

### 2. Server-Side Key Storage

**Current Implementation:**
- Keys are stored directly in the `provider_keys` table
- For enhanced security, Supabase Vault should be used in production

**Production Recommendation:**
```sql
-- Enable Vault for enhanced key storage
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Store keys in Vault instead of direct table
-- vault.insert({ encrypted: encrypt(apiKey) })
```

### 3. Edge Function Security

All edge functions follow these patterns:

**Request Validation:**
```typescript
// Always validate inputs
if (!userId) {
  return new Response(JSON.stringify({ error: 'User ID is required' }), { status: 400 });
}
```

**Secret Stripping:**
```typescript
// Always exclude secrets from responses
const { secret, ...keyWithoutSecret } = keyData[0];
return new Response(JSON.stringify({ key: keyWithoutSecret }), ...);
```

### 4. Provider Key Validation

Keys are validated against provider APIs before storage:

**OpenAI:**
- Endpoint: `https://api.openai.com/v1/models`
- Method: GET with Authorization header
- Success: HTTP 200 response

**Gemini:**
- Endpoint: `https://generativelanguage.googleapis.com/v1/models?key={apiKey}`
- Method: GET
- Success: HTTP 200 response

### 5. User Isolation

Each operation enforces user ownership:

```typescript
// List only user's keys
GET /provider_keys?user_id=eq.{userId}

// Activate only user's keys
PATCH /provider_keys?user_id=eq.{userId}&id=eq.{id}
```

### 6. Single Active Key Constraint

Only one key can be active per provider per user:

```typescript
// Deactivate all other keys before activating new one
await fetchSupabase(
  `provider_keys?user_id=eq.${userId}&provider=eq.${provider}&id=not.eq.${id}`,
  'PATCH',
  { is_active: false }
);
```

## Security Checklist

- [x] API keys validated server-side before storage
- [x] Secrets stripped from all API responses
- [x] User authentication enforced on all operations
- [x] User isolation enforced (can only access own keys)
- [x] Input validation on all edge function inputs
- [x] Error messages don't expose sensitive information
- [x] Single active key per provider enforced
- [x] Logging doesn't expose API key values

## Security Review Notes

**Current Status:** Implementation follows security best practices for MVP.

**Future Enhancements:**
1. Move to Supabase Vault for encrypted storage
2. Add rate limiting to prevent brute force attacks
3. Implement key rotation support
4. Add audit logging for key access
5. Consider JWT-based authentication for edge functions

## Vulnerability Considerations

| Vulnerability | Mitigation | Status |
|---------------|-----------|--------|
| Key exposure in logs | Logging uses key IDs, not values | Mitigated |
| SQL injection | Using Supabase SDK parameterized queries | Mitigated |
| XSS | N/A (no direct client-side key handling) | N/A |
| CSRF | Supabase handles auth tokens | Mitigated |
| Key enumeration | User isolation enforced | Mitigated |

## Reporting Security Issues

If you discover a security vulnerability in the Provider Keys System, please report it immediately to the development team.