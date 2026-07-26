from typing import Final

APPS: Final = ("restaurant", "customer", "driver", "admin")

ROLE_FEATURES: Final[dict[str, dict[str, list[str]]]] = {
    "restaurant": {
        "owner": [
            "dashboard", "copilot", "branches", "catalog", "inventory",
            "recipes", "suppliers", "purchases", "stock_count", "waste",
            "expiry", "transfers", "orders", "kitchen", "tables",
            "reservations", "employees", "attendance", "scheduling",
            "payroll", "customers", "promotions", "coupons", "reports",
            "analytics", "settings", "notifications", "whatsapp", "ai_assistant",
        ],
        "general_manager": [
            "dashboard", "branches", "catalog", "inventory", "orders",
            "kitchen", "reservations", "employees", "customers", "reports",
            "analytics", "notifications", "settings",
        ],
        "branch_manager": [
            "dashboard", "catalog", "inventory", "orders", "kitchen",
            "tables", "reservations", "employees", "customers", "reports",
            "notifications", "settings",
        ],
        "supervisor": [
            "dashboard", "orders", "kitchen", "tables", "reservations",
            "inventory", "employees", "customers", "notifications",
        ],
        "cashier": ["dashboard", "pos", "orders", "refunds", "customers", "notifications"],
        "kitchen": ["orders", "kitchen", "inventory", "alerts", "notifications"],
        "waiter": ["tables", "orders", "reservations", "customers", "notifications"],
        "inventory_manager": [
            "inventory", "recipes", "suppliers", "purchases", "stock_count",
            "waste", "expiry", "transfers", "notifications",
        ],
        "accountant": [
            "accounting", "expenses", "invoices", "payments", "profit",
            "reports", "notifications", "settings",
        ],
    },
    "customer": {
        "customer": [
            "home", "restaurant_discovery", "search", "categories", "filters",
            "nearby_restaurants", "offers", "bestsellers", "restaurant_menu",
            "favorites", "cart", "coupons", "addresses", "maps", "checkout",
            "live_order_tracking", "driver_location", "notifications", "chat",
            "reviews", "reorder", "order_history", "profile", "language", "theme",
        ],
        "guest": [
            "home", "restaurant_discovery", "search", "categories", "filters",
            "nearby_restaurants", "restaurant_menu", "cart", "addresses",
            "maps", "checkout", "profile",
        ],
    },
    "driver": {
        "driver": [
            "google_sign_in", "identity_verification", "documents", "availability",
            "delivery_offers", "delivery_acceptance", "restaurant_navigation",
            "customer_navigation", "live_map", "location_sharing", "proof_of_delivery",
            "order_photo", "signature", "cash_on_delivery", "wallet", "earnings",
            "delivery_history", "ratings", "support", "settings",
        ],
    },
    "admin": {
        "platform_owner": [
            "restaurants", "subscriptions", "plans", "customers", "drivers",
            "cities", "delivery_zones", "commissions", "payments", "coupons",
            "advertising", "complaints", "support", "analytics", "ai_monitoring",
            "audit_logs",
        ],
        "platform_admin": [
            "restaurants", "customers", "drivers", "cities", "delivery_zones",
            "coupons", "complaints", "support", "analytics", "audit_logs",
        ],
        "support": ["restaurants", "customers", "drivers", "complaints", "support", "audit_logs"],
        "finance": ["subscriptions", "plans", "commissions", "payments", "analytics", "audit_logs"],
    },
}


def features_for(app: str, role: str) -> list[str]:
    return ROLE_FEATURES.get(app, {}).get(role, [])