# 📱 Creatix AI - Flutter Implementation Plan

## Version

1.0.0 (Mobile Adaptation)

---

# 🧠 Overview

This document converts the original web-based plan (Next.js + FastAPI) into a **Flutter Mobile App** using:

- Flutter + Dart
- Clean Architecture (Data / Domain / Presentation)
- Cubit (Bloc)
- Supabase (Auth + DB + Storage + Edge Functions)
- get_it (Dependency Injection)

---

# ⚙️ Core Architecture

## Layers

### 1. Presentation

- UI (Screens / Widgets)
- Cubits
- States

### 2. Domain

- Entities
- UseCases
- Repository Contracts

### 3. Data

- Models (DTOs)
- DataSources (Supabase)
- Repository Implementations

---

# 📦 Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart
│   ├── error/
│   ├── utils/
│   ├── constants/
│   └── supabase/
│       └── supabase_client.dart
│
├── features/
│
│   ├── auth/
│   ├── profile/
│   ├── brands/
│   ├── brand_kit/
│   ├── provider_keys/
│   ├── generation/
│   └── history/
│
└── main.dart
```

---

# 🔌 Dependency Injection (get_it)

## Setup

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(() => BrandCubit(sl()));

  // UseCases
  sl.registerLazySingleton(() => GetBrands(sl()));

  // Repository
  sl.registerLazySingleton<BrandRepository>(
    () => BrandRepositoryImpl(sl()),
  );

  // DataSource
  sl.registerLazySingleton(
    () => BrandRemoteDataSource(sl()),
  );

  // External
  sl.registerLazySingleton(() => Supabase.instance.client);
}
```

---

# 🔐 Authentication (Supabase)

## Implementation

```dart
await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);
```

---

# 🧩 Features Breakdown

---

## 🆕 Default Image Generation Provider (Free Tier)

### Concept

The system supports a **default free provider** using **Pixazo AI** when the user does NOT have API keys.

### Provider Priority Logic

```
IF user has active provider key (OpenAI or Gemini)
    → Use user's provider
ELSE
    → Use default provider (Pixazo AI)
```

### Why this is important

- Allows free usage (better UX)
- No onboarding friction
- Enables SaaS growth

---

## 🧠 Provider Resolution (Edge Function Logic)

```ts
function resolveProvider(brandId) {
  const userKey = getActiveKey(brandId);

  if (userKey) {
    return {
      type: "user",
      provider: userKey.provider,
      apiKey: userKey.secret,
    };
  }

  return {
    type: "default",
    provider: "pixazo",
    apiKey: PIXAZO_API_KEY,
  };
}
```

---

## 🧩 Generation Flow (Updated)

### Edge Function Responsibilities

1. Resolve provider (user vs default)
2. If user provider:
   - Use OpenAI or Gemini
3. If default:
   - Use Pixazo AI
4. Return unified response

---

## 🔌 Flutter Integration (No Change)

Flutter always calls the same function:

```dart
await supabase.functions.invoke(
  'generate-image',
  body: {
    'brand_id': brandId,
    'prompt': prompt,
    'platform_preset': 'instagram_post',
  },
);
```

⚠️ Flutter does NOT decide provider
→ Backend handles everything

---

## 📊 Generation Entity Update

```dart
class Generation {
  final String id;
  final String imageUrl;
  final String provider; // openai | gemini | pixazo
  final bool isDefault;
}
```

---

## 🎮 Generation Cubit (Updated)

```dart
class GenerationCubit extends Cubit<GenerationState> {
  GenerationCubit() : super(GenerationState.initial());

  Future<void> generate() async {
    emit(state.copyWith(isLoading: true));

    try {
      final res = await supabase.functions.invoke('generate-image');

      emit(state.copyWith(
        imageUrl: res.data['image_url'],
        provider: res.data['provider'],
        isDefault: res.data['is_default'],
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
```

---

## 🏷️ UI Behavior

- Show badge:
  - "Free" → Pixazo
  - "OpenAI" → user key
  - "Gemini" → user key

---

## 🔐 Security Notes

- Pixazo API key stored ONLY in Edge Function env
- Never exposed to client
- Same rules as other providers

---

## ⚠️ Limits (Recommended)

For free tier (Pixazo):

