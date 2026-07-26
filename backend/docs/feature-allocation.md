# Feature allocation

The platform has four independently deployable products and one shared API. A
feature belongs to the product that owns the workflow; shared capabilities are
exposed by the backend rather than copied into every app.

## Restaurant App

**Audience:** Owner, General Manager, Branch Manager, Supervisor, Kitchen,
Cashier, Waiter, Inventory Manager, Accountant.

Dashboard, Restaurant Copilot, branches, product catalog, categories,
add-ons/options, customer visibility, availability, inventory, recipes, dish
cost, suppliers, purchases, stock count, waste, expiry, transfers, orders,
kitchen display, tables, reservations, employees, attendance, scheduling,
payroll, customer records, promotions, coupons, reports, analytics, settings,
notifications, WhatsApp Center, and AI Assistant.

The existing Flutter app remains the source of truth for this scope. Routes that
are not yet implemented remain explicitly marked in its router rather than
being silently removed.

## Customer App

**Audience:** Customer and Guest.

Discovery, search, categories, filters, nearby restaurants, offers,
bestsellers, restaurant details and menu, favorites, cart, coupons, saved
addresses, map selection, delivery zone/fee preview, checkout, live order
tracking, driver location and ETA, notifications, restaurant/driver chat,
ratings, reorder, order history, profile, language, and theme.

Guests can browse and build a cart; sign-in is required at checkout and uses
Google Sign-In only.

## Driver App

**Audience:** Driver.

Google Sign-In, identity verification, documents, online/offline status,
delivery offers, accept/reject, restaurant and customer navigation, live maps,
location sharing, proof of delivery, photo, signature, cash on delivery,
wallet, earnings, history, ratings, support, and settings.

## Admin Dashboard

**Audience:** Platform Owner, Platform Admin, Support, Finance.

All restaurants, subscriptions, plans, customers, drivers, cities, delivery
zones, commissions, payments, coupons, advertising, complaints, support,
analytics, AI monitoring, and audit logs.

## Shared capabilities

The backend owns authentication and role claims, tenant/branch isolation,
orders, notifications, maps/ETA, payments, chat, reviews, AI jobs, and audit
events. The same resource IDs are used across all apps so an order created by
the Customer App can be prepared in the Restaurant App, assigned in the Admin
Dashboard, and delivered in the Driver App.