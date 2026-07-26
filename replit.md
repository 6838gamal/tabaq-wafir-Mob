# Restaurant Copilot

A Flutter-based Restaurant Operating Intelligence Platform — helping restaurant owners, managers, and staff with daily operations, waste reduction, and profit optimization.

## Stack

- **Framework**: Flutter (Dart) — targets Web, Android, iOS
- **State Management**: Riverpod (with code generation)
- **Navigation**: GoRouter
- **Networking**: Dio
- **Local Storage**: Hive, SQLite (sqflite), Flutter Secure Storage
- **UI**: Material 3, Google Fonts, fl_chart, Lottie animations, Responsive Framework
- **Localization**: Easy Localization (English + Arabic)
- **Architecture**: Clean Architecture, Feature-First, Repository Pattern

## Features

Auth (login, OTP, forgot password), Dashboard, Orders, Inventory (products, stock count, waste), Kitchen display, Reservations, Customers, Employees, Accounting, Reports, AI Assistant, Alerts, Notifications, Settings

## User Roles

Owner, Branch Manager, Supervisor, Cashier, Kitchen, Waiter, Inventory Manager, Accountant

## How to Run

The workflow `Restaurant Copilot` builds and serves the web app:

```
flutter build web --release --no-pub && serve build/web -l 5000
```

The built output is served on port 5000.

**Note**: The app references a FastAPI backend that is not included in this repository. API calls will fail without a running backend.

## User Preferences

_None recorded yet._
