# Creatix Development Guidelines

Auto-generated from speckit plan system. Last updated: 2026-07-14

## Active Technologies
- Flutter + Dart 3.x (sdk: ^3.9.2) + flutter_bloc (Cubit ONLY), get_it, supabase_flutter, equatable, dartz, flutter_dotenv, image_picker
- Supabase (Auth, PostgreSQL, Storage for images, Edge Functions for AI/3rd-party API calls)
- speckit workflow: `.specify/` — constitution, templates, scripts for feature planning

## Project Structure

```
lib/
├── core/          # DI, router, constants, Supabase client, error handling, config, utils
├── features/      # Clean Architecture modules: auth, profile, brands, brand_kit_wizard, provider_keys
└── main.dart      # Entrypoint: dotenv → Supabase init → DI → runApp

specs/             # Feature specs (numbered: ###-feature-name)
supabase/
└── functions/     # Edge Functions (add-key, list-keys, activate-key, delete-key, get-active-key)
test/              # widget_test.dart (placeholder smoke test only)
```

## Key Architecture Rules

- **Clean Architecture**: data/ (datasources, models, repositories), domain/ (entities, usecases, repository interfaces), presentation/ (pages, widgets, cubits)
- **State management**: Cubit ONLY — no setState, Provider, Riverpod, or Redux
- **DI**: get_it exclusively — all deps registered in `lib/core/di/injection.dart` via `setupDependencies()`
- **Routing**: Manual `AppRouter.generateRoute` in `lib/core/router.dart` — NOT go_router
- **Backend**: Supabase for everything — NEVER call AI/3rd-party APIs from Flutter; use Edge Functions
- **Provider keys**: Stored via Supabase Vault / Edge Functions, never exposed in client code
- **Env**: `flutter_dotenv` loads `.env` then `.env.local` at startup (both in pubspec assets); must contain `SUPABASE_URL` and `SUPABASE_ANON_KEY`
- **Image handling**: `image_picker` for selection → Supabase Storage (`brand_logos`, `profile_images`)
- **Error handling**: Custom `Failure` sealed hierarchy (`ServerFailure`, `NetworkFailure`, `AuthFailure`, `CacheFailure`, `UnknownFailure`) with `FailureType` enum

## Commands

```bash
flutter pub get                    # install deps
flutter run                        # run app (select device)
flutter test                       # run all tests (only widget_test.dart exists)
flutter analyze                    # lint + static analysis (flutter_lints ruleset)
flutter build apk / ios / web      # build for platform
```

## Testing

- Uses `flutter_test` + `mocktail` for mocking
- No real tests exist beyond the placeholder smoke test
- No integration tests configured

## Speckit Workflow

Feature branches follow `###-feature-name` pattern. Each feature's spec lives in `specs/###-feature-name/`. The `.specify/` directory contains:
- `memory/constitution.md` — binding architectural rules
- `templates/` — plan, spec, tasks, checklist templates
- `integrations/opencode/scripts/update-context.ps1` — auto-updates AGENTS.md from plan.md

Run `pwsh .specify/integrations/opencode/scripts/update-context.ps1` after feature completion to update this file.
