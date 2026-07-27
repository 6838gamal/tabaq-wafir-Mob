// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/identity_verification_screen.dart';
import '../../features/auth/presentation/screens/document_upload_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/orders/presentation/screens/incoming_order_screen.dart';
import '../../features/orders/presentation/screens/active_order_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/delivery_proof_screen.dart';
import '../../features/navigation/presentation/screens/to_restaurant_screen.dart';
import '../../features/navigation/presentation/screens/to_customer_screen.dart';
import '../../features/earnings/presentation/screens/earnings_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/reviews/presentation/screens/reviews_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/support/presentation/screens/chat_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../constants/app_constants.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.login,
    redirect: (BuildContext context, GoRouterState state) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.keyAccessToken);
      final isLoggedIn = token != null;
      final isLoginRoute = state.matchedLocation == RouteNames.login;

      if (!isLoggedIn && !isLoginRoute) return RouteNames.login;
      if (isLoggedIn && isLoginRoute) return RouteNames.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.verify,
        builder: (context, state) => const IdentityVerificationScreen(),
      ),
      GoRoute(
        path: RouteNames.uploadDocs,
        builder: (context, state) => const DocumentUploadScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.orderIncoming,
        builder: (context, state) => const IncomingOrderScreen(),
      ),
      GoRoute(
        path: RouteNames.orderActive,
        builder: (context, state) => const ActiveOrderScreen(),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/delivery-proof/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return DeliveryProofScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: RouteNames.navigateRestaurant,
        builder: (context, state) => const ToRestaurantScreen(),
      ),
      GoRoute(
        path: RouteNames.navigateCustomer,
        builder: (context, state) => const ToCustomerScreen(),
      ),
      GoRoute(
        path: RouteNames.earnings,
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: RouteNames.wallet,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: RouteNames.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.reviews,
        builder: (context, state) => const ReviewsScreen(),
      ),
      GoRoute(
        path: RouteNames.support,
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/support/chat/:ticketId',
        builder: (context, state) {
          final ticketId = state.pathParameters['ticketId']!;
          return ChatScreen(ticketId: ticketId);
        },
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
});
