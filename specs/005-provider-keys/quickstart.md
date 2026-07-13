# Quick Start: Provider Keys System

## Overview
This guide provides a quick start for implementing the Provider Keys System feature in the Creatix Flutter application.

## Prerequisites
- Flutter SDK installed and configured
- Supabase project set up with Vault enabled
- Base application architecture from phases 1-4 implemented (Auth, Profile, Brands, Brand Kit)
- `get_it` dependency injection initialized
- Supabase client configured and available through DI

## Implementation Steps

### 1. Database Setup

Run the following SQL to create the necessary tables:

```sql
-- Enable the vault extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create provider_keys table
CREATE TABLE IF NOT EXISTS provider_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    provider TEXT NOT NULL CHECK (provider IN ('openai', 'gemini')),
    vault_secret_id TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    status TEXT NOT NULL CHECK (status IN ('valid', 'invalid', 'rate_limited')) DEFAULT 'invalid',
    last_validated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add index for efficient lookups
CREATE INDEX IF NOT EXISTS idx_provider_keys_user_provider ON provider_keys(user_id, provider);
CREATE INDEX IF NOT EXISTS idx_provider_keys_active ON provider_keys(user_id, provider, is_active) WHERE is_active = TRUE;

-- Add active_provider_key_id to brands table
ALTER TABLE brands ADD COLUMN IF NOT EXISTS active_provider_key_id UUID REFERENCES provider_keys(id) ON DELETE SET NULL;
```

### 2. Edge Functions

Create the following Supabase Edge Functions:

#### add-key.ts
```typescript
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { serve } from 'https://deno.land/std@0.168.0/http/server.so'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  const { provider, key } = await req.json()
  
  // Validate input
  if (!provider || !['openai', 'gemini'].includes(provider)) {
    return new Response(
      JSON.stringify({ error: 'Invalid provider' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    )
  }
  
  if (!key) {
    return new Response(
      JSON.stringify({ error: 'API key is required' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    )
  }
  
  try {
    // Validate the API key with the provider
    let validationResult: { status: 'valid' | 'invalid' | 'rate_limited' }
    
    if (provider === 'openai') {
      validationResult = await validateOpenAIKey(key)
    } else if (provider === 'gemini') {
      validationResult = await validateGeminiKey(key)
    }
    
    // Store key in Vault
    const { data: vaultData, error: vaultError } = await supabase
      .from('vault')
      .insert({ service: 'provider_keys', encrypted: encrypt(key) })
      .select()
      .single()
      
    if (vaultError) throw vaultError
    
    // Save to database
    const { data: keyData, error: dbError } = await supabase
      .from('provider_keys')
      .insert({
        user_id: getUserId(req), // Implement based on your auth strategy
        provider,
        vault_secret_id: vaultData.id,
        status: validationResult.status,
        is_active: validationResult.status === 'valid',
        last_validated_at: new Date().toISOString()
      })
      .select()
      .single()
      
    if (dbError) throw dbError
    
    return new Response(
      JSON.stringify({ 
        id: keyData.id,
        status: keyData.status,
        is_active: keyData.is_active 
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})

// Helper functions for key validation
async function validateOpenAIKey(key: string): Promise<{ status: 'valid' | 'invalid' | 'rate_limited' }> {
  // Implement OpenAI API validation with timeout and retry logic
  // Return appropriate status based on response
}

async function validateGeminiKey(key: string): Promise<{ status: 'valid' | 'invalid' | 'rate_limited' }> {
  // Implement Gemini API validation with timeout and retry logic
  // Return appropriate status based on response
}

// Helper function to extract user ID from request
function getUserId(req: Request): string {
  // Implement based on your auth strategy (e.g., from JWT, session, etc.)
  return '' // Placeholder
}

// Helper function for encryption (simplified)
function encrypt(text: string): string {
  // Implement proper encryption for Vault storage
  return btoa(text) // Placeholder - use proper encryption in production
}
```

#### validate-key.ts, get-keys.ts, set-active-key.ts, delete-key.ts, rotate-key.ts
(Similar structure - implement according to the specification)

### 3. Domain Layer

Create the ProviderKey entity:

```dart
// lib/features/provider_keys/domain/entities/provider_key.dart
class ProviderKey {
  final String id;
  final String userId;
  final String provider; // 'openai' or 'gemini'
  final String vaultSecretId;
  final bool isActive;
  final String status; // 'valid', 'invalid', 'rate_limited'
  final DateTime? lastValidatedAt;
  final DateTime createdAt;

  ProviderKey({
    required this.id,
    required this.userId,
    required this.provider,
    required this.vaultSecretId,
    required this.isActive,
    required this.status,
    this.lastValidatedAt,
    required this.createdAt,
  });
}
```

### 4. Data Sources

Create the remote data source:

