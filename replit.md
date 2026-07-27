# tabaq-wafir — Restaurant Copilot

A Flutter web app: a Restaurant Operating Intelligence Platform with features including POS, orders, kitchen display, inventory, analytics, AI assistant, employees, reservations, and more.

## Stack
- **Frontend**: Flutter (Dart) — web target
- **State management**: Riverpod + code generation (riverpod_annotation, freezed)
- **Navigation**: go_router
- **HTTP**: Dio
- **Local storage**: Hive, shared_preferences, flutter_secure_storage
- **Charts**: fl_chart
- **i18n**: flutter_localizations + l10n.yaml

## Project structure
```
restaurant-app/
  lib/
    main.dart          — entry point
    app.dart           — root widget / router setup
    core/              — shared utilities, theme, services
    features/          — one folder per feature (auth, dashboard, pos, orders, …)
  assets/              — images, icons, lottie animations
  web/                 — Flutter web shell (index.html, icons)
  spa_server.py        — SPA-aware Python HTTP server for serving the built web app
```

## How to run
The workflow **Restaurant Copilot** builds the Flutter web app and serves it on port 5000:
```
cd restaurant-app && flutter pub get && flutter build web --release --no-pub && python3 spa_server.py 5000 build/web
```

After code changes, restart the workflow to rebuild and re-serve.

## User preferences
