# Quickstart: Foundation Setup - Core Architecture

**Phase**: 1 - Design  
**Date**: 2026-04-18  
**Feature**: 001-foundation-setup-core

## Prerequisites

1. Flutter SDK (latest stable version)
2. Supabase project created with URL and anon key
3. Dependencies installed: `flutter_bloc`, `get_it`, `supabase_flutter`, `equatable`, `dartz`, `flutter_dotenv`
4. Environment file (`.env`) created with Supabase credentials

## Implementation Order

### Step 1: Create Project Structure

```bash
flutter create creatix_app
cd creatix_app
```

### Step 2: Add Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  supabase_flutter: ^2.0.0
  equatable: ^2.0.5
  dartz: ^0.10.1
  flutter_dotenv: ^5.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.1
  flutter_dotenv_generator: ^2.0.0
  build_runner: ^2.4.0
```

### Step 3: Create Core Module

Create the following structure:

```
lib/core/
├── di/injection.dart
├── error/failures.dart
├── utils/validators.dart
├── utils/formatters.dart
├── utils/logger.dart
├── constants/app_routes.dart
├── constants/api_endpoints.dart
├── config/
│   └── env.dart                    # Environment variable loader
└── supabase/supabase_client.dart
```

Also create `.env` file in project root (add to `.gitignore`):

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

### Step 4: Environment Setup

Create `lib/core/config/env.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
  
  static String get(String key) => dotenv.get(key);
}
```

### Step 5: Initialize Supabase

In `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: '.env');
  
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );
  
  await init();
  
  runApp(const MyApp());
}
```

### Step 6: Setup Dependency Injection

In `lib/core/di/injection.dart`:

```dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Supabase client
  sl.registerLazySingleton(() => Supabase.instance.client);
  
  // Register Failure classes (if needed)
  // sl.registerFactory(() => SomeFailure());
}
```

### Step 8: Setup Routing

Create router with onGenerateRoute:

```dart
// lib/core/router.dart
import 'package:flutter/material.dart';
import '../constants/app_routes.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginPage());
    default:
      return MaterialPageRoute(builder: (_) => const NotFoundPage());
  }
}
```

### Step 9: Create Feature Structure

For each new feature, create:

```
lib/features/[feature_name]/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── widgets/
    └── cubits/
```

## Common Patterns

### UseCase Template

```dart
import 'package:dartz/dartz.dart';
import '../../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

### Cubit Template

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCubit extends Cubit<MyState> {
  final MyUseCase myUseCase;
  
  MyCubit(this.myUseCase) : super(MyInitial());
  
  void doSomething() async {
    // Call use case, emit new state
  }
}
```

## Verification

After implementation, verify:
1. App builds successfully: `flutter build apk` or `flutter build ios`
2. Clean Architecture layers are respected
3. Supabase client is accessible via get_it
4. Routing works with unknown routes falling back to 404