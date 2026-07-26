from enum import Enum
from typing import Set, Dict


class UserRole(str, Enum):
    # Platform
    PLATFORM_OWNER = "platform_owner"
    PLATFORM_ADMIN = "platform_admin"
    SUPPORT = "support"
    FINANCE = "finance"
    # Restaurant
    RESTAURANT_OWNER = "restaurant_owner"
    GENERAL_MANAGER = "general_manager"
    BRANCH_MANAGER = "branch_manager"
    SUPERVISOR = "supervisor"
    CASHIER = "cashier"
    KITCHEN = "kitchen"
    WAITER = "waiter"
    INVENTORY_MANAGER = "inventory_manager"
    ACCOUNTANT = "accountant"
    # Customer
    CUSTOMER = "customer"
    GUEST = "guest"
    # Driver
    DRIVER = "driver"


class Permission(str, Enum):
    # Dashboard
    VIEW_DASHBOARD = "view_dashboard"
    VIEW_ANALYTICS = "view_analytics"
    # Menu
    VIEW_MENU = "view_menu"
    MANAGE_MENU = "manage_menu"
    # Orders
    VIEW_ORDERS = "view_orders"
    MANAGE_ORDERS = "manage_orders"
    CREATE_ORDERS = "create_orders"
    # Kitchen
    VIEW_KITCHEN = "view_kitchen"
    MANAGE_KITCHEN = "manage_kitchen"
    # Inventory
    VIEW_INVENTORY = "view_inventory"
    MANAGE_INVENTORY = "manage_inventory"
    VIEW_SUPPLIERS = "view_suppliers"
    MANAGE_SUPPLIERS = "manage_suppliers"
    VIEW_PURCHASES = "view_purchases"
    MANAGE_PURCHASES = "manage_purchases"
    # Employees
    VIEW_EMPLOYEES = "view_employees"
    MANAGE_EMPLOYEES = "manage_employees"
    MANAGE_PAYROLL = "manage_payroll"
    # Financial
    VIEW_ACCOUNTING = "view_accounting"
    MANAGE_ACCOUNTING = "manage_accounting"
    VIEW_REPORTS = "view_reports"
    # Customers
    VIEW_CUSTOMERS = "view_customers"
    # Settings
    MANAGE_SETTINGS = "manage_settings"
    MANAGE_BRANCHES = "manage_branches"
    VIEW_AUDIT_LOGS = "view_audit_logs"
    # AI
    USE_AI_COPILOT = "use_ai_copilot"
    # Platform Admin
    MANAGE_PLATFORM = "manage_platform"
    MANAGE_SUBSCRIPTIONS = "manage_subscriptions"


ROLE_PERMISSIONS: Dict[UserRole, Set[Permission]] = {
    UserRole.PLATFORM_OWNER: set(Permission),
    UserRole.PLATFORM_ADMIN: {
        Permission.MANAGE_PLATFORM, Permission.VIEW_ANALYTICS,
        Permission.VIEW_REPORTS, Permission.MANAGE_SUBSCRIPTIONS,
    },
    UserRole.RESTAURANT_OWNER: {
        Permission.VIEW_DASHBOARD, Permission.VIEW_ANALYTICS,
        Permission.VIEW_MENU, Permission.MANAGE_MENU,
        Permission.VIEW_ORDERS, Permission.MANAGE_ORDERS, Permission.CREATE_ORDERS,
        Permission.VIEW_KITCHEN, Permission.MANAGE_KITCHEN,
        Permission.VIEW_INVENTORY, Permission.MANAGE_INVENTORY,
        Permission.VIEW_SUPPLIERS, Permission.MANAGE_SUPPLIERS,
        Permission.VIEW_PURCHASES, Permission.MANAGE_PURCHASES,
        Permission.VIEW_EMPLOYEES, Permission.MANAGE_EMPLOYEES, Permission.MANAGE_PAYROLL,
        Permission.VIEW_ACCOUNTING, Permission.MANAGE_ACCOUNTING,
        Permission.VIEW_REPORTS, Permission.VIEW_CUSTOMERS,
        Permission.MANAGE_SETTINGS, Permission.MANAGE_BRANCHES,
        Permission.VIEW_AUDIT_LOGS, Permission.USE_AI_COPILOT,
    },
    UserRole.GENERAL_MANAGER: {
        Permission.VIEW_DASHBOARD, Permission.VIEW_ANALYTICS,
        Permission.VIEW_MENU, Permission.MANAGE_MENU,
        Permission.VIEW_ORDERS, Permission.MANAGE_ORDERS, Permission.CREATE_ORDERS,
        Permission.VIEW_KITCHEN, Permission.MANAGE_KITCHEN,
        Permission.VIEW_INVENTORY, Permission.MANAGE_INVENTORY,
        Permission.VIEW_SUPPLIERS, Permission.MANAGE_SUPPLIERS,
        Permission.VIEW_PURCHASES, Permission.MANAGE_PURCHASES,
        Permission.VIEW_EMPLOYEES, Permission.MANAGE_EMPLOYEES,
        Permission.VIEW_ACCOUNTING, Permission.VIEW_REPORTS,
        Permission.VIEW_CUSTOMERS, Permission.USE_AI_COPILOT,
    },
    UserRole.INVENTORY_MANAGER: {
        Permission.VIEW_INVENTORY, Permission.MANAGE_INVENTORY,
        Permission.VIEW_SUPPLIERS, Permission.MANAGE_SUPPLIERS,
        Permission.VIEW_PURCHASES, Permission.MANAGE_PURCHASES,
    },
    UserRole.KITCHEN: {
        Permission.VIEW_KITCHEN, Permission.MANAGE_KITCHEN,
        Permission.VIEW_ORDERS,
    },
    UserRole.CASHIER: {
        Permission.VIEW_ORDERS, Permission.MANAGE_ORDERS, Permission.CREATE_ORDERS,
        Permission.VIEW_ACCOUNTING,
    },
    UserRole.CUSTOMER: set(),
    UserRole.DRIVER: set(),
}


def has_permission(role: UserRole, permission: Permission) -> bool:
    return permission in ROLE_PERMISSIONS.get(role, set())
