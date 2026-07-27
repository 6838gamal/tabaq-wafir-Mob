# Restaurant Ecosystem Platform — وثيقة المعمارية الشاملة

**الإصدار:** 2.0.0  
**التاريخ:** 2026-07-27  
**الحالة:** مرجع معماري نشط — لا تعديل على الكود قبل مراجعة هذه الوثيقة

---

## الفهرس

1. [تحليل الحالة الراهنة](#1-تحليل-الحالة-الراهنة)
2. [إعادة توزيع الميزات على التطبيقات الأربعة](#2-إعادة-توزيع-الميزات)
3. [معمارية Backend المشتركة](#3-معمارية-backend-المشتركة)
4. [تصميم واجهات API الموحدة](#4-تصميم-api-الموحدة)
5. [تصميم قاعدة البيانات](#5-تصميم-قاعدة-البيانات)
6. [الوحدات المشتركة](#6-الوحدات-المشتركة)
7. [نظام الصلاحيات RBAC](#7-نظام-الصلاحيات-rbac)
8. [نظام الإشعارات](#8-نظام-الإشعارات)
9. [نظام الخرائط والتتبع المباشر](#9-نظام-الخرائط-والتتبع)
10. [هيكل المجلدات لكل تطبيق](#10-هيكل-المجلدات)
11. [الشاشات الكاملة لكل تطبيق](#11-الشاشات-الكاملة)
12. [تجربة المستخدم UX Flow](#12-ux-flow)
13. [التحسينات التنافسية](#13-التحسينات-التنافسية)

---

## 1. تحليل الحالة الراهنة

### ما يوجد فعلاً

| المكوّن | الحالة | الملاحظات |
|---------|--------|-----------|
| `restaurant-app/` | ✅ Flutter web — بنية نظيفة | Clean Architecture + Riverpod + GoRouter محفوظة |
| `backend/` | ⚙️ FastAPI — هيكل موجود | نماذج DB + Auth + RBAC + Inventory جاهزة، تحتاج PostgreSQL + Redis |
| `customer-app/` | 🗂️ Placeholder فارغ | pubspec.yaml موجود، لا كود |
| `driver-app/` | 🗂️ Placeholder فارغ | pubspec.yaml موجود، لا كود |
| `admin-dashboard/` | 🗂️ Placeholder فارغ | pubspec.yaml موجود، لا كود |

### ما هو مكتمل في Restaurant App (77 ملف Dart)

**Core Layer:**
- `ApiClient` (Dio + JWT interceptor + 401 handling)
- `TokenManager` (flutter_secure_storage)
- `RBAC` — UserRole enum (9 أدوار) + Permission enum + role→permissions map
- `GoRouter` — كل المسارات معرّفة مع guard للمصادقة
- Theme (Material 3 + Inter) + Localization (AR/EN)

**Features الموجودة بكود كامل:**
- Auth (Google Sign-In + Demo mode + session restore)
- Dashboard
- Branches (model + provider)
- Inventory (Items, Recipes, Suppliers, Purchases, StockCount, Waste, Expiry, Transfers)
- Orders
- Kitchen Display
- Promotions (Offers + Coupons) — Clean Architecture كاملة مع domain/data/presentation
- Employees
- Reports
- Reservations
- Tables (domain entity)
- Settings (Profile + ActivityLog)
- Notifications
- Copilot AI
- AI Assistant
- Accounting

**ملاحظة مهمة:** جميع الصفحات موجودة. بعضها placeholder جاهز للتطوير، وبعضها (Promotions خاصةً) مكتمل Clean Architecture. لا يُحذف أي منها.

### ما يوجد في Backend (27 ملف Python)

**Models مكتملة:** User, Restaurant/Branch, Order/OrderItem, InventoryItem/Batch/StockMovement/Supplier/Purchase/Recipe  
**Auth:** Google OAuth2 → JWT (HS256) مع app_type routing  
**RBAC:** 17 دور + 26 صلاحية + ROLE_PERMISSIONS map  
**APIs:** auth, dashboard, inventory, purchases, recipes, suppliers, transfers, admin/restaurants  
**Config:** DATABASE_URL, REDIS_URL, JWT, Google, AWS S3, Firebase FCM — كلها في Settings

---

## 2. إعادة توزيع الميزات

### مبدأ التوزيع

> كل ميزة تبقى في التطبيق الذي يملك workflow الخاص بها. الـ Backend يُعرّض نفس الموارد لكل التطبيقات بتحقق من الدور. لا حذف — فقط إعادة توجيه.

### Restaurant App — يبقى كما هو + توسعة

| الميزة الحالية | الإجراء | ملاحظة |
|----------------|---------|--------|
| Dashboard | ✅ يبقى | توسعة بـ real-time widgets |
| Restaurant Copilot AI | ✅ يبقى | |
| Branches | ✅ يبقى | |
| Products / Categories / Add-ons | ✅ يبقى | + control visibility in Customer App |
| Inventory (كامل) | ✅ يبقى | |
| Orders | ✅ يبقى | + WebSocket لـ real-time |
| Kitchen Display | ✅ يبقى | |
| Tables + Reservations | ✅ يبقى | |
| Employees + Attendance + Payroll | ✅ يبقى | |
| Customers (CRM خفيف) | ✅ يبقى | |
| Promotions + Coupons | ✅ يبقى | مكتملة Clean Architecture |
| Reports + Analytics | ✅ يبقى | |
| Settings | ✅ يبقى | |
| Notifications | ✅ يبقى | |
| WhatsApp Center | 🔜 تُضاف | Twilio integration |
| AI Assistant | ✅ يبقى | |
| Accounting | ✅ يبقى | |
| **Maps — Driver Monitoring** | 🆕 تُضاف | مراقبة المندوبين على الخريطة |
| **Delivery Zones Drawing** | 🆕 تُضاف | رسم مناطق التوصيل + رسوم لكل منطقة |

### Customer App — يُبنى من الصفر (placeholder موجود)

| الميزة | المصدر | ملاحظة |
|--------|--------|--------|
| Google Sign-In + Guest | Backend /auth/google?app_type=customer | نفس نقطة النهاية |
| Discovery / Search / Filters | API جديد /catalog | يستهلك products + restaurants |
| Restaurant Details + Menu | API /restaurants/{id}/menu | |
| Cart + Coupons + Checkout | API /orders (CREATE_ORDERS) | |
| Saved Addresses + Maps | Google Maps SDK | |
| Live Order Tracking | WebSocket /ws/orders/{id} | نفس channel المطعم |
| Driver Location | WebSocket /ws/drivers/{id} | |
| Restaurant Chat + Driver Chat | WebSocket /ws/chat/{room} | |
| Ratings + Reviews | API /reviews | |
| Order History + Reorder | API /orders?customer_id= | |
| Profile + Language + Theme | محلي + PATCH /auth/me | |
| Notifications | Firebase FCM | |
| Dark Mode | محلي | |

### Driver App — يُبنى من الصفر (placeholder موجود)

| الميزة | المصدر | ملاحظة |
|--------|--------|--------|
| Google Sign-In | Backend /auth/google?app_type=driver | |
| Identity Verification + Documents | API /drivers/verification | |
| Online/Offline Toggle | PATCH /drivers/status | |
| Delivery Offers | WebSocket /ws/drivers/{id}/offers | |
| Accept/Reject | POST /deliveries/{id}/accept|reject | |
| Navigation to Restaurant/Customer | Google Maps Directions API | |
| Live Location Sharing | WebSocket /ws/drivers/{id}/location | كل 5 ثوانٍ |
| Proof of Delivery (Photo + Signature) | POST /deliveries/{id}/proof | S3 upload |
| Cash on Delivery + Wallet | API /wallet | |
| Earnings + History | API /earnings | |
| Ratings | API /reviews | |
| Support Chat | API /support/chat | |

### Admin Dashboard — يُبنى من الصفر (placeholder موجود)

| الميزة | المصدر | ملاحظة |
|--------|--------|--------|
| All Restaurants | GET /admin/restaurants | MANAGE_PLATFORM صلاحية |
| Subscriptions + Plans | API /admin/subscriptions | |
| Customers + Drivers | GET /admin/users?role= | |
| Cities + Delivery Zones | API /admin/zones | PostGIS |
| Commissions + Payments | API /admin/finances | |
| Coupons + Advertising | API /admin/promotions | |
| Complaints + Support | API /admin/tickets | |
| Analytics | API /admin/analytics | |
| AI Monitoring | API /admin/ai-jobs | |
| Audit Logs | GET /audit-logs | VIEW_AUDIT_LOGS |

---

## 3. معمارية Backend المشتركة

### نمط المعمارية

```
┌─────────────────────────────────────────────────────────┐
│                    API Gateway Layer                     │
│         FastAPI + Uvicorn (async) + Nginx proxy         │
├──────────────┬──────────────┬───────────────────────────┤
│  REST API    │  WebSocket   │   Background Workers       │
│  /api/v1/    │  /ws/        │   Celery + Redis           │
├──────────────┴──────────────┴───────────────────────────┤
│                   Core Services Layer                    │
│  Auth │ RBAC │ Tenant │ Audit │ Rate-Limit │ Cache      │
├────────────────────────────────────────────────────────-─┤
│                  Domain Services Layer                   │
│  Orders │ Catalog │ Inventory │ Delivery │ Chat │ AI    │
├──────────────────────────────────────────────────────────┤
│                   Data Layer                             │
│  PostgreSQL 16 (PostGIS) │ Redis │ S3 │ Firebase FCM   │
└──────────────────────────────────────────────────────────┘
```

### مبادئ لا تنكسر

1. **Multi-tenancy عبر `restaurant_id`** — كل query يُقيَّد بـ tenant تلقائياً عبر Dependency
2. **RBAC على Backend** — Frontend RBAC للـ UI فقط، Backend يتحقق من كل طلب
3. **Shared Resource IDs** — نفس `order_id` يُستخدم في كل التطبيقات الأربعة
4. **Audit Log إلزامي** — كل mutation تُسجَّل في `audit_events`
5. **لا Breaking Changes** — إضافة endpoints جديدة، لا تغيير على الموجودة
6. **Versioning** — `/api/v1/` ثابت، أي تغيير جذري → `/api/v2/`

### هيكل مجلدات Backend

```
backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       ├── auth.py              ✅ موجود
│   │       ├── restaurant/          ✅ موجود
│   │       │   ├── dashboard.py
│   │       │   ├── catalog.py       🔜 يُضاف (products, categories, addons)
│   │       │   ├── inventory.py     ✅ موجود
│   │       │   ├── orders.py        🔜 يُضاف
│   │       │   ├── kitchen.py       🔜 يُضاف
│   │       │   ├── tables.py        🔜 يُضاف
│   │       │   ├── reservations.py  🔜 يُضاف
│   │       │   ├── employees.py     🔜 يُضاف
│   │       │   ├── promotions.py    🔜 يُضاف
│   │       │   ├── reports.py       🔜 يُضاف
│   │       │   └── settings.py      🔜 يُضاف
│   │       ├── customer/            🔜 يُضاف
│   │       │   ├── discovery.py
│   │       │   ├── cart.py
│   │       │   ├── checkout.py
│   │       │   ├── addresses.py
│   │       │   └── reviews.py
│   │       ├── driver/              🔜 يُضاف
│   │       │   ├── delivery.py
│   │       │   ├── location.py
│   │       │   ├── wallet.py
│   │       │   └── verification.py
│   │       ├── admin/               ⚙️ يُوسَّع
│   │       │   ├── restaurants.py   ✅ موجود
│   │       │   ├── subscriptions.py 🔜
│   │       │   ├── users.py         🔜
│   │       │   ├── zones.py         🔜
│   │       │   └── analytics.py     🔜
│   │       └── shared/              🔜 يُضاف
│   │           ├── notifications.py
│   │           ├── chat.py
│   │           └── uploads.py
│   ├── core/
│   │   ├── config.py                ✅ موجود
│   │   ├── database.py              ✅ موجود
│   │   ├── deps.py                  ✅ موجود
│   │   ├── permissions.py           ✅ موجود
│   │   ├── security.py              ✅ موجود
│   │   ├── tenant.py                🔜 يُضاف (tenant isolation middleware)
│   │   ├── cache.py                 🔜 يُضاف (Redis helpers)
│   │   └── audit.py                 🔜 يُضاف
│   ├── models/                      ✅ موجود جزئياً — يُوسَّع
│   ├── schemas/                     ✅ موجود جزئياً — يُوسَّع
│   ├── services/                    🔜 يُضاف (business logic layer)
│   │   ├── order_service.py
│   │   ├── delivery_service.py
│   │   ├── notification_service.py
│   │   ├── ai_service.py
│   │   └── maps_service.py
│   └── websockets/                  🔜 يُضاف
│       ├── connection_manager.py
│       ├── order_ws.py
│       ├── driver_ws.py
│       └── chat_ws.py
├── alembic/                         🔜 migrations
├── tests/
├── Dockerfile                       ✅ موجود
├── requirements.txt                 ✅ موجود
└── main.py                          ✅ موجود
```

---

## 4. تصميم API الموحدة

### قواعد عامة

```
Base URL:     /api/v1
Auth header:  Authorization: Bearer <access_token>
Pagination:   ?page=1&limit=20
Multi-lang:   Accept-Language: ar | en
Tenant scope: مُضمَّن في JWT (restaurant_id)
Response:     { data, meta?, error? }
Errors:       { error: { code, message, details? } }
```

### Auth — `/api/v1/auth`

| Method | Path | الدور | الوصف |
|--------|------|-------|-------|
| POST | `/google` | Public | Google OAuth → JWT. `app_type`: restaurant\|customer\|driver |
| POST | `/refresh` | Public | تجديد Access Token |
| GET | `/me` | Any | بيانات المستخدم الحالي |
| PUT | `/me` | Any | تحديث الملف الشخصي + FCM token |
| POST | `/logout` | Any | إبطال الجلسة (Redis blacklist) |

### Catalog — `/api/v1/catalog` (Public + Tenant-scoped)

| Method | Path | الوصف |
|--------|------|-------|
| GET | `/restaurants` | اكتشاف المطاعم (للعميل) |
| GET | `/restaurants/{id}` | تفاصيل مطعم |
| GET | `/restaurants/{id}/menu` | المنيو الكامل |
| GET | `/restaurants/{id}/menu/search` | بحث في المنيو |
| GET | `/categories` | تصنيفات المنصة |
| GET | `/bestsellers` | الأكثر مبيعاً |
| GET | `/nearby` | المطاعم القريبة (lat/lng) |

### Orders — `/api/v1/orders`

| Method | Path | الأدوار | الوصف |
|--------|------|---------|-------|
| POST | `/` | customer | إنشاء طلب جديد |
| GET | `/` | restaurant_staff, customer | قائمة الطلبات |
| GET | `/{id}` | Any owner | تفاصيل طلب |
| PATCH | `/{id}/status` | cashier, manager | تحديث حالة |
| PATCH | `/{id}/kitchen` | kitchen | حالة المطبخ |
| POST | `/{id}/assign-driver` | manager | تعيين مندوب |
| GET | `/{id}/tracking` | customer | تتبع الطلب |
| WebSocket | `/ws/orders/{id}` | Any | real-time updates |
| WebSocket | `/ws/kitchen/{branch_id}` | kitchen | KDS live feed |

### Delivery — `/api/v1/deliveries`

| Method | Path | الوصف |
|--------|------|-------|
| GET | `/offers` | عروض التوصيل للمندوب |
| POST | `/{id}/accept` | قبول طلب توصيل |
| POST | `/{id}/reject` | رفض |
| PATCH | `/{id}/location` | تحديث موقع المندوب |
| POST | `/{id}/proof` | رفع إثبات التسليم |
| WebSocket | `/ws/drivers/{id}/location` | بث الموقع |
| WebSocket | `/ws/drivers/{id}/offers` | استقبال العروض |

### Inventory — `/api/v1/inventory` ✅ موجود جزئياً

| Path | الوصف |
|------|-------|
| `/items` CRUD | عناصر المخزون |
| `/batches` CRUD | الدفعات وتواريخ الصلاحية |
| `/movements` | حركات المخزون |
| `/suppliers` CRUD | الموردون |
| `/purchases` CRUD | المشتريات |
| `/recipes` CRUD | الوصفات |
| `/stock-count` POST | جرد دوري |
| `/waste` CRUD | سجل الهدر |
| `/transfers` CRUD | تحويل بين الفروع |

### Notifications — `/api/v1/notifications`

| Method | Path | الوصف |
|--------|------|-------|
| GET | `/` | قائمة الإشعارات |
| PATCH | `/{id}/read` | تعليم كمقروء |
| PATCH | `/read-all` | تعليم الكل |
| DELETE | `/{id}` | حذف |
| POST | `/subscribe` | تسجيل FCM token |

### Chat — `/api/v1/chat`

| Method | Path | الوصف |
|--------|------|-------|
| GET | `/rooms` | غرف المحادثة |
| GET | `/rooms/{id}/messages` | الرسائل |
| POST | `/rooms/{id}/messages` | إرسال رسالة |
| WebSocket | `/ws/chat/{room_id}` | محادثة لحظية |

### Admin — `/api/v1/admin`

| Path | الصلاحية |
|------|----------|
| `/restaurants` CRUD | MANAGE_PLATFORM |
| `/subscriptions` CRUD | MANAGE_SUBSCRIPTIONS |
| `/users` GET/PATCH | MANAGE_PLATFORM |
| `/zones` CRUD | MANAGE_PLATFORM |
| `/finances` GET | (finance role) |
| `/analytics` GET | VIEW_ANALYTICS |
| `/ai-jobs` GET | MANAGE_PLATFORM |
| `/audit-logs` GET | VIEW_AUDIT_LOGS |

---

## 5. تصميم قاعدة البيانات

### مبادئ التصميم

- **UUID v4** لكل primary key
- **`restaurant_id` إلزامي** في كل جدول يخص مطعماً (tenant isolation)
- **`branch_id` اختياري** للبيانات متعددة الفروع
- **Soft delete** (`deleted_at`) بدلاً من حذف حقيقي
- **`updated_at` + `created_at`** في كل جدول
- **PostGIS** للمناطق الجغرافية
- **JSONB** للبيانات المرنة (modifiers, metadata, settings)

### مخطط الجداول

```sql
-- =============================================
-- PLATFORM LAYER
-- =============================================

CREATE TABLE users (
    id              UUID PRIMARY KEY,
    google_id       VARCHAR(255) UNIQUE,
    name            VARCHAR(255) NOT NULL,
    email           VARCHAR(255) UNIQUE,
    phone           VARCHAR(30),
    avatar_url      TEXT,
    role            VARCHAR(50) NOT NULL,          -- 17 roles
    restaurant_id   UUID REFERENCES restaurants,
    branch_id       UUID REFERENCES branches,
    locale          VARCHAR(10) DEFAULT 'ar',
    fcm_tokens      JSONB DEFAULT '[]',
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE audit_events (
    id              UUID PRIMARY KEY,
    user_id         UUID REFERENCES users,
    restaurant_id   UUID,
    action          VARCHAR(100) NOT NULL,         -- 'order.created', 'user.role_changed'
    resource_type   VARCHAR(50),
    resource_id     UUID,
    old_value       JSONB,
    new_value       JSONB,
    ip_address      VARCHAR(45),
    user_agent      TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- RESTAURANT LAYER
-- =============================================

CREATE TABLE restaurants (
    id              UUID PRIMARY KEY,
    platform_name   VARCHAR(255) NOT NULL,         -- اسم المنصة الداخلي
    display_name    JSONB NOT NULL,                -- {"ar": "...", "en": "..."}
    description     JSONB,
    logo_url        TEXT,
    cover_url       TEXT,
    cuisine_types   TEXT[],
    contact         JSONB,                         -- {phone, whatsapp, email}
    address         JSONB,
    subscription_id UUID REFERENCES subscriptions,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE branches (
    id              UUID PRIMARY KEY,
    restaurant_id   UUID REFERENCES restaurants NOT NULL,
    name            JSONB NOT NULL,               -- {"ar": "...", "en": "..."}
    address         JSONB,
    location        GEOGRAPHY(POINT, 4326),       -- PostGIS
    phone           VARCHAR(30),
    is_main         BOOLEAN DEFAULT false,
    is_active       BOOLEAN DEFAULT true,
    working_hours   JSONB,                        -- [{day, open, close, is_closed}]
    settings        JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE delivery_zones (
    id              UUID PRIMARY KEY,
    branch_id       UUID REFERENCES branches NOT NULL,
    name            VARCHAR(100),
    polygon         GEOGRAPHY(POLYGON, 4326),     -- PostGIS
    delivery_fee    NUMERIC(8,2) NOT NULL,
    min_order       NUMERIC(8,2) DEFAULT 0,
    estimated_time  SMALLINT,                     -- دقائق
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- CATALOG LAYER
-- =============================================

CREATE TABLE categories (
    id              UUID PRIMARY KEY,
    restaurant_id   UUID REFERENCES restaurants NOT NULL,
    name            JSONB NOT NULL,
    image_url       TEXT,
    sort_order      SMALLINT DEFAULT 0,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE products (
    id              UUID PRIMARY KEY,
    restaurant_id   UUID REFERENCES restaurants NOT NULL,
    category_id     UUID REFERENCES categories,
    name            JSONB NOT NULL,
    description     JSONB,
    image_url       TEXT,
    price           NUMERIC(10,2) NOT NULL,
    cost_price      NUMERIC(10,2),               -- للتكلفة الداخلية
    sku             VARCHAR(100),
    barcode         VARCHAR(100),
    calories        SMALLINT,
    prep_time       SMALLINT,                    -- دقائق
    status          VARCHAR(20) DEFAULT 'available', -- available|unavailable|hidden
    is_visible_in_app BOOLEAN DEFAULT true,      -- التحكم في ظهور في Customer App
    sort_order      SMALLINT DEFAULT 0,
    tags            TEXT[],
    metadata        JSONB DEFAULT '{}',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE addon_groups (
    id              UUID PRIMARY KEY,
    restaurant_id   UUID REFERENCES restaurants NOT NULL,
    name            JSONB NOT NULL,
    min_select      SMALLINT DEFAULT 0,
    max_select      SMALLINT DEFAULT 1,
    is_required     BOOLEAN DEFAULT false,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE TABLE addons (
    id              UUID PRIMARY KEY,
    group_id        UUID REFERENCES addon_groups NOT NULL,
    name            JSONB NOT NULL,
    price           NUMERIC(8,2) DEFAULT 0,
    is_active       BOOLEAN DEFAULT true,
    sort_order      SMALLINT DEFAULT 0
);

CREATE TABLE product_addon_groups (
    product_id      UUID REFERENCES products,
    group_id        UUID REFERENCES addon_groups,
    PRIMARY KEY (product_id, group_id)
);

-- =============================================
-- ORDERS LAYER
-- =============================================

CREATE TABLE orders (                            -- ✅ موجود — يُوسَّع
    id              UUID PRIMARY KEY,
    order_number    VARCHAR(30) UNIQUE NOT NULL,
    restaurant_id   UUID NOT NULL,
    branch_id       UUID,
    customer_id     UUID REFERENCES users,
    driver_id       UUID REFERENCES users,
    table_number    VARCHAR(20),
    type            VARCHAR(20) NOT NULL,        -- delivery|pickup|dine_in
    status          VARCHAR(30) DEFAULT 'pending',
    -- pending → accepted → preparing → ready → picked_up → delivered | cancelled
    payment_status  VARCHAR(20) DEFAULT 'pending',
    payment_method  VARCHAR(30),
    payment_ref     VARCHAR(100),               -- مرجع بوابة الدفع
    subtotal        NUMERIC(10,2) DEFAULT 0,
    delivery_fee    NUMERIC(8,2) DEFAULT 0,
    discount        NUMERIC(8,2) DEFAULT 0,
    coupon_id       UUID,
    tax             NUMERIC(8,2) DEFAULT 0,
    total           NUMERIC(10,2) DEFAULT 0,
    delivery_address JSONB,
    delivery_zone_id UUID REFERENCES delivery_zones,
    notes           TEXT,
    estimated_time  SMALLINT,
    accepted_at     TIMESTAMPTZ,
    preparing_at    TIMESTAMPTZ,
    ready_at        TIMESTAMPTZ,
    picked_at       TIMESTAMPTZ,
    delivered_at    TIMESTAMPTZ,
    cancelled_at    TIMESTAMPTZ,
    cancel_reason   TEXT,
    rating          SMALLINT,
    rating_comment  TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE order_items (                       -- ✅ موجود — يُوسَّع
    id              UUID PRIMARY KEY,
    order_id        UUID REFERENCES orders NOT NULL,
    product_id      UUID,
    name            VARCHAR(255) NOT NULL,
    price           NUMERIC(10,2) NOT NULL,
    quantity        SMALLINT DEFAULT 1,
    modifiers       JSONB DEFAULT '{}',          -- الإضافات المختارة
    notes           TEXT,
    kitchen_status  VARCHAR(20) DEFAULT 'pending'
);

-- =============================================
-- DELIVERY LAYER
-- =============================================

CREATE TABLE driver_locations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id       UUID REFERENCES users NOT NULL,
    location        GEOGRAPHY(POINT, 4326) NOT NULL,
    heading         NUMERIC(5,2),               -- درجة الاتجاه
    speed           NUMERIC(5,2),               -- كم/ساعة
    accuracy        NUMERIC(6,2),
    recorded_at     TIMESTAMPTZ DEFAULT NOW()
);
-- Index: CREATE INDEX ON driver_locations (driver_id, recorded_at DESC);

CREATE TABLE deliveries (
    id              UUID PRIMARY KEY,
    order_id        UUID REFERENCES orders UNIQUE NOT NULL,
    driver_id       UUID REFERENCES users,
    pickup_location GEOGRAPHY(POINT, 4326),
    dropoff_location GEOGRAPHY(POINT, 4326),
    distance_km     NUMERIC(6,2),
    duration_min    SMALLINT,
    route           JSONB,                       -- encoded polyline
    proof_photo_url TEXT,
    signature_url   TEXT,
    cash_collected  NUMERIC(10,2),
    status          VARCHAR(30) DEFAULT 'searching',
    assigned_at     TIMESTAMPTZ,
    picked_at       TIMESTAMPTZ,
    delivered_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- CUSTOMER LAYER
-- =============================================

CREATE TABLE customer_addresses (
    id              UUID PRIMARY KEY,
    customer_id     UUID REFERENCES users NOT NULL,
    label           VARCHAR(50),               -- 'home'|'work'|custom
    address_line    TEXT,
    city            VARCHAR(100),
    location        GEOGRAPHY(POINT, 4326),
    is_default      BOOLEAN DEFAULT false,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE favorites (
    customer_id     UUID REFERENCES users,
    restaurant_id   UUID REFERENCES restaurants,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (customer_id, restaurant_id)
);

CREATE TABLE reviews (
    id              UUID PRIMARY KEY,
    order_id        UUID REFERENCES orders UNIQUE,
    customer_id     UUID REFERENCES users,
    restaurant_id   UUID REFERENCES restaurants,
    driver_id       UUID REFERENCES users,
    restaurant_rating SMALLINT,               -- 1-5
    driver_rating   SMALLINT,
    comment         TEXT,
    response        TEXT,                     -- رد المطعم
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- CHAT LAYER
-- =============================================

CREATE TABLE chat_rooms (
    id              UUID PRIMARY KEY,
    order_id        UUID REFERENCES orders,
    type            VARCHAR(30),               -- customer_restaurant|customer_driver|support
    participants    UUID[],
    last_message_at TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE chat_messages (
    id              UUID PRIMARY KEY,
    room_id         UUID REFERENCES chat_rooms NOT NULL,
    sender_id       UUID REFERENCES users NOT NULL,
    content         TEXT,
    media_url       TEXT,
    type            VARCHAR(20) DEFAULT 'text', -- text|image|location
    is_read         BOOLEAN DEFAULT false,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- EMPLOYEES LAYER
-- =============================================

CREATE TABLE employees (
    id              UUID PRIMARY KEY,
    user_id         UUID REFERENCES users,
    restaurant_id   UUID REFERENCES restaurants NOT NULL,
    branch_id       UUID REFERENCES branches,
    employee_number VARCHAR(50),
    national_id     VARCHAR(50),
    role            VARCHAR(50) NOT NULL,
    salary          NUMERIC(10,2),
    hire_date       DATE,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE attendance (
    id              UUID PRIMARY KEY,
    employee_id     UUID REFERENCES employees NOT NULL,
    branch_id       UUID REFERENCES branches,
    check_in        TIMESTAMPTZ,
    check_out       TIMESTAMPTZ,
    location_in     GEOGRAPHY(POINT, 4326),
    location_out    GEOGRAPHY(POINT, 4326),
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE schedules (
    id              UUID PRIMARY KEY,
    employee_id     UUID REFERENCES employees NOT NULL,
    branch_id       UUID REFERENCES branches,
    start_at        TIMESTAMPTZ NOT NULL,
    end_at          TIMESTAMPTZ NOT NULL,
    notes           TEXT
);

-- =============================================
-- PROMOTIONS LAYER
-- =============================================

CREATE TABLE offers (
    id              UUID PRIMARY KEY,
    restaurant_id   UUID REFERENCES restaurants NOT NULL,
    title           JSONB NOT NULL,
    description     JSONB,
    image_url       TEXT,
    discount_type   VARCHAR(20),               -- percentage|fixed
    discount_value  NUMERIC(8,2),
    product_ids     UUID[],                    -- null = all products
    min_order       NUMERIC(8,2),
    starts_at       TIMESTAMPTZ,
    ends_at         TIMESTAMPTZ,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE coupons (
    id              UUID PRIMARY KEY,
    restaurant_id   UUID REFERENCES restaurants,  -- null = platform coupon
    code            VARCHAR(50) UNIQUE NOT NULL,
    discount_type   VARCHAR(20),
    discount_value  NUMERIC(8,2),
    max_uses        INTEGER,
    used_count      INTEGER DEFAULT 0,
    per_user_limit  SMALLINT DEFAULT 1,
    min_order       NUMERIC(8,2),
    applicable_to   VARCHAR(30) DEFAULT 'all',   -- all|delivery|pickup|dine_in
    starts_at       TIMESTAMPTZ,
    expires_at      TIMESTAMPTZ,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- SUBSCRIPTIONS LAYER (Admin)
-- =============================================

CREATE TABLE subscription_plans (
    id              UUID PRIMARY KEY,
    name            JSONB NOT NULL,
    price           NUMERIC(10,2) NOT NULL,
    billing_cycle   VARCHAR(20),               -- monthly|yearly
    max_branches    SMALLINT,
    max_products    INTEGER,
    features        JSONB,                     -- قائمة المزايا
    is_active       BOOLEAN DEFAULT true
);

CREATE TABLE subscriptions (
    id              UUID PRIMARY KEY,
    restaurant_id   UUID REFERENCES restaurants NOT NULL,
    plan_id         UUID REFERENCES subscription_plans,
    status          VARCHAR(20) DEFAULT 'trial', -- trial|active|suspended|cancelled
    started_at      TIMESTAMPTZ,
    expires_at      TIMESTAMPTZ,
    auto_renew      BOOLEAN DEFAULT true,
    payment_method  JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- NOTIFICATIONS LAYER
-- =============================================

CREATE TABLE notifications (
    id              UUID PRIMARY KEY,
    user_id         UUID REFERENCES users NOT NULL,
    type            VARCHAR(50) NOT NULL,       -- order_status|new_order|driver_assigned|...
    title           JSONB NOT NULL,
    body            JSONB,
    data            JSONB DEFAULT '{}',
    channel         VARCHAR(20) DEFAULT 'push', -- push|whatsapp|in_app
    is_read         BOOLEAN DEFAULT false,
    sent_at         TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- DRIVER LAYER
-- =============================================

CREATE TABLE driver_profiles (
    id              UUID PRIMARY KEY,
    user_id         UUID REFERENCES users UNIQUE NOT NULL,
    national_id     VARCHAR(50),
    license_number  VARCHAR(50),
    vehicle_type    VARCHAR(30),               -- motorcycle|car|bicycle
    vehicle_plate   VARCHAR(20),
    documents       JSONB DEFAULT '[]',        -- [{type, url, expires_at, verified}]
    is_verified     BOOLEAN DEFAULT false,
    is_online       BOOLEAN DEFAULT false,
    rating_avg      NUMERIC(3,2) DEFAULT 0,
    total_deliveries INTEGER DEFAULT 0,
    wallet_balance  NUMERIC(10,2) DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE driver_earnings (
    id              UUID PRIMARY KEY,
    driver_id       UUID REFERENCES users NOT NULL,
    delivery_id     UUID REFERENCES deliveries,
    amount          NUMERIC(8,2) NOT NULL,
    type            VARCHAR(20),               -- delivery|bonus|deduction
    notes           TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

### Indexes الحرجة

```sql
-- Tenant isolation
CREATE INDEX ON products (restaurant_id) WHERE deleted_at IS NULL;
CREATE INDEX ON orders (restaurant_id, created_at DESC);
CREATE INDEX ON orders (customer_id, created_at DESC);
CREATE INDEX ON orders (driver_id) WHERE status NOT IN ('delivered','cancelled');

-- Geo queries
CREATE INDEX ON branches USING GIST (location);
CREATE INDEX ON delivery_zones USING GIST (polygon);
CREATE INDEX ON driver_locations USING GIST (location);
CREATE INDEX ON customer_addresses USING GIST (location);

-- Real-time
CREATE INDEX ON driver_locations (driver_id, recorded_at DESC);
CREATE INDEX ON chat_messages (room_id, created_at DESC);
CREATE INDEX ON notifications (user_id, is_read, created_at DESC);
```

---

## 6. الوحدات المشتركة

### 6.1 Authentication Module

```
Google ID Token → /api/v1/auth/google?app_type={restaurant|customer|driver}
↓
Backend يتحقق من ID Token مع Google
↓
يجد أو ينشئ User بالدور المناسب
↓
يُصدر JWT Access Token (60 دقيقة) + Refresh Token (30 يوم)
↓
JWT Payload: { sub, role, restaurant_id, branch_id, exp }
```

**app_type routing:**
| app_type | default_role |
|----------|-------------|
| restaurant | restaurant_owner |
| customer | customer |
| driver | driver |
| (admin يُضاف يدوياً) | platform_admin |

**Guest في Customer App:**
- لا يحتاج تسجيل دخول للتصفح وبناء السلة
- عند الـ Checkout: يُطلب Google Sign-In
- يُحفظ السلة في Hive محلياً حتى تسجيل الدخول

### 6.2 Orders Module (Shared State Machine)

```
[pending] → [accepted] → [preparing] → [ready] → [picked_up] → [delivered]
                                                              ↗
[pending] → [cancelled]
[accepted] → [cancelled]
[preparing] → [cancelled] (بموافقة Manager)
```

**Actors per transition:**

| From → To | Actor | WebSocket Event |
|-----------|-------|-----------------|
| pending → accepted | cashier/manager | `order.accepted` |
| accepted → preparing | kitchen | `order.preparing` |
| preparing → ready | kitchen | `order.ready` |
| ready → picked_up | driver | `order.picked_up` |
| picked_up → delivered | driver | `order.delivered` |
| any → cancelled | manager/customer | `order.cancelled` |

**WebSocket Rooms:**
- `kitchen:{branch_id}` — KDS يستمع لكل طلبات الفرع
- `order:{order_id}` — Customer + Restaurant يستمعان لطلب محدد
- `driver:{driver_id}` — المندوب يستمع للعروض الجديدة

### 6.3 Notifications Module

```
Trigger Event (order status change, etc.)
↓
Notification Service (Python)
↓
┌─────────────┬──────────────┬──────────────┐
│ Firebase FCM│  WhatsApp    │   In-App     │
│ (Push)      │  (Twilio)    │   (DB + WS)  │
└─────────────┴──────────────┴──────────────┘
```

**Events → Channels:**

| Event | Customer | Restaurant | Driver |
|-------|----------|------------|--------|
| order.accepted | Push + InApp | — | — |
| order.preparing | Push | — | — |
| order.ready | — | Push + InApp | — |
| order.picked_up | Push + WA | InApp | — |
| order.delivered | Push + WA | InApp | InApp |
| new_delivery_offer | — | — | Push + InApp |
| low_stock | — | Push + WA | — |
| reservation_reminder | Push + WA | Push | — |

### 6.4 Maps Module

خدمة Google Maps Platform:

| Service | الاستخدام |
|---------|-----------|
| Places API (Autocomplete) | اختيار العنوان في Customer App |
| Geocoding API | lat/lng ↔ address |
| Directions API | أفضل مسار للمندوب |
| Distance Matrix API | حساب رسوم التوصيل |
| Maps JavaScript SDK (web) | رسم مناطق التوصيل في Restaurant App |
| Maps Flutter SDK (mobile) | Customer App + Driver App |

### 6.5 Payments Module

```
Customer → اختيار طريقة الدفع
↓
┌─────────────────────────────┐
│ بطاقة: Stripe / Moyasar    │
│ Apple/Google Pay            │
│ Cash on Delivery            │
│ محفظة داخلية               │
└─────────────────────────────┘
↓
Payment Reference يُحفظ في orders.payment_ref
↓
Webhook يُحدّث payment_status
```

### 6.6 Chat Module

```
WebSocket /ws/chat/{room_id}
↓
ConnectionManager (Redis Pub/Sub للـ horizontal scaling)
↓
Messages تُحفظ في DB (chat_messages)
↓
Unread count يُبثّ عبر WS
```

**أنواع الغرف:**
- `customer_restaurant:{order_id}` — بين العميل والمطعم
- `customer_driver:{order_id}` — بين العميل والمندوب
- `support:{ticket_id}` — مع الدعم الفني

### 6.7 AI Module

**Restaurant Copilot:**
- تحليل المبيعات والتوصيات
- تنبيهات المخزون الذكية
- اقتراح قائمة المنيو
- تحليل التعليقات

**يعمل عبر:**
- Celery tasks للتحليلات الدورية
- OpenAI / Gemini API للمحادثة
- نقطة نهاية: `POST /api/v1/ai/query`

### 6.8 Uploads Module

```
Client → POST /api/v1/uploads/presigned-url
Backend → S3 presigned URL (15 دقيقة)
Client → PUT مباشرة لـ S3
Client → PATCH resource بـ URL الجديد
```

**أنواع الملفات المقبولة:** jpg/png/webp للصور، pdf للمستندات، mp4/mov لإثبات التسليم

---

## 7. نظام الصلاحيات RBAC

### الأدوار الكاملة (17 دور)

```
Platform Layer:
  platform_owner    → كل الصلاحيات بلا استثناء
  platform_admin    → إدارة المنصة بدون تعديل بيانات المطاعم
  support           → قراءة + تعديل محدود (الشكاوى والدعم)
  finance           → قراءة المالية + التقارير

Restaurant Layer:
  restaurant_owner  → كل صلاحيات مطعمه
  general_manager   → مثل owner إلا manage_settings و manage_branches و manage_payroll
  branch_manager    → صلاحيات فرعه فقط
  supervisor        → view_* + create_orders + manage_kitchen
  cashier           → orders + accounting (view)
  kitchen           → kitchen + orders (view)
  waiter            → tables + orders (create/view for their tables)
  inventory_manager → inventory + suppliers + purchases
  accountant        → accounting + reports (view)

Customer Layer:
  customer          → catalog (read) + own orders + own profile
  guest             → catalog (read) فقط، لا طلبات

Driver Layer:
  driver            → delivery endpoints خاصة بهم
```

### صلاحيات إضافية مقترحة للتوسع

```python
# يُضاف للـ Permission enum
VIEW_DELIVERY_MAP       # مراقبة المندوبين على الخريطة
MANAGE_DELIVERY_ZONES   # رسم وتعديل مناطق التوصيل
MANAGE_WHATSAPP         # WhatsApp Center
VIEW_WHATSAPP           # قراءة المحادثات
MANAGE_AI_CONFIG        # إعدادات AI Copilot
VIEW_DRIVER_EARNINGS    # تقارير أرباح المندوبين
MANAGE_COMMISSIONS      # العمولات (admin)
```

### تطبيق RBAC في Backend

```python
# نمط الاستخدام في كل endpoint
@router.get("/inventory")
async def get_inventory(
    user: User = Depends(require_permission(Permission.VIEW_INVENTORY)),
    tenant: TenantContext = Depends(get_tenant),
    db: AsyncSession = Depends(get_db),
):
    # tenant.restaurant_id مضمون + Permission محققة
    ...
```

### تطبيق RBAC في Flutter (UI فقط)

```dart
// نمط الاستخدام في كل widget
if (ref.read(currentRoleProvider).can(Permission.manageInventory))
  InventoryManageButton(),

// التنقل — GoRouter redirect
redirect: (context, state) {
  final role = ref.read(currentRoleProvider);
  if (!role.can(requiredPermission)) return '/unauthorized';
  return null;
},
```

---

## 8. نظام الإشعارات

### معمارية الإشعارات

```
Domain Event
(e.g., order status changed)
↓
NotificationService.dispatch(event)
↓
┌─────────────────────────────────────────────┐
│            Notification Resolver            │
│  يحدد: من يستقبل؟ أي قناة؟ أي template?  │
└─────────────────────────────────────────────┘
↓
┌──────────────┬──────────────┬───────────────┐
│ FCM Push     │ WhatsApp     │   In-App      │
│ (Firebase)   │  (Twilio)    │  (DB + WS)    │
└──────────────┴──────────────┴───────────────┘
```

### قوالب الإشعارات

```json
{
  "order.accepted": {
    "push": {
      "ar": { "title": "تم قبول طلبك 🎉", "body": "طلبك #{number} قيد التحضير" },
      "en": { "title": "Order Accepted 🎉", "body": "Your order #{number} is being prepared" }
    },
    "whatsapp": "ar_order_accepted",
    "deep_link": "/orders/{id}"
  }
}
```

### ترتيب أولويات الإشعارات

| الأولوية | النوع | الوصف |
|----------|-------|-------|
| Critical | طلب جديد للمطعم | يصل حتى لو Silent Mode |
| High | تغيير حالة الطلب | Push عادي |
| Normal | عروض وكوبونات | قد يُأخَّر |
| Low | تقارير دورية | In-app فقط |

---

## 9. نظام الخرائط والتتبع

### Customer App — اختيار العنوان

```
1. تحديد موقع تلقائي (GPS)
2. أو: Places Autocomplete بحث
3. أو: سحب Pin على الخريطة (Reverse Geocoding)
4. تأكيد → يُتحقق من: هل العنوان في منطقة توصيل؟
   → إذا نعم: يُعرض رسوم التوصيل + ETA
   → إذا لا: "خارج منطقة التوصيل"
5. حفظ العنوان (max 5 عناوين)
```

### Driver App — الملاحة

```
Driver يقبل الطلب
↓
خريطة تُعرض: موقعه الحالي → المطعم
بعد الاستلام: موقعه → عنوان العميل
↓
Directions API → أفضل مسار
↓
تحديث الموقع كل 5 ثوانٍ → WebSocket
↓
إعادة حساب المسار عند الانحراف (>50m)
```

### Restaurant App — مراقبة المندوبين

```
خريطة تعرض:
- مواقع المندوبين النشطين (pins)
- حالة كل مندوب (متاح / في توصيلة / غير متصل)
- الطلبات النشطة على الخريطة
- مناطق التوصيل (polygons مُلوّنة)
```

### PostGIS Queries الحرجة

```sql
-- هل العنوان في منطقة توصيل؟
SELECT dz.id, dz.delivery_fee, dz.estimated_time
FROM delivery_zones dz
WHERE dz.branch_id = :branch_id
  AND ST_Contains(dz.polygon, ST_SetSRID(ST_Point(:lng, :lat), 4326))
  AND dz.is_active = true
ORDER BY dz.delivery_fee ASC
LIMIT 1;

-- المطاعم القريبة
SELECT r.*, b.id as branch_id,
  ST_Distance(b.location, ST_SetSRID(ST_Point(:lng, :lat), 4326)) as distance
FROM restaurants r
JOIN branches b ON b.restaurant_id = r.id AND b.is_active = true
WHERE ST_DWithin(b.location, ST_SetSRID(ST_Point(:lng, :lat), 4326), :radius_meters)
ORDER BY distance ASC;
```

---

## 10. هيكل المجلدات

### Restaurant App (موجود — يُحافَظ عليه)

```
restaurant-app/lib/
├── app.dart                         ✅
├── main.dart                        ✅
├── core/
│   ├── constants/app_constants.dart ✅
│   ├── errors/failures.dart         ✅
│   ├── network/
│   │   ├── api_client.dart          ✅
│   │   └── token_manager.dart       ✅
│   ├── rbac/
│   │   ├── user_role.dart           ✅
│   │   ├── permissions.dart         ✅
│   │   └── rbac_provider.dart       ✅
│   ├── router/app_router.dart       ✅
│   ├── theme/
│   │   ├── app_colors.dart          ✅
│   │   └── app_theme.dart           ✅
│   └── widgets/
│       ├── app_widgets.dart         ✅
│       ├── main_shell.dart          ✅
│       └── role_nav_config.dart     ✅
├── features/
│   ├── auth/                        ✅ Clean Architecture
│   ├── dashboard/                   ✅
│   ├── copilot/                     ✅
│   ├── branches/                    ✅
│   ├── inventory/ (9 صفحات)         ✅
│   ├── orders/                      ✅
│   ├── kitchen/                     ✅
│   ├── tables/                      ✅
│   ├── reservations/                ✅
│   ├── employees/                   ✅
│   ├── promotions/                  ✅ Clean Architecture كاملة
│   ├── customers/                   ✅
│   ├── reports/                     ✅
│   ├── accounting/                  ✅
│   ├── notifications/               ✅
│   ├── settings/                    ✅
│   ├── ai_assistant/                ✅
│   ├── alerts/                      ✅
│   ├── maps/                        🔜 تُضاف (delivery zones + driver monitoring)
│   └── whatsapp/                    🔜 تُضاف
└── l10n/                            ✅
```

### Customer App (يُبنى)

```
customer-app/lib/
├── main.dart
├── app.dart
├── core/
│   ├── network/api_client.dart      (يُشارك نفس النمط)
│   ├── router/app_router.dart
│   ├── theme/                       (يُشارك design tokens)
│   ├── storage/                     (Hive: cart, favorites, addresses)
│   └── widgets/
├── features/
│   ├── auth/                        (Google Sign-In + Guest)
│   ├── home/                        (Discovery, Banners, Categories)
│   ├── search/                      (Search + Filters)
│   ├── restaurant_detail/           (Info + Menu + Reviews)
│   ├── cart/                        (Cart + Coupons + Checkout)
│   ├── address/                     (Saved Addresses + Map Picker)
│   ├── orders/                      (Active + History + Reorder)
│   ├── tracking/                    (Live Order + Driver Location)
│   ├── chat/                        (Restaurant + Driver Chat)
│   ├── favorites/                   (Saved Restaurants)
│   ├── notifications/
│   └── profile/                     (Settings + Language + Theme)
└── l10n/                            (AR + EN)
```

### Driver App (يُبنى)

```
driver-app/lib/
├── main.dart
├── app.dart
├── core/
│   ├── network/api_client.dart
│   ├── router/app_router.dart
│   ├── location/location_service.dart  (background location)
│   └── theme/
├── features/
│   ├── auth/                        (Google Sign-In + Verification)
│   ├── verification/                (Documents upload)
│   ├── home/                        (Online/Offline + Active Delivery)
│   ├── offers/                      (Incoming offers)
│   ├── navigation/                  (Map + Directions)
│   ├── delivery/                    (Delivery flow + Proof)
│   ├── wallet/                      (Balance + Earnings)
│   ├── history/                     (Delivery history)
│   ├── ratings/                     (My ratings)
│   ├── chat/                        (Customer + Support)
│   ├── notifications/
│   └── settings/
└── l10n/                            (AR + EN)
```

### Admin Dashboard (يُبنى — Flutter Web)

```
admin-dashboard/lib/
├── main.dart
├── app.dart
├── core/
│   ├── network/api_client.dart
│   ├── router/app_router.dart
│   ├── theme/                       (admin-specific dark theme)
│   └── widgets/                     (data tables, charts, side nav)
├── features/
│   ├── auth/                        (Google Sign-In — platform roles only)
│   ├── overview/                    (Platform Dashboard)
│   ├── restaurants/                 (All restaurants + CRUD)
│   ├── subscriptions/               (Plans + Active subscriptions)
│   ├── users/                       (Customers + Drivers)
│   ├── geography/                   (Cities + Delivery zones)
│   ├── finances/                    (Commissions + Payments)
│   ├── promotions/                  (Platform coupons + Ads)
│   ├── support/                     (Complaints + Tickets)
│   ├── analytics/                   (Platform-wide charts)
│   ├── ai_monitoring/               (AI job logs)
│   └── audit/                       (Audit logs)
└── l10n/                            (AR + EN)
```

---

## 11. الشاشات الكاملة

### Restaurant App — الشاشات

| # | الشاشة | الحالة | الأدوار |
|---|--------|--------|---------|
| 1 | Splash | ✅ | All |
| 2 | Login (Google + Demo) | ✅ | — |
| 3 | Unauthorized | ✅ | — |
| 4 | Session Expired | ✅ | — |
| 5 | Dashboard | ✅ | Owner, GM, BM, Supervisor |
| 6 | Restaurant Copilot | ✅ | Owner, GM |
| 7 | AI Assistant | ✅ | Owner, GM, Supervisor |
| 8 | Branches List | ✅ | Owner, GM |
| 9 | Branch Details / Edit | 🔜 | Owner, GM |
| 10 | Products List | ✅ | Owner, GM, BM, Supervisor |
| 11 | Add/Edit Product | 🔜 | Owner, GM |
| 12 | Categories | 🔜 | Owner, GM |
| 13 | Add-on Groups | 🔜 | Owner, GM |
| 14 | Inventory Items | ✅ | Owner, GM, InventoryMgr |
| 15 | Recipes | ✅ | Owner, GM, InventoryMgr |
| 16 | Suppliers | ✅ | Owner, GM, InventoryMgr |
| 17 | Purchases | ✅ | Owner, GM, InventoryMgr |
| 18 | Stock Count | ✅ | Owner, GM, InventoryMgr |
| 19 | Waste Log | ✅ | Owner, GM, InventoryMgr |
| 20 | Expiry Tracking | ✅ | Owner, GM, InventoryMgr |
| 21 | Transfers | ✅ | Owner, GM, InventoryMgr |
| 22 | Orders List | ✅ | Owner, GM, BM, Cashier, Waiter |
| 23 | Order Details | 🔜 | Owner, GM, BM, Cashier |
| 24 | Kitchen Display (KDS) | ✅ | Kitchen, Supervisor |
| 25 | Tables Map | 🔜 | Owner, GM, Waiter |
| 26 | Reservations | ✅ | Owner, GM, Waiter |
| 27 | Employees List | ✅ | Owner, GM |
| 28 | Attendance | 🔜 | Owner, GM, Supervisor |
| 29 | Schedule | 🔜 | Owner, GM |
| 30 | Payroll | 🔜 | Owner, Accountant |
| 31 | Customers CRM | ✅ | Owner, GM |
| 32 | Promotions (Offers + Coupons) | ✅ | Owner, GM |
| 33 | Create Offer | ✅ | Owner, GM |
| 34 | Create Coupon | ✅ | Owner, GM |
| 35 | Reports | ✅ | Owner, GM, Accountant |
| 36 | Analytics Charts | 🔜 | Owner, GM |
| 37 | Accounting | ✅ | Owner, Accountant |
| 38 | Notifications | ✅ | All |
| 39 | WhatsApp Center | 🔜 | Owner, GM |
| 40 | Delivery Zone Map | 🔜 | Owner, GM |
| 41 | Driver Monitoring Map | 🔜 | Owner, GM, BM |
| 42 | Settings | ✅ | Owner, GM |
| 43 | Profile | ✅ | All |
| 44 | Activity Log | ✅ | Owner, GM |
| 45 | Alerts | ✅ | All |

### Customer App — الشاشات

| # | الشاشة | الوصف |
|---|--------|-------|
| 1 | Splash | شاشة البداية |
| 2 | Onboarding | 3 شرائح تعريفية (مرة واحدة) |
| 3 | Login | Google Sign-In + "تصفح كضيف" |
| 4 | Home | Banners + Categories + Near Me + Best Sellers + Open Now |
| 5 | Search | بحث نصي + تصفية (cuisine, rating, delivery time, price) |
| 6 | Category Results | مطاعم حسب التصنيف |
| 7 | Restaurant Detail | صورة + معلومات + وقت + تقييمات |
| 8 | Menu | فئات المنيو + البحث |
| 9 | Product Detail | صورة + وصف + خيارات/إضافات + "أضف للسلة" |
| 10 | Cart | عناصر السلة + كوبون + ملخص السعر |
| 11 | Address List | عناوين محفوظة + "إضافة عنوان جديد" |
| 12 | Map Address Picker | خريطة مع Pin سحب + Autocomplete |
| 13 | Delivery Zone Check | هل منطقتي مشمولة؟ + الرسوم |
| 14 | Checkout | ملخص + اختيار الدفع + تأكيد |
| 15 | Order Placed | تأكيد + رقم الطلب |
| 16 | Order Tracking | Timeline حالة الطلب + خريطة المندوب |
| 17 | Driver Location Map | موقع المندوب live + ETA |
| 18 | Delivery Proof | صورة الإيصال بعد التسليم |
| 19 | Order Completed | تقييم + إعادة طلب |
| 20 | Rate Order | تقييم المطعم + المندوب |
| 21 | Chat - Restaurant | محادثة مع المطعم |
| 22 | Chat - Driver | محادثة مع المندوب |
| 23 | Order History | قائمة بجميع الطلبات |
| 24 | Order Detail (past) | تفاصيل طلب سابق + فاتورة |
| 25 | Favorites | المطاعم المفضلة |
| 26 | Notifications | مركز الإشعارات |
| 27 | Profile | الصورة + الاسم + الهاتف |
| 28 | Settings | اللغة + الوضع الليلي + الإشعارات |

### Driver App — الشاشات

| # | الشاشة | الوصف |
|---|--------|-------|
| 1 | Splash | |
| 2 | Login | Google Sign-In |
| 3 | Verification | بانتظار موافقة الـ Admin |
| 4 | Documents Upload | رخصة القيادة + الهوية + صورة السيارة |
| 5 | Home | Online/Offline toggle + إحصائيات اليوم |
| 6 | Incoming Offer | بطاقة عرض التوصيلة + قبول/رفض (timeout 30s) |
| 7 | Active Delivery | خريطة + تفاصيل الطلب + الحالة |
| 8 | Navigate to Restaurant | خريطة Directions → المطعم |
| 9 | Pickup Confirmation | تأكيد استلام الطلب من المطعم |
| 10 | Navigate to Customer | خريطة Directions → العميل |
| 11 | Delivery Proof | التقاط صورة + توقيع العميل |
| 12 | Delivery Complete | تأكيد التسليم + الأرباح |
| 13 | Wallet | الرصيد + المعاملات |
| 14 | Earnings | أرباح اليوم/الأسبوع/الشهر |
| 15 | History | سجل التوصيلات |
| 16 | Ratings | تقييماتي من العملاء |
| 17 | Chat | محادثة مع العميل |
| 18 | Support | تذاكر الدعم الفني |
| 19 | Settings | الإشعارات + اللغة + الحساب |
| 20 | Notifications | |

### Admin Dashboard — الشاشات

| # | الشاشة | الوصف |
|---|--------|-------|
| 1 | Login | Google Sign-In (platform roles فقط) |
| 2 | Overview Dashboard | KPIs: مطاعم، طلبات، GMV، مستخدمين |
| 3 | Restaurants List | جدول + بحث + فلاتر + تفعيل/إيقاف |
| 4 | Restaurant Detail | بيانات + اشتراك + إحصائيات + مندوبو المطعم |
| 5 | Add Restaurant | wizard تعريفي |
| 6 | Subscriptions | قائمة الاشتراكات + تجديد + إلغاء |
| 7 | Plans Manager | إنشاء/تعديل الخطط |
| 8 | Customers List | جدول + بيانات + حظر |
| 9 | Drivers List | جدول + توثيق + تفعيل |
| 10 | Driver Detail | مستندات + تقييمات + أرباح |
| 11 | Cities | إدارة المدن |
| 12 | Delivery Zones | خريطة + رسم zones + الرسوم |
| 13 | Commissions | نسب العمولات لكل مطعم |
| 14 | Payments | سجل المدفوعات + payouts للمندوبين |
| 15 | Platform Coupons | كوبونات للمنصة (not restaurant-specific) |
| 16 | Advertising | بانرات الصفحة الرئيسية |
| 17 | Complaints | تذاكر الشكاوى + assign + resolve |
| 18 | Support Center | محادثات الدعم |
| 19 | Analytics | charts: مبيعات، نمو، خريطة حرارة |
| 20 | AI Jobs Monitor | لوج مهام الـ AI + تكاليف |
| 21 | Audit Logs | سجل كل العمليات الحساسة |
| 22 | Settings | إعدادات المنصة |

---

## 12. UX Flow

### 12.1 Restaurant Owner — Daily Workflow

```
صباحاً:
  تسجيل الدخول → Dashboard
  ↓
  AI Alerts: "مخزون الدجاج منخفض، تحتاج شراء"
  ↓
  Copilot: "أمس أعلى مبيعاتك كانت البرغر — اليوم طقسه حار، قلل المشويات"
  ↓
  Kitchen: افتح KDS للطاخين

أثناء الدوام:
  Orders → real-time stream
  ↓
  Kitchen Display → يحدّث تلقائياً
  ↓
  إشعار: "مندوب تأخر أكثر من 20 دقيقة"
  ↓
  Map: موقع المندوب

مساءً:
  Reports → ملخص اليوم
  ↓
  Inventory → تحديث المخزون
  ↓
  WhatsApp Center → متابعة رسائل العملاء
```

### 12.2 Customer — First Order Flow

```
فتح التطبيق (Guest)
↓
Home: يرى المطاعم القريبة
↓
اختار مطعم → Menu
↓
أضاف منتجات للسلة
↓
ضغط "إتمام الطلب"
↓
[تسجيل الدخول مطلوب] → Google Sign-In (10 ثوانٍ)
↓
اختار/أدخل العنوان
↓
[تحقق من منطقة التوصيل] → رسوم التوصيل = 15 ريال، ETA = 35 دقيقة
↓
اختار طريقة الدفع
↓
تأكيد الطلب
↓
[Tracking Screen] → Timeline + خريطة
↓
إشعار: "طلبك في الطريق" → Driver Map
↓
"تم التسليم" → شاشة التقييم
```

### 12.3 Driver — Delivery Flow

```
فتح التطبيق
↓
رفع الحالة: Online
↓
[Offer ينبثق]: مطعم X → حي Y — 8.5 كم — 18 ريال
↓
قبول (30 ثانية قبل انتهاء المهلة)
↓
Navigate to Restaurant (Directions)
↓
وصل للمطعم → "استلمت الطلب"
↓
Navigate to Customer (Directions + Live sharing)
↓
وصل → صورة إثبات التسليم + توقيع (إذا مطلوب)
↓
"تم التسليم"
↓
الأرباح: +18 ريال → Wallet
```

### 12.4 Kitchen Staff — KDS Flow

```
تسجيل الدخول (kitchen role)
↓
KDS Screen (fullscreen, no navbar)
↓
طلب جديد ينبثق (صوت + اهتزاز)
↓
بطاقة الطلب: العناصر + الوقت المستغرق + الوقت المتوقع
↓
يبدأ بالتحضير → "بدأت"
↓
انتهى → "جاهز"
↓
[إشعار للكاشير] "الطلب #123 جاهز"
```

### 12.5 Platform Admin — Onboarding Restaurant Flow

```
Login (platform_admin role)
↓
Restaurants → Add New
↓
wizard:
  1. بيانات المطعم (الاسم، الشعار، التصنيف)
  2. بيانات المالك (اسم، بريد، رقم)
  3. اختيار الخطة + طريقة الدفع
  4. إنشاء owner user + restaurant record
↓
إشعار للمالك: "تم تفعيل حسابك في [المنصة]"
↓
Owner يسجل دخول → يكمل إعداد الفروع + المنيو
```

---

## 13. التحسينات التنافسية

### ما تقدمه Talabat / Jahez / Uber Eats وكيف نتفوق

| الميزة | المنافسون | نحن |
|--------|-----------|-----|
| تتبع الطلب | خريطة بسيطة | خريطة live + ETA ديناميكي + تحديث كل 5 ثوانٍ + تقدير الوصول بـ traffic |
| إدارة المطعم | تطبيق منفصل بسيط | منصة متكاملة: Copilot AI + KDS + مخزون + موظفين + محاسبة |
| AI | غير موجود | Restaurant Copilot: تنبيهات ذكية + توصيات المنيو + تحليل الهدر |
| المندوب | تطبيق أساسي | live navigation + إثبات تسليم + محفظة + تقييمات تفصيلية |
| المحادثة | نادراً | real-time chat: عميل↔مطعم، عميل↔مندوب |
| الكوبونات | أحادية البُعد | multi-type: platform + restaurant + per-user + time-based |
| اللغة | إنجليزي أساسي | عربي أولاً — كامل الدعم AR + EN |
| Offline | لا | Restaurant App: Offline-first (Hive + sync queue) |
| إدارة المخزون | غير موجودة | وصفات + تكلفة الطبق + موردون + انتهاء الصلاحية + هدر |
| تعدد الفروع | محدود | multi-branch كامل: صلاحيات فرعية + نقل مخزون بين الفروع |
| Admin Platform | عقود إدارية | لوحة تحكم ذاتية: اشتراكات + كوبونات + إعلانات + تحليلات |
| WhatsApp | غير موجود | WhatsApp Center مدمج (Twilio): تواصل فعّال مع العملاء |
| Zones رسم | ثابت | رسم تفاعلي على الخريطة + رسوم مخصصة لكل منطقة |
| المطبخ | لا KDS | شاشة مطبخ مستقلة + إدارة الأولويات |

### ميزات فريدة مقترحة (لا يقدمها أحد)

1. **Restaurant Copilot** — يحلل الطلبات التاريخية ويقترح: ماذا تطبخ اليوم؟ ما المنتجات التي يجب إيقافها؟ متى ذروة الطلبات؟
2. **Dish Cost Intelligence** — يحسب تلقائياً هامش الربح لكل طبق بناءً على أسعار الموردين الحالية
3. **Smart Waste Alerts** — يُنبّه قبل 24 ساعة من انتهاء الصلاحية مع اقتراح عروض لبيع المخزون
4. **Attendance Geofencing** — تسجيل حضور الموظفين تلقائياً عند الدخول لنطاق الفرع (GPS)
5. **Multi-Branch Inventory Transfer** — طلب نقل مخزون من فرع لآخر مع الموافقة والتتبع
6. **Driver Performance Analytics** — تحليل أداء المندوبين: سرعة التسليم، تقييمات، أرباح، مسارات متكررة
7. **Customer Reorder Flow** — "اطلب نفس طلبك من الأسبوع الماضي بنقرة واحدة"

---

## ملاحظات التنفيذ

### ترتيب الأولويات (مقترح)

**المرحلة 1 — الأساس (الأن):**
1. تشغيل Restaurant App في Replit (يحتاج pubspec get + flutter build)
2. تشغيل Backend (يحتاج PostgreSQL + Redis secrets)
3. ربط Restaurant App بالـ Backend (Google Sign-In حقيقي)

**المرحلة 2 — Customer App:**
4. بناء Customer App من placeholder الموجود
5. Discovery + Menu + Cart + Checkout
6. Live Order Tracking

**المرحلة 3 — Driver App:**
7. بناء Driver App من placeholder الموجود
8. Accept/Reject + Navigation + Proof of Delivery

**المرحلة 4 — Admin Dashboard:**
9. بناء Admin Dashboard لإدارة المنصة
10. Subscriptions + Analytics

**المرحلة 5 — Advanced Features:**
11. WhatsApp Center (Twilio)
12. AI Copilot الكامل
13. Maps الكاملة (Zones رسم + Driver monitoring)

### Secrets المطلوبة

| Secret | الاستخدام |
|--------|-----------|
| `GOOGLE_CLIENT_ID` | Google Sign-In في كل التطبيقات |
| `DATABASE_URL` | PostgreSQL connection string |
| `REDIS_URL` | Redis connection |
| `SECRET_KEY` | JWT signing |
| `FIREBASE_CREDENTIALS_PATH` | FCM notifications |
| `AWS_ACCESS_KEY_ID` + `AWS_SECRET_ACCESS_KEY` | S3 file uploads |
| `GOOGLE_MAPS_API_KEY` | Maps + Directions + Places |
| `TWILIO_*` | WhatsApp Center |

### No-Breaking-Changes Policy

- كل endpoint جديد يُضاف، لا يُعدَّل الموجود
- `restaurant-app/` يبقى كما هو — أي ميزة جديدة تُضاف بملفات جديدة
- الـ DB migrations تستخدم `ALTER TABLE ADD COLUMN` فقط — لا تعديل على الأعمدة الموجودة
- Version bump (`/api/v2/`) عند أي breaking change مستقبلي