```dart
// lib/features/provider_keys/data/datasources/provider_key_remote_data_source.dart
class ProviderKeyRemoteDataSource {
  final SupabaseClient _supabase;

  ProviderKeyRemoteDataSource(this._supabase);

  Future<ProviderKey> addKey(String provider, String key) async {
    try {
      final response = await _supabase.functions.invoke<ProviderKeyResponse>(
        'add-key',
        body: {
          'provider': provider,
          'key': key,
        },
      );

      return ProviderKey(
        id: response.data['id'],
        userId: _supabase.auth.currentUser!.id,
        provider: provider,
        vaultSecretId: response.data['vault_secret_id'],
        isActive: response.data['is_active'],
        status: response.data['status'],
        lastValidatedAt: response.data['last_validated_at'] != null
            ? DateTime.parse(response.data['last_validated_at'])
            : null,
        createdAt: DateTime.parse(response.data['created_at']),
      );
    } catch (e) {
      throw Exception('Failed to add key: $e');
    }
  }

  // Implement other methods: getKeys, setActiveKey, deleteKey, rotateKey, validateKey
}
```

### 5. Repository

Create the repository implementation:

```dart
// lib/features/provider_keys/data/repositories/provider_key_repository_impl.dart
class ProviderKeyRepositoryImpl implements ProviderKeyRepository {
  final ProviderKeyRemoteDataSource _remoteDataSource;

  ProviderKeyRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProviderKey> addKey(String provider, String key) async {
    return await _remoteDataSource.addKey(provider, key);
  }

  // Implement other interface methods
}
```

### 6. UseCases

Create use cases for key management:

```dart
// lib/features/provider_keys/domain/usecases/add_provider_key.dart
class AddProviderKey {
  final ProviderKeyRepository _repository;

  AddProviderKey(this._repository);

  Future<ProviderKey> call(String provider, String key) async {
    return await _repository.addKey(provider, key);
  }
}

// Create similar use cases for other operations
```

### 7. Cubits

Create the ProviderKeysCubit:

```dart
// lib/features/provider_keys/presentation/cubits/provider_keys_cubit.dart
class ProviderKeysCubit extends Cubit<ProviderKeysState> {
  final AddProviderKey _addProviderKey;
  final GetProviderKeys _getProviderKeys;
  final SetActiveProviderKey _setActiveProviderKey;
  final DeleteProviderKey _deleteProviderKey;
  final RotateProviderKey _rotateProviderKey;

  ProviderKeysCubit(
    this._addProviderKey,
    this._getProviderKey,
    this._setActiveProviderKey,
    this._deleteProviderKey,
    this._rotateProviderKey,
  ) : super(ProviderKeysInitial());

  Future<void> addKey(String provider, String key) async {
    emit(ProviderKeysLoading());
    try {
      final key = await _addProviderKey(provider, key);
      final keys = await _getProviderKeys();
      emit(ProviderKeysLoaded(keys, selectedKey: key));
    } catch (e) {
      emit(ProviderKeysError(e.toString()));
    }
  }

  // Implement other methods for UI interactions
}
```

### 8. Presentation Layer

Create UI components for:
- Adding/removing API keys
- Viewing key status
- Activating/deactivating keys
- Assigning keys to brands

### 9. Dependency Injection

Register the dependencies:

```dart
// lib/features/provider_keys/di/provider_keys_injection.dart
final sl = GetIt.instance;

void setupProviderKeys() {
  // Data sources
  sl.registerLazySingleton<ProviderKeyRemoteDataSource>(
    () => ProviderKeyRemoteDataSource(sl<SupabaseClient>()),
  );

  // Repositories
  sl.registerLazySingleton<ProviderKeyRepository>(
    () => ProviderKeyRepositoryImpl(sl<ProviderKeyRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<AddProviderKey>(
    () => AddProviderKey(sl<ProviderKeyRepository>()),
  );
  // Register other use cases

  // Cubits
  sl.registerFactory<ProviderKeysCubit>(
    () => ProviderKeysCubit(
      sl<AddProviderKey>(),
      sl<GetProviderKeys>(),
      sl<SetActiveProviderKey>(),
      sl<DeleteProviderKey>(),
      sl<RotateProviderKey>(),
    ),
  );
}
```

### 10. Integration Testing

Create unit tests for:
- Use cases
- Repository implementations
- Cubits
- Edge function interactions (mocked)

## Verification

After implementation, verify:
1. API keys are securely stored in Vault (not in database)
2. Key validation works correctly for valid/invalid/rate-limited keys
3. Only one key can be active per provider per user
4. Brands can reference specific provider keys
5. No API keys are exposed in client-side code or logs
6. All errors are handled gracefully with appropriate user feedback

## Next Steps
Once this feature is complete, proceed to Phase 6 (Image Generation System) which will utilize these provider keys for AI image generation.