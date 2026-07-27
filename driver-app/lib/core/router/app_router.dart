import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_page.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/identity_verification_screen.dart';
import '../../features/auth/presentation/screens/document_upload_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/earnings/presentation/screens/earnings_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/navigation/presentation/screens/to_restaurant_screen.dart';
import '../../features/navigation/presentation/screens/to_customer_screen.dart';
import '../widgets/main_shell.dart';

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
      GoRoute(
        path: '/verify',
        builder: (context, state) => const IdentityVerificationScreen(),
      ),
      GoRoute(
        path: '/upload-docs',
        builder: (context, state) => const DocumentUploadScreen(),
      ),
      GoRoute(
        path: '/nav/restaurant',
        builder: (context, state) => const ToRestaurantScreen(),
      ),
      GoRoute(
        path: '/nav/customer',
        builder: (context, state) => const ToCustomerScreen(),
      ),

      // ── Main shell ────────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/earnings',
            builder: (context, state) => const EarningsScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const _PlaceholderScreen(
                title: 'Support', icon: Icons.support_agent),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const _PlaceholderScreen(
                title: 'Settings', icon: Icons.settings),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        _PlaceholderScreen(title: 'Page not found', icon: Icons.error_outline),
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
