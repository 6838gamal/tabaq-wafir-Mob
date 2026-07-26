import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/copilot/presentation/pages/copilot_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/inventory/presentation/pages/products_page.dart';
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
import '../widgets/main_shell.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String copilot = '/copilot';
  static const String alerts = '/alerts';
  static const String notifications = '/notifications';
  static const String inventory = '/inventory';
  static const String products = '/inventory/products';
  static const String stockCount = '/inventory/stock-count';
  static const String waste = '/inventory/waste';
  static const String orders = '/orders';
  static const String kitchen = '/kitchen';
  static const String reservations = '/reservations';
  static const String customers = '/customers';
  static const String employees = '/employees';
  static const String accounting = '/accounting';
  static const String reports = '/reports';
  static const String aiAssistant = '/ai-assistant';
  static const String settings = '/settings';
  static const String profile = '/settings/profile';
  static const String activityLog = '/settings/activity-log';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpPage(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.copilot,
            builder: (context, state) => const CopilotPage(),
          ),
          GoRoute(
            path: AppRoutes.alerts,
            builder: (context, state) => const AlertsPage(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: AppRoutes.inventory,
            builder: (context, state) => const InventoryPage(),
          ),
          GoRoute(
            path: AppRoutes.products,
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: AppRoutes.stockCount,
            builder: (context, state) => const StockCountPage(),
          ),
          GoRoute(
            path: AppRoutes.waste,
            builder: (context, state) => const WastePage(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            builder: (context, state) => const OrdersPage(),
          ),
          GoRoute(
            path: AppRoutes.kitchen,
            builder: (context, state) => const KitchenPage(),
          ),
          GoRoute(
            path: AppRoutes.reservations,
            builder: (context, state) => const ReservationsPage(),
          ),
          GoRoute(
            path: AppRoutes.customers,
            builder: (context, state) => const CustomersPage(),
          ),
          GoRoute(
            path: AppRoutes.employees,
            builder: (context, state) => const EmployeesPage(),
          ),
          GoRoute(
            path: AppRoutes.accounting,
            builder: (context, state) => const AccountingPage(),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(
            path: AppRoutes.aiAssistant,
            builder: (context, state) => const AiAssistantPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.activityLog,
            builder: (context, state) => const ActivityLogPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
