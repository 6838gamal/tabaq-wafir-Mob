import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_page.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/order_tracking_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/discovery/presentation/screens/discovery_screen.dart';
import '../../features/discovery/presentation/screens/search_screen.dart';
import '../../features/maps/presentation/screens/map_picker_screen.dart';
import '../../features/maps/presentation/screens/saved_addresses_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
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

      // ── Main shell ────────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    OrderDetailScreen(orderId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'track/:id',
                builder: (context, state) =>
                    OrderTrackingScreen(orderId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // ── Routes outside shell ──────────────────────────────────────────────
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/discovery',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/map-picker',
        builder: (context, state) => const MapPickerScreen(),
      ),
      GoRoute(
        path: '/addresses',
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) =>
            ChatScreen(chatId: state.pathParameters['id']!),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
});
