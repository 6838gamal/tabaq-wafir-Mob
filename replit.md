# Restaurant Ecosystem Platform

## Project Overview

A Flutter-based restaurant management platform currently in **Phase 1** (Restaurant App), being evolved into a full **4-app SaaS ecosystem**:

| App | Target | Status |
|-----|--------|--------|
| 🍽️ Restaurant App | Owners, Managers, Staff | ✅ Exists (`restaurant-app/`) |
| 📱 Customer App | End customers | 🔜 Planned |
| 🛵 Driver App | Delivery drivers | 🔜 Planned |
| 🖥️ Admin Dashboard | Platform owners | 🔜 Planned |

## Current Stack

- **Framework:** Flutter 3.32 (Dart 3.8)
- **State Management:** Riverpod + riverpod_annotation
- **Navigation:** GoRouter
- **HTTP:** Dio + JWT interceptor
- **Storage:** Hive + flutter_secure_storage + sqflite
- **Auth:** Google Sign-In (Google OAuth only — no email/password/OTP)
- **UI:** Material 3 + Google Fonts (Inter) + Responsive Framework
- **Localization:** AR + EN (ARB + JSON)
- **Code Gen:** freezed + json_serializable + riverpod_generator

## Architecture

Clean Architecture, feature-first folder structure:

```
restaurant-app/lib/
  core/           # ApiClient, TokenManager, RBAC, Router, Theme
  features/       # One folder per feature
  l10n/           # Translations
```

## Planned Architecture (Ecosystem)

- **Backend:** FastAPI (Python) + PostgreSQL 16 (PostGIS) + Redis
- **Shared Dart Package:** `packages/core` (ApiClient, models, theme, l10n)
- **Monorepo:** 4 Flutter apps + 1 FastAPI backend
- **Auth:** Google OAuth2 → JWT (RS256)
- **Real-time:** WebSockets (order tracking, kitchen display, driver location)
- **Maps:** Google Maps Platform (Places, Directions, Geocoding, Distance Matrix)
- **Notifications:** Firebase FCM + WhatsApp (Twilio)

## Running the App

```bash
cd restaurant-app
flutter pub get
flutter build web --release --no-pub
serve build/web -l 5000
```

Or use the **Restaurant Copilot** workflow in Replit.

## Key Design Decisions

- **Google Sign-In only** — no email, no password, no OTP, no Facebook
- **RBAC** enforced on Backend (JWT payload); Frontend RBAC is UI-only
- **Single shared backend** with role-based API access for all 4 apps
- **PostGIS** for delivery zones (polygon containment) and driver tracking
- **Offline-first** for Restaurant App (Hive + sqflite sync queue already present)
- **No breaking changes** — existing Restaurant App features are preserved and extended, not rewritten

## User Preferences

- Arabic-first product (AR + EN support)
- No code rewrite from scratch — extend and migrate existing code
- SaaS multi-tenant: one backend serves all restaurants
- Competitor benchmark: Talabat, Jahez, Uber Eats, Deliveroo
