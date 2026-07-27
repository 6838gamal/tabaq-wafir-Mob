import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/unauthorized_page.dart';
import '../../features/auth/presentation/pages/session_expired_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/copilot/presentation/pages/copilot_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/inventory/presentation/pages/products_page.dart';
import '../../features/inventory/presentation/pages/recipes_page.dart';
import '../../features/inventory/presentation/pages/stock_count_page.dart';
import '../../features/inventory/presentation/pages/waste_page.dart';
import '../../features/inventory/presentation/pages/suppliers_page.dart';
import '../../features/inventory/presentation/pages/purchases_page.dart';
import '../../features/inventory/presentation/pages/transfers_page.dart';
import '../../features/inventory/presentation/pages/expiry_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/kitchen/presentation/pages/kitchen_page.dart';
import '../../features/reservations/presentation/pages/reservations_page.dart';
import '../../features/customers/presentation/pages/customers_page.dart';
import '../../features/employees/presentation/pages/employees_page.dart';
import '../../features/accounting/presentation/pages/accounting_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/ai_assistant/presentation/pages/ai_assistant_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/activity_log_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
// New feature pages
import '../../features/branches/presentation/pages/branches_page.dart';
import '../../features/tables/presentation/pages/tables_page.dart';
import '../../features/pos/presentation/pages/pos_page.dart';
import '../../features/attendance/presentation/pages/attendance_page.dart';
import '../../features/todays_tasks/presentation/pages/todays_tasks_page.dart';
import '../../features/expenses/presentation/pages/expenses_page.dart';
import '../../features/invoices/presentation/pages/invoices_page.dart';
import '../../features/payments/presentation/pages/payments_page.dart';
import '../../features/profit/presentation/pages/profit_page.dart';
import '../../features/refunds/presentation/pages/refunds_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/audit_log/presentation/pages/audit_log_page.dart';
import '../widgets/main_shell.dart';

class AppRoutes {
  static const String splash        = '/splash';
  static const String login         = '/login';
  static const String unauthorized  = '/unauthorized';
  static const String sessionExpired= '/session-expired';
  static const String dashboard     = '/dashboard';
  static const String copilot       = '/copilot';
  static const String alerts        = '/alerts';
  static const String notifications = '/notifications';
  static const String inventory     = '/inventory';
  static const String products      = '/inventory/products';
  static const String stockCount    = '/inventory/stock-count';
  static const String waste         = '/inventory/waste';
  static const String expiry        = '/inventory/expiry';
  static const String transfers     = '/inventory/transfers';
  static const String orders        = '/orders';
  static const String kitchen       = '/kitchen';
  static const String reservations  = '/reservations';
  static const String customers     = '/customers';
  static const String employees     = '/employees';
  static const String accounting    = '/accounting';
  static const String reports       = '/reports';
  static const String aiAssistant   = '/ai-assistant';
  static const String settings      = '/settings';
  static const String profile       = '/settings/profile';
  static const String activityLog   = '/settings/activity-log';
  // New routes
  static const String branches      = '/branches';
  static const String suppliers     = '/suppliers';
  static const String purchases     = '/purchases';
  static const String analytics     = '/analytics';
  static const String auditLogs     = '/audit-logs';
  static const String todaysTasks   = '/todays-tasks';
  static const String attendance    = '/attendance';
  static const String pos           = '/pos';
  static const String refunds       = '/refunds';
  static const String expenses      = '/expenses';
  static const String invoices      = '/invoices';
  static const String payments      = '/payments';
  static const String profit        = '/profit';
  static const String tables        = '/tables';
  static const String recipes       = '/inventory/recipes';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // No refreshListenable — the splash drives its own navigation via ref.listen,
  // and route guards run on every GoRouter navigation attempt via redirect below.
  // This avoids any timing conflict between refreshListenable and context.go.
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final loc = state.matchedLocation;
      final status = authState.status;

      // Splash handles its own exit — leave it alone.
      if (loc == AppRoutes.splash) return null;

      // ── Session expired ──────────────────────────────────────────────────
      if (status == AuthStatus.sessionExpired &&
          loc != AppRoutes.sessionExpired) {
        return AppRoutes.sessionExpired;
      }

      // ── Protected routes: must be authenticated ──────────────────────────
      const publicRoutes = {
        AppRoutes.login,
        AppRoutes.unauthorized,
        AppRoutes.sessionExpired,
      };
      final isPublic = publicRoutes.contains(loc);

