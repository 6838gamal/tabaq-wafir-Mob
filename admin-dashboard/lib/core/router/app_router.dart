import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_page.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/restaurants/presentation/screens/restaurants_screen.dart';
import '../../features/restaurants/presentation/screens/restaurant_detail_screen.dart';
import '../widgets/main_shell.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Main shell ────────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/restaurants',
            builder: (context, state) => const RestaurantsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => RestaurantDetailScreen(
                    id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const _PlaceholderScreen(
                title: 'Users & Drivers', icon: Icons.people),
          ),
          GoRoute(
            path: '/payments',
            builder: (context, state) => const _PlaceholderScreen(
                title: 'Payments', icon: Icons.payments),
          ),
          GoRoute(
            path: '/complaints',
            builder: (context, state) => const _PlaceholderScreen(
                title: 'Complaints', icon: Icons.support),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const _PlaceholderScreen(
                title: 'Analytics', icon: Icons.analytics),
          ),
          GoRoute(
            path: '/audit-logs',
            builder: (context, state) => const _PlaceholderScreen(
                title: 'Audit Logs', icon: Icons.history),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const _PlaceholderScreen(
        title: 'Page not found', icon: Icons.error_outline),
  );
});

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
