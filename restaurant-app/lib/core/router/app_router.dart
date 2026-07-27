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

// Router refreshes when auth state changes
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final _routerNotifierProvider = ChangeNotifierProvider<_RouterNotifier>(
  (ref) => _RouterNotifier(ref),
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final loc = state.matchedLocation;

      final publicRoutes = {
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.unauthorized,
        AppRoutes.sessionExpired,
      };

      final isPublic = publicRoutes.contains(loc);

      // Session expired → dedicated screen
      if (authState.status == AuthStatus.sessionExpired &&
          loc != AppRoutes.sessionExpired) {
        return AppRoutes.sessionExpired;
      }

      // Not authenticated → login
      if (!authState.isAuthenticated && !isPublic) {
        return AppRoutes.login;
      }

      // Authenticated but hitting public route → dashboard
      if (authState.isAuthenticated &&
          (loc == AppRoutes.login || loc == AppRoutes.splash)) {
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
          // New routes — coming-soon pages
          GoRoute(path: AppRoutes.branches,     builder: (_, s) => _ComingSoon('Branches')),
          GoRoute(path: AppRoutes.suppliers,    builder: (_, s) => _ComingSoon('Suppliers')),
          GoRoute(path: AppRoutes.purchases,    builder: (_, s) => _ComingSoon('Purchases')),
          GoRoute(path: AppRoutes.analytics,    builder: (_, s) => _ComingSoon('Analytics')),
          GoRoute(path: AppRoutes.auditLogs,    builder: (_, s) => _ComingSoon('Audit Logs')),
          GoRoute(path: AppRoutes.todaysTasks,  builder: (_, s) => _ComingSoon("Today's Tasks")),
          GoRoute(path: AppRoutes.attendance,   builder: (_, s) => _ComingSoon('Attendance')),
          GoRoute(path: AppRoutes.pos,          builder: (_, s) => _ComingSoon('POS')),
          GoRoute(path: AppRoutes.refunds,      builder: (_, s) => _ComingSoon('Refunds')),
          GoRoute(path: AppRoutes.recipes,      builder: (_, __) => const RecipesPage()),
          GoRoute(path: AppRoutes.transfers,    builder: (_, s) => _ComingSoon('Transfers')),
          GoRoute(path: AppRoutes.expiry,       builder: (_, s) => _ComingSoon('Expiry')),
          GoRoute(path: AppRoutes.expenses,     builder: (_, s) => _ComingSoon('Expenses')),
          GoRoute(path: AppRoutes.invoices,     builder: (_, s) => _ComingSoon('Invoices')),
          GoRoute(path: AppRoutes.payments,     builder: (_, s) => _ComingSoon('Payments')),
          GoRoute(path: AppRoutes.profit,       builder: (_, s) => _ComingSoon('Profit')),
          GoRoute(path: AppRoutes.tables,       builder: (_, s) => _ComingSoon('Tables')),
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
