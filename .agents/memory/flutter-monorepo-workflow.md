---
name: Flutter monorepo workflow
description: Key decisions and constraints for the tabaq-wafir 4-app Flutter monorepo on Replit.
---

## Build command
Always use `--pwa-strategy=none` for all apps:
```
cd <app-dir> && flutter pub get && flutter build web --release --no-pub --pwa-strategy=none && python3 spa_server.py 5000 build/web
```

**Why:** Replit's preview runs over HTTP in an iframe. Flutter's service worker requires HTTPS and causes a blank screen when the PWA strategy is enabled (error: "Exception while loading service worker"). Disabling it is mandatory.

**How to apply:** Any workflow or manual build command must include `--pwa-strategy=none`.

## Cross-app service worker cache
All apps' `web/index.html` include a script that unregisters all service workers and clears all caches on load. This prevents cached assets from one app bleeding into another when they're all served on port 5000.

## Settings / language / theme pattern (all 4 apps)
- Providers: `themeModeProvider` + `localeModeProvider` (SharedPreferences, not flutter_secure_storage)
- `app.dart` watches both and passes to `MaterialApp.router` → theme/locale changes are reactive
- `_QuickToggles` widget added to sidebar footer of all 4 apps (EN/ع pill + ☀️/🌙 icon)
- restaurant-app: settings at `lib/features/settings/presentation/providers/settings_provider.dart`
- customer/driver/admin: settings at `lib/core/providers/settings_provider.dart`

## Screenshot tool limitation
The screenshot tool always captures the splash screen (1800ms branding delay before navigation). The app IS working — test auth flow in the live browser preview, not by reading screenshots.

## spa_server.py
Exists in all 4 app directories. All apps also have proper `web/index.html` with SW cleanup.
