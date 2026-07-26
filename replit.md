# Restaurant Copilot

**Restaurant Operating Intelligence Platform** — A comprehensive Flutter application for managing restaurants, built with Clean Architecture and Material Design 3.

## Stack

- **Framework**: Flutter 3.32 (Dart 3.8)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Networking**: Dio
- **Local Storage**: Hive, SharedPreferences, FlutterSecureStorage
- **UI**: Material 3, Google Fonts, fl_chart, Lottie
- **Localization**: easy_localization (Arabic + English, RTL/LTR)

## Running the App

```bash
flutter run -d web-server --web-port 5000 --web-hostname 0.0.0.0
```

Or use the configured workflow.

## Architecture

```
lib/
  core/            # Shared infrastructure
    constants/     # App-wide constants
    errors/        # Failure types
    network/       # Dio API client
    router/        # GoRouter configuration
    theme/         # Material 3 theme (light/dark)
    widgets/       # Shared UI components
  features/        # Feature-first modules
    auth/          # Login, OTP, forgot password, splash
    dashboard/     # KPI overview, charts
    copilot/       # AI-powered operations center
    alerts/        # Smart alerts system
    orders/        # Order management (dine-in, delivery, pickup)
    kitchen/       # Kitchen display system
    inventory/     # Stock, products, waste management
    reservations/  # Booking & waitlist
    customers/     # CRM, reviews, complaints
    employees/     # Staff, attendance, schedule, payroll
    accounting/    # Invoices, expenses, P&L
    reports/       # Analytics & reporting
    ai_assistant/  # AI chat interface
    settings/      # Profile, theme, language, security
  l10n/            # Translation files
assets/
  translations/    # en.json, ar.json
```

## User Roles

Owner · Branch Manager · Supervisor · Cashier · Kitchen · Waiter · Inventory Manager · Accountant

Each role sees its own tailored UI (access control wired to backend).

## Backend

FastAPI backend expected at `https://api.restaurantcopilot.com/v1` — configure in `lib/core/constants/app_constants.dart`. All features currently use rich mock data for web preview.

## User Preferences

- Keep Clean Architecture + Feature-First folder structure
- Arabic RTL and English LTR both supported; do not hardcode directionality
- Dark mode, light mode, and system mode all supported — test both
- No Firebase — all auth/data goes through FastAPI backend
