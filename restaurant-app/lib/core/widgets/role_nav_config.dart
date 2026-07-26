import 'package:flutter/material.dart';
import '../rbac/user_role.dart';
import '../router/app_router.dart';

class NavItem {
  final String labelKey;  // ARB key for label
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const NavItem({
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

class NavGroup {
  final String? groupLabel;
  final List<NavItem> items;
  const NavGroup({this.groupLabel, required this.items});
}

const Map<UserRole, List<NavGroup>> roleNavConfig = {
  UserRole.owner: [
    NavGroup(items: [
      NavItem(labelKey: 'navDashboard',   icon: Icons.dashboard_outlined,     activeIcon: Icons.dashboard,          route: AppRoutes.dashboard),
      NavItem(labelKey: 'navCopilot',     icon: Icons.auto_awesome_outlined,   activeIcon: Icons.auto_awesome,       route: AppRoutes.copilot),
      NavItem(labelKey: 'navBranches',    icon: Icons.store_outlined,          activeIcon: Icons.store,              route: AppRoutes.branches),
    ]),
    NavGroup(groupLabel: 'Operations', items: [
      NavItem(labelKey: 'navOrders',      icon: Icons.receipt_long_outlined,   activeIcon: Icons.receipt_long,       route: AppRoutes.orders),
      NavItem(labelKey: 'navReservations',icon: Icons.event_seat_outlined,     activeIcon: Icons.event_seat,         route: AppRoutes.reservations),
      NavItem(labelKey: 'navCustomers',   icon: Icons.people_outline,          activeIcon: Icons.people,             route: AppRoutes.customers),
      NavItem(labelKey: 'navEmployees',   icon: Icons.badge_outlined,          activeIcon: Icons.badge,              route: AppRoutes.employees),
    ]),
    NavGroup(groupLabel: 'Inventory', items: [
      NavItem(labelKey: 'navInventory',   icon: Icons.inventory_2_outlined,    activeIcon: Icons.inventory_2,        route: AppRoutes.inventory),
      NavItem(labelKey: 'navSuppliers',   icon: Icons.local_shipping_outlined, activeIcon: Icons.local_shipping,     route: AppRoutes.suppliers),
      NavItem(labelKey: 'navPurchases',   icon: Icons.shopping_cart_outlined,  activeIcon: Icons.shopping_cart,      route: AppRoutes.purchases),
    ]),
    NavGroup(groupLabel: 'Finance', items: [
      NavItem(labelKey: 'navAccounting',  icon: Icons.account_balance_outlined,activeIcon: Icons.account_balance,    route: AppRoutes.accounting),
      NavItem(labelKey: 'navReports',     icon: Icons.bar_chart_outlined,      activeIcon: Icons.bar_chart,          route: AppRoutes.reports),
      NavItem(labelKey: 'navAnalytics',   icon: Icons.analytics_outlined,      activeIcon: Icons.analytics,          route: AppRoutes.analytics),
    ]),
    NavGroup(groupLabel: 'System', items: [
      NavItem(labelKey: 'navAiAssistant', icon: Icons.smart_toy_outlined,      activeIcon: Icons.smart_toy,          route: AppRoutes.aiAssistant),
      NavItem(labelKey: 'navAlerts',      icon: Icons.notifications_outlined,  activeIcon: Icons.notifications,      route: AppRoutes.alerts),
      NavItem(labelKey: 'navAuditLogs',   icon: Icons.history_outlined,        activeIcon: Icons.history,            route: AppRoutes.auditLogs),
      NavItem(labelKey: 'navSettings',    icon: Icons.settings_outlined,       activeIcon: Icons.settings,           route: AppRoutes.settings),
    ]),
  ],

  UserRole.generalManager: [
    NavGroup(items: [
      NavItem(labelKey: 'navDashboard',     icon: Icons.dashboard_outlined,    activeIcon: Icons.dashboard,          route: AppRoutes.dashboard),
      NavItem(labelKey: 'navTodaysTasks',   icon: Icons.task_alt_outlined,     activeIcon: Icons.task_alt,           route: AppRoutes.todaysTasks),
    ]),
    NavGroup(groupLabel: 'Operations', items: [
      NavItem(labelKey: 'navBranches',      icon: Icons.store_outlined,        activeIcon: Icons.store,              route: AppRoutes.branches),
      NavItem(labelKey: 'navEmployees',     icon: Icons.badge_outlined,        activeIcon: Icons.badge,              route: AppRoutes.employees),
      NavItem(labelKey: 'navOrders',        icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long,       route: AppRoutes.orders),
      NavItem(labelKey: 'navReservations',  icon: Icons.event_seat_outlined,   activeIcon: Icons.event_seat,         route: AppRoutes.reservations),
      NavItem(labelKey: 'navCustomers',     icon: Icons.people_outline,        activeIcon: Icons.people,             route: AppRoutes.customers),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navInventory',     icon: Icons.inventory_2_outlined,  activeIcon: Icons.inventory_2,        route: AppRoutes.inventory),
      NavItem(labelKey: 'navReports',       icon: Icons.bar_chart_outlined,    activeIcon: Icons.bar_chart,          route: AppRoutes.reports),
      NavItem(labelKey: 'navAiAssistant',   icon: Icons.smart_toy_outlined,    activeIcon: Icons.smart_toy,          route: AppRoutes.aiAssistant),
      NavItem(labelKey: 'navSettings',      icon: Icons.settings_outlined,     activeIcon: Icons.settings,           route: AppRoutes.settings),
    ]),
  ],

  UserRole.branchManager: [
    NavGroup(items: [
      NavItem(labelKey: 'navDashboard',    icon: Icons.dashboard_outlined,    activeIcon: Icons.dashboard,    route: AppRoutes.dashboard),
      NavItem(labelKey: 'navTodaysTasks',  icon: Icons.task_alt_outlined,     activeIcon: Icons.task_alt,     route: AppRoutes.todaysTasks),
    ]),
    NavGroup(groupLabel: 'Operations', items: [
      NavItem(labelKey: 'navOrders',       icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, route: AppRoutes.orders),
      NavItem(labelKey: 'navKitchen',      icon: Icons.soup_kitchen_outlined, activeIcon: Icons.soup_kitchen,  route: AppRoutes.kitchen),
      NavItem(labelKey: 'navEmployees',    icon: Icons.badge_outlined,        activeIcon: Icons.badge,        route: AppRoutes.employees),
      NavItem(labelKey: 'navCustomers',    icon: Icons.people_outline,        activeIcon: Icons.people,       route: AppRoutes.customers),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navInventory',    icon: Icons.inventory_2_outlined,  activeIcon: Icons.inventory_2,  route: AppRoutes.inventory),
      NavItem(labelKey: 'navReports',      icon: Icons.bar_chart_outlined,    activeIcon: Icons.bar_chart,    route: AppRoutes.reports),
      NavItem(labelKey: 'navSettings',     icon: Icons.settings_outlined,     activeIcon: Icons.settings,     route: AppRoutes.settings),
    ]),
  ],

  UserRole.supervisor: [
    NavGroup(items: [
      NavItem(labelKey: 'navTodaysTasks',    icon: Icons.task_alt_outlined,      activeIcon: Icons.task_alt,      route: AppRoutes.todaysTasks),
    ]),
    NavGroup(groupLabel: 'Team', items: [
      NavItem(labelKey: 'navEmployees',      icon: Icons.badge_outlined,         activeIcon: Icons.badge,         route: AppRoutes.employees),
      NavItem(labelKey: 'navAttendance',     icon: Icons.checklist_outlined,     activeIcon: Icons.checklist,     route: AppRoutes.attendance),
      NavItem(labelKey: 'navOrders',         icon: Icons.receipt_long_outlined,  activeIcon: Icons.receipt_long,  route: AppRoutes.orders),
      NavItem(labelKey: 'navInventoryAlerts',icon: Icons.warning_amber_outlined, activeIcon: Icons.warning_amber, route: AppRoutes.alerts),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navSettings',       icon: Icons.settings_outlined,      activeIcon: Icons.settings,      route: AppRoutes.settings),
    ]),
  ],

  UserRole.kitchen: [
    NavGroup(items: [
      NavItem(labelKey: 'navKitchenOrders',  icon: Icons.soup_kitchen_outlined,  activeIcon: Icons.soup_kitchen,  route: AppRoutes.kitchen),
      NavItem(labelKey: 'navInventoryAlerts',icon: Icons.warning_amber_outlined,  activeIcon: Icons.warning_amber, route: AppRoutes.alerts),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navSettings',       icon: Icons.settings_outlined,      activeIcon: Icons.settings,      route: AppRoutes.settings),
    ]),
  ],

  UserRole.cashier: [
    NavGroup(items: [
      NavItem(labelKey: 'navPos',       icon: Icons.point_of_sale_outlined, activeIcon: Icons.point_of_sale, route: AppRoutes.pos),
      NavItem(labelKey: 'navOrders',    icon: Icons.receipt_long_outlined,  activeIcon: Icons.receipt_long,  route: AppRoutes.orders),
      NavItem(labelKey: 'navRefunds',   icon: Icons.assignment_return_outlined, activeIcon: Icons.assignment_return, route: AppRoutes.refunds),
      NavItem(labelKey: 'navCustomers', icon: Icons.people_outline,         activeIcon: Icons.people,        route: AppRoutes.customers),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navSettings',  icon: Icons.settings_outlined,      activeIcon: Icons.settings,      route: AppRoutes.settings),
    ]),
  ],

  UserRole.inventoryManager: [
    NavGroup(items: [
      NavItem(labelKey: 'navInventory',  icon: Icons.inventory_2_outlined,    activeIcon: Icons.inventory_2,  route: AppRoutes.inventory),
    ]),
    NavGroup(groupLabel: 'Procurement', items: [
      NavItem(labelKey: 'navSuppliers',  icon: Icons.local_shipping_outlined, activeIcon: Icons.local_shipping, route: AppRoutes.suppliers),
      NavItem(labelKey: 'navPurchases',  icon: Icons.shopping_cart_outlined,  activeIcon: Icons.shopping_cart,  route: AppRoutes.purchases),
      NavItem(labelKey: 'navTransfers',  icon: Icons.swap_horiz_outlined,     activeIcon: Icons.swap_horiz,     route: AppRoutes.transfers),
    ]),
    NavGroup(groupLabel: 'Tracking', items: [
      NavItem(labelKey: 'navWaste',      icon: Icons.delete_outline,          activeIcon: Icons.delete,         route: AppRoutes.waste),
      NavItem(labelKey: 'navExpiry',     icon: Icons.event_busy_outlined,     activeIcon: Icons.event_busy,     route: AppRoutes.expiry),
      NavItem(labelKey: 'navStockCount', icon: Icons.playlist_add_check_outlined, activeIcon: Icons.playlist_add_check, route: AppRoutes.stockCount),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navSettings',   icon: Icons.settings_outlined,       activeIcon: Icons.settings,       route: AppRoutes.settings),
    ]),
  ],

  UserRole.accountant: [
    NavGroup(items: [
      NavItem(labelKey: 'navAccounting', icon: Icons.account_balance_outlined, activeIcon: Icons.account_balance, route: AppRoutes.accounting),
    ]),
    NavGroup(groupLabel: 'Finance', items: [
      NavItem(labelKey: 'navExpenses',   icon: Icons.money_off_outlined,       activeIcon: Icons.money_off,       route: AppRoutes.expenses),
      NavItem(labelKey: 'navInvoices',   icon: Icons.receipt_outlined,         activeIcon: Icons.receipt,         route: AppRoutes.invoices),
      NavItem(labelKey: 'navPayments',   icon: Icons.payment_outlined,         activeIcon: Icons.payment,         route: AppRoutes.payments),
      NavItem(labelKey: 'navProfit',     icon: Icons.show_chart,               activeIcon: Icons.show_chart,      route: AppRoutes.profit),
      NavItem(labelKey: 'navReports',    icon: Icons.bar_chart_outlined,       activeIcon: Icons.bar_chart,       route: AppRoutes.reports),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navSettings',   icon: Icons.settings_outlined,        activeIcon: Icons.settings,        route: AppRoutes.settings),
    ]),
  ],

  UserRole.waiter: [
    NavGroup(items: [
      NavItem(labelKey: 'navTables',       icon: Icons.table_restaurant_outlined, activeIcon: Icons.table_restaurant, route: AppRoutes.tables),
      NavItem(labelKey: 'navOrders',       icon: Icons.receipt_long_outlined,     activeIcon: Icons.receipt_long,     route: AppRoutes.orders),
      NavItem(labelKey: 'navReservations', icon: Icons.event_seat_outlined,       activeIcon: Icons.event_seat,       route: AppRoutes.reservations),
      NavItem(labelKey: 'navCustomers',    icon: Icons.people_outline,            activeIcon: Icons.people,           route: AppRoutes.customers),
    ]),
    NavGroup(groupLabel: 'Other', items: [
      NavItem(labelKey: 'navSettings',     icon: Icons.settings_outlined,         activeIcon: Icons.settings,         route: AppRoutes.settings),
    ]),
  ],
};