- Limit generations per day (e.g. 5–10)
- Lower resolution if needed
- Add watermark (optional)

---

## 1. Profile

### Entity

```dart
class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;
}
```

### UseCases

- GetProfile
- UpdateProfile

---

## 2. Brands

### Entity

```dart
class Brand {
  final String id;
  final String name;
  final String? logoUrl;
}
```

### Cubit

```dart
class BrandCubit extends Cubit<BrandState> {
  final GetBrands getBrands;

  BrandCubit(this.getBrands) : super(BrandInitial());

  Future<void> loadBrands() async {
    emit(BrandLoading());
    try {
      final brands = await getBrands();
      emit(BrandLoaded(brands));
    } catch (e) {
      emit(BrandError(e.toString()));
    }
  }
}
```

---

## 3. Brand Kit (Wizard)

### Cubit

```dart
class BrandKitCubit extends Cubit<BrandKitState> {
  BrandKitCubit() : super(BrandKitState.initial());

  void updateStep(Map<String, dynamic> data) {
    emit(state.copyWith(answers: {...state.answers, ...data}));
  }
}
```

---

## 4. Provider Keys

⚠️ Must use Supabase Edge Functions

### Example

```dart
await supabase.functions.invoke(
  'add-key',
  body: {
    'provider': 'openai',
    'key': 'sk-...'
  },
);
```

---

## 5. Image Generation

❌ NOT from Flutter directly

✔️ Use Edge Function

### Call

```dart
await supabase.functions.invoke(
  'generate-image',
  body: {
    'brand_id': brandId,
    'prompt': prompt,
    'platform_preset': 'instagram_post',
  },
);
```

---

## 6. History

### Cubit

```dart
class HistoryCubit extends Cubit<HistoryState> {
  Future<void> loadHistory() async {}
}
```

---

# 🧱 Data Layer Example

```dart
class BrandRemoteDataSource {
  final SupabaseClient client;

  BrandRemoteDataSource(this.client);

  Future<List<BrandModel>> getBrands() async {
    final response = await client.from('brands').select();
    return response.map((e) => BrandModel.fromJson(e)).toList();
  }
}
```

---

# 🔁 Repository

```dart
abstract class BrandRepository {
  Future<List<Brand>> getBrands();
}
```

```dart
class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource remote;

  BrandRepositoryImpl(this.remote);

  @override
  Future<List<Brand>> getBrands() {
    return remote.getBrands();
  }
}
```

---

# 🎯 UseCase

```dart
class GetBrands {
  final BrandRepository repo;

  GetBrands(this.repo);

  Future<List<Brand>> call() => repo.getBrands();
}
```

---

# 🚀 Build Phases

# 🧱 Phase 1 — Foundation Setup (Core Architecture)

## 🎯 Goal

Establish a production-ready Clean Architecture foundation and prepare all core infrastructure before implementing any feature.

---

## 📦 Tasks

### 1. Flutter Setup

- Latest stable Flutter version
- Clean and scalable folder structure

---

### 2. Project Architecture

#### Layers:

- Presentation (UI + Cubits)
- Domain (Entities + UseCases+Repositories interfaces)
- Data (Repositories + DataSources)

#### Rules:

- ❌ No Supabase calls in UI
- ❌ No business logic inside Cubits (only orchestration)
- ✅ All business logic must be inside UseCases

---

### 3. Core Module

Includes:

- Error handling (Failure classes)
- Utilities (validators, formatters)
- Constants (API endpoints, routes)
- Logger system

---

### 4. Supabase Setup

- Initialize Supabase client
- Configure authentication
- Configure storage
- Enable Edge Functions client

```dart
Supabase.initialize(
  url: Env.supabaseUrl,
  anonKey: Env.supabaseAnonKey,
);
```

---

### 5. Dependency Injection (get_it)

Rules:

- Register dependencies by feature grouping
- Use lazy_singleton for data sources
- Use factory for Cubits

### 6. Routing (onGenerateRoute)

- Centralized navigation system
- Use AppRoutes constants
- Implement onGenerateRoute switch logic in router.dart
- Define initialRoute
- Handle unknown routes (404 fallback)

---

## 📌 Output of Phase 1

