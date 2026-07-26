# Restaurant Ecosystem Platform

The repository is organized as five top-level product/service folders:

- `restaurant-app` — the existing Flutter restaurant operations application
- `customer-app` — customer-facing application workspace
- `driver-app` — delivery driver application workspace
- `admin-dashboard` — platform administration dashboard workspace
- `backend` — shared backend/API workspace and architecture documentation

Only deployment and repository configuration files remain at the root.

## Restaurant App

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

The `Restaurant Copilot` workflow builds and serves the restaurant app:

```
cd restaurant-app && flutter build web --release --no-pub && serve build/web -l 5000
```

The built output is served on port 5000.

**Note**: The app references a FastAPI backend. The backend workspace is reserved in `backend/`, but its service implementation is not included in this imported project yet.

## User Preferences

_None recorded yet._
