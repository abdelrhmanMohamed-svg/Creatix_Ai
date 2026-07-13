# Data Model: Provider Keys System

## Entities

### ProviderKey
Represents an AI provider API key owned by a user, stored securely in Supabase Vault.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| id | UUID | Unique identifier for the key record | Primary key, auto-generated |
| user_id | UUID | Reference to the user who owns this key | Foreign key to auth.users, not null |
| provider | Enum | The AI provider ("openai" or "gemini") | Not null, constrained to valid values |
| vault_secret_id | Text | Reference to the securely stored key in Supabase Vault | Not null |
| is_active | Boolean | Whether this key is currently active for its provider | Not null, default false |
| status | Enum | Validation status ("valid", "invalid", "rate_limited") | Not null, default "invalid" |
| last_validated_at | Timestamp | When the key was last validated | Nullable |
| created_at | Timestamp | When the key record was created | Not null, auto-generated |

**Constraints:**
- Only one active key per provider per user (enforced through application logic)
- Provider values limited to "openai" or "gemini"
- Status values limited to "valid", "invalid", or "rate_limited"

### Brand (Extended)
Extension to the existing Brand entity to support provider key referencing.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| active_provider_key_id | UUID | Reference to the ProviderKey this brand should use | Foreign key to ProviderKey.id, nullable |

**Constraints:**
- Nullable to allow brands to use the default provider (Pixazo)
- When set, must reference a valid, active ProviderKey belonging to the same user

## Relationships

1. **User → ProviderKey** (One-to-Many)
   - A user can have multiple ProviderKeys (up to 2: one for OpenAI, one for Gemini)
   - Each ProviderKey belongs to exactly one user

2. **Brand → ProviderKey** (One-to-One, optional)
   - A Brand can optionally reference one ProviderKey
   - A ProviderKey can be referenced by multiple Brands (though typically one per user)

## Data Flow

1. **Key Storage Process:**
   - User submits API key through UI
   - Key sent to Supabase Edge Function (`add-key`) for validation
   - If valid, key stored in Supabase Vault, returning `vault_secret_id`
   - `vault_secret_id` saved to database in `provider_keys` table
   - Key validation status set based on provider API response

2. **Key Usage Process:**
   - When brand needs AI generation, system checks `Brand.active_provider_key_id`
   - If set, retrieves corresponding ProviderKey and gets `vault_secret_id`
   - If not set, uses default provider (Pixazo)
   - `vault_secret_id` passed to Edge Function for secure key retrieval
   - Edge Function retrieves key from Vault and uses it for AI provider API call

3. **Key Validation Process:**
   - Periodic or on-demand validation through `validate-key` Edge Function
   - Edge Function retrieves key from Vault using `vault_secret_id`
   - Makes test API call to provider to check validity
   - Updates `status` and `last_validated_at` fields based on response

## Security Considerations

- Raw API keys are never stored in the database - only `vault_secret_id` is persisted
- All API key operations (storage, retrieval, validation) happen in Supabase Edge Functions
- Vault provides encryption at rest and strict access controls
- Edge Functions run with service role keys, ensuring only backend can access Vault
- Client-side code only handles key references (UUIDs), never actual key values