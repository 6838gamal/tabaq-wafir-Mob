# Tabaq Wafir — Restaurant Copilot

A Flutter web app: a Restaurant Operating Intelligence Platform with AI-powered insights for restaurant owners and managers.

## Stack
- **Framework**: Flutter (web target)
- **State management**: Riverpod + riverpod_generator
- **Routing**: go_router
- **Charts**: fl_chart
- **HTTP client**: Dio
- **Local storage**: Hive + SharedPreferences
- **Auth**: flutter_secure_storage + Google Sign-In
- **Localization**: Flutter gen-l10n (ARB files in `assets/translations/`)

## Project structure
```
restaurant-app/
  lib/
    features/         # Feature-first: each domain has data/domain/presentation
    core/
      theme/          # AppColors, ThemeData
      widgets/        # Shared widgets (KpiCard, AlertCard, StatusBadge, …)
      router/         # GoRouter setup (app_router.dart)
    l10n/             # Generated localization helpers
  assets/
    translations/     # en.arb, ar.arb
    images/
    animations/
    icons/
  spa_server.py       # Python static file server for the web build
```

## How to run
The workflow `Restaurant Copilot` builds and serves the Flutter web app:
```
cd restaurant-app && flutter pub get && flutter build web --release --no-pub && python3 spa_server.py 5000 build/web
```
Build output is served on port 5000.

## Screen completion status
### ✅ Complete screens
- Auth (login, OTP, forgot password, splash, session expired)
- Dashboard, Copilot, Alerts, Notifications
- Inventory (main, products, stock count, waste, recipes)
- Orders, Kitchen, Reservations, Customers, Employees
- Accounting, Reports (Sales tab only), AI Assistant
- Settings (main, profile, activity log), Promotions

### ⚠️ Inventory sub-pages — pages exist but router sends to _ComingSoon
- `suppliers_page.dart`, `purchases_page.dart`, `transfers_page.dart`, `expiry_page.dart`
  → Fix: update `app_router.dart` to route to the existing page classes

### ❌ Missing screens (router shows _ComingSoon placeholder)
- **Finance**: expenses, invoices, payments, profit, refunds
- **Operations**: branches, tables, POS, attendance, today's tasks
- **Analytics**: analytics, audit logs
- **Reports**: Inventory / Employee / Customer tabs (Sales tab is done)

## User preferences
- Arabic-first project (content is in Arabic, names follow Saudi conventions)
- Keep feature-first folder structure: `features/<name>/presentation/pages/`
- Internal widgets go inside the page file or in `core/widgets/app_widgets.dart`
- Use existing `KpiCard`, `SectionHeader`, `StatusBadge`, `EmptyState`, `AlertCard`, `AppSearchBar` from `app_widgets.dart`
- Use `AppColors.*` for all colors — never hardcode hex values
- Localization keys in `assets/translations/en.arb` and `ar.arb`; access via `.tr()` extension