- App runs with a basic shell
- Supabase successfully connected
- Dependency Injection working
- Clean Architecture enforced
- Routing system implemented (onGenerateRoute)

---

# 🔐 Phase 2 — Authentication + Profile

## 🎯 Goal

Build a complete user authentication and profile system.

---

## 🔑 Features

- Email/password login
- User registration
- Logout
- Persistent sessions

---

## 🗄️ Profile Table

- id (uuid)
- full_name
- avatar_url
- created_at

---

## 🧠 Domain Layer

Entities:

- Profile

UseCases:

- GetProfile
- UpdateProfile
- ObserveAuthState

---

## 📱 Presentation Layer

AuthCubit states:

- initial
- loading
- authenticated
- unauthenticated
- error

---

## 📌 Output

- Fully working authentication system
- Profile automatically loaded after login

---

# 🏢 Phase 3 — Brands System

## 🎯 Goal

Manage Brands (core business entity of the system)

---

## 🗄️ Table: brands

- id
- user_id
- name
- logo_url
- created_at

---

## 🧠 Domain Layer

Entity:

- Brand

UseCases:

- GetBrands
- CreateBrand
- UpdateBrand
- DeleteBrand

---

## 📱 Presentation Layer

BrandCubit states:

- loading
- loaded
- empty
- error

---

## 📌 Output

- Full CRUD operations for brands

---

# 🎨 Phase 4 — Brand Kit Wizard

## 🎯 Goal

AI-powered onboarding system to build brand identity

---

## 🧩 Flow

1. Business type
2. Tone of voice
3. Color palette
4. Target audience
5. Summary generation

---

## 🧠 Domain Layer

Entity:

- BrandKit

---

## 🧠 Cubit

BrandKitCubit:

- Stores step-by-step answers
- Supports navigation between steps

---

## 📌 Output

- Fully functional wizard system

---

# 🔑 Phase 5 — Provider Keys System

## 🎯 Goal

Manage API keys for AI providers (OpenAI / Gemini)

---

## 🗄️ Table: provider_keys

- id
- user_id
- provider
- encrypted_key
- is_active

---

## ⚙️ Edge Functions

- add-key
- delete-key
- rotate-key

---

## 🧠 Domain Layer

Entity:

- ProviderKey

UseCases:

- AddKey
- GetKeys
- SetActiveKey
- DeleteKey

---

## 📌 Output

- Secure API key management system

---

# 🎨 Phase 6 — Image Generation System

## 🎯 Goal

AI-powered image generation with fallback provider system

---

## ⚙️ Flow

Flutter → Edge Function → Provider Resolver → AI Provider → Response

---

## 🧠 Provider Logic

- If user key exists → OpenAI / Gemini
- If not → Pixazo (free tier)

---

## 📱 Flutter Role

ONLY:

- Send request
- Show loading state
- Render image result

---

## 📌 Output

- Full AI generation pipeline working

---

# 🕓 Phase 7 — History System

## 🎯 Goal

Store and manage all generated images

---

## 🗄️ Table: generations

- id
- brand_id
- image_url
- provider
- prompt
- created_at

---

## 🧠 Features

- List history
- Delete item
- Pagination support

---

## 📌 Output

- Full generation history system

---

# 🚀 Phase 8 — Production Hardening

## 🎯 Goal

Transform the app into a SaaS-ready production system

---

## ⚙️ Includes

### Performance

- Caching
- Pagination everywhere

### Security

- Full RLS enforcement
- Secure Edge Functions validation

### UX

- Skeleton loaders
- Retry mechanisms

---

## 📌 Output

- Production-ready scalable SaaS application

# ⚠️ Critical Rules

### 1. Never call OpenAI from Flutter

→ Use Edge Functions

### 2. Keep API keys secure

→ Only in Supabase Vault

### 3. Enable RLS

→ Must match backend plan

### 4. Separate features strictly

---

# ✅ Done Criteria

- Auth works
- Brands CRUD works
- Generation works via Edge Function
- History works
- RLS enforced

---

# 🎯 Notes for OpenCode + SpecKit

- Split each feature into separate specs
- Each phase = independent spec
- Follow Clean Architecture strictly
- Each spec should include:
  - Entities
  - UseCases
  - Cubits
  - DataSources
