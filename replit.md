# tabaq-wafir — Restaurant Ecosystem Platform

A monorepo containing four Flutter web apps and a shared FastAPI backend.

## Apps

| App | Description | Brand |
|-----|-------------|-------|
| `restaurant-app/` | Restaurant Copilot — owner/manager dashboard | Blue (`#1A56DB`) |
| `customer-app/` | Customer ordering & discovery app | Orange (`#FF5722`) |
| `driver-app/` | Driver delivery hub | Blue (`#2563EB`) |
| `admin-dashboard/` | Platform administration | Indigo (`#1E40AF`) |

## Shared patterns across all apps

Every app follows the same architecture:
- **State management**: Riverpod
- **Navigation**: go_router with ShellRoute for sidebar/nav shell
- **l10n**: Flutter gen-l10n with ARB files (`lib/l10n/app_en.arb` + `lib/l10n/app_ar.arb`)
- **Theme**: `AppTheme.light` + `AppTheme.dark` with `themeModeProvider`
- **Locale**: `localeModeProvider` in `lib/core/providers/settings_provider.dart`
- **Navigation shell**: `lib/core/widgets/main_shell.dart` — sidebar on desktop, bottom nav + drawer on mobile
- **Splash screen**: `lib/features/splash/splash_page.dart` — animated gradient + branding delay

## How to run (restaurant-app is the active workflow)

The **Restaurant Copilot** workflow builds and serves the restaurant app on port 5000:
```
cd restaurant-app && flutter pub get && flutter build web --release --no-pub && python3 spa_server.py 5000 build/web
```

To build any other app, run in its directory:
```
cd <app-dir> && flutter pub get && flutter build web --release --no-pub
```

After code changes, restart the workflow to rebuild and re-serve.

## Project structure (per app)

```
<app>/
  lib/
    main.dart                  — ProviderScope entry point
    app.dart                   — MaterialApp.router + l10n + theme + responsive
    core/
      router/app_router.dart   — GoRouter with /splash and ShellRoute
      widgets/main_shell.dart  — sidebar (desktop) + bottom nav (mobile)
      theme/app_colors.dart    — light + dark color palette
      theme/app_theme.dart     — ThemeData light/dark
      providers/settings_provider.dart — themeModeProvider + localeModeProvider
    l10n/
      app_en.arb               — English strings
      app_ar.arb               — Arabic strings
      app_localizations.dart   — auto-generated (flutter gen-l10n)
      app_l10n.dart            — context.l10n extension + AppTranslations shim
    features/
      splash/splash_page.dart  — animated splash screen
      ...
```

## User preferences