      if (!authState.isAuthenticated && !isPublic) {
        return AppRoutes.login;
      }

      // ── Authenticated on a public route → dashboard ──────────────────────
      if (authState.isAuthenticated && isPublic) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // Public
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.unauthorized,
        builder: (_, __) => const UnauthorizedPage(),
      ),
      GoRoute(
        path: AppRoutes.sessionExpired,
        builder: (_, __) => const SessionExpiredPage(),
      ),

      // Protected — wrapped in MainShell
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.dashboard,    builder: (_, __) => const DashboardPage()),
          GoRoute(path: AppRoutes.copilot,      builder: (_, __) => const CopilotPage()),
          GoRoute(path: AppRoutes.alerts,       builder: (_, __) => const AlertsPage()),
          GoRoute(path: AppRoutes.notifications,builder: (_, __) => const NotificationsPage()),
          GoRoute(path: AppRoutes.inventory,    builder: (_, __) => const InventoryPage()),
          GoRoute(path: AppRoutes.products,     builder: (_, __) => const ProductsPage()),
          GoRoute(path: AppRoutes.stockCount,   builder: (_, __) => const StockCountPage()),
          GoRoute(path: AppRoutes.waste,        builder: (_, __) => const WastePage()),
          GoRoute(path: AppRoutes.orders,       builder: (_, __) => const OrdersPage()),
          GoRoute(path: AppRoutes.kitchen,      builder: (_, __) => const KitchenPage()),
          GoRoute(path: AppRoutes.reservations, builder: (_, __) => const ReservationsPage()),
          GoRoute(path: AppRoutes.customers,    builder: (_, __) => const CustomersPage()),
          GoRoute(path: AppRoutes.employees,    builder: (_, __) => const EmployeesPage()),
          GoRoute(path: AppRoutes.accounting,   builder: (_, __) => const AccountingPage()),
          GoRoute(path: AppRoutes.reports,      builder: (_, __) => const ReportsPage()),
          GoRoute(path: AppRoutes.aiAssistant,  builder: (_, __) => const AiAssistantPage()),
          GoRoute(path: AppRoutes.settings,     builder: (_, __) => const SettingsPage()),
          GoRoute(path: AppRoutes.profile,      builder: (_, __) => const ProfilePage()),
          GoRoute(path: AppRoutes.activityLog,  builder: (_, __) => const ActivityLogPage()),
          // Previously coming-soon — now fully built
          GoRoute(path: AppRoutes.branches,     builder: (_, __) => const BranchesPage()),
          GoRoute(path: AppRoutes.suppliers,    builder: (_, __) => const SuppliersPage()),
          GoRoute(path: AppRoutes.purchases,    builder: (_, __) => const PurchasesPage()),
          GoRoute(path: AppRoutes.analytics,    builder: (_, __) => const AnalyticsPage()),
          GoRoute(path: AppRoutes.auditLogs,    builder: (_, __) => const AuditLogPage()),
          GoRoute(path: AppRoutes.todaysTasks,  builder: (_, __) => const TodaysTasksPage()),
          GoRoute(path: AppRoutes.attendance,   builder: (_, __) => const AttendancePage()),
          GoRoute(path: AppRoutes.pos,          builder: (_, __) => const PosPage()),
          GoRoute(path: AppRoutes.refunds,      builder: (_, __) => const RefundsPage()),
          GoRoute(path: AppRoutes.recipes,      builder: (_, __) => const RecipesPage()),
          GoRoute(path: AppRoutes.transfers,    builder: (_, __) => const TransfersPage()),
          GoRoute(path: AppRoutes.expiry,       builder: (_, __) => const ExpiryPage()),
          GoRoute(path: AppRoutes.expenses,     builder: (_, __) => const ExpensesPage()),
          GoRoute(path: AppRoutes.invoices,     builder: (_, __) => const InvoicesPage()),
          GoRoute(path: AppRoutes.payments,     builder: (_, __) => const PaymentsPage()),
          GoRoute(path: AppRoutes.profit,       builder: (_, __) => const ProfitPage()),
          GoRoute(path: AppRoutes.tables,       builder: (_, __) => const TablesPage()),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
});

class _ComingSoon extends StatelessWidget {
  final String title;
  const _ComingSoon(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_outlined,
                size: 64, color: theme.colorScheme.primary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(title,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Coming Soon',
                style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
