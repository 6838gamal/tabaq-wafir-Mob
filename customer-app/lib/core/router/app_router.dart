import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/features/auth/presentation/screens/login_screen.dart';
import 'package:restaurant_customer_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:restaurant_customer_app/features/cart/presentation/screens/checkout_screen.dart';
import 'package:restaurant_customer_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:restaurant_customer_app/features/discovery/presentation/screens/discovery_screen.dart';
import 'package:restaurant_customer_app/features/discovery/presentation/screens/search_screen.dart';
import 'package:restaurant_customer_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:restaurant_customer_app/features/home/presentation/screens/home_screen.dart';
import 'package:restaurant_customer_app/features/maps/presentation/screens/map_picker_screen.dart';
import 'package:restaurant_customer_app/features/maps/presentation/screens/saved_addresses_screen.dart';
import 'package:restaurant_customer_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:restaurant_customer_app/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:restaurant_customer_app/features/orders/presentation/screens/order_tracking_screen.dart';
import 'package:restaurant_customer_app/features/orders/presentation/screens/orders_screen.dart';
import 'package:restaurant_customer_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:restaurant_customer_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:restaurant_customer_app/features/profile/presentation/screens/settings_screen.dart';
import 'package:restaurant_customer_app/features/restaurant/presentation/screens/restaurant_detail_screen.dart';
import 'package:restaurant_customer_app/features/reviews/presentation/screens/rate_order_screen.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(
      path: RouteNames.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteNames.discovery,
      name: 'discovery',
      builder: (context, state) => const DiscoveryScreen(),
    ),
    GoRoute(
      path: RouteNames.search,
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: RouteNames.restaurant,
      name: 'restaurant',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return RestaurantDetailScreen(restaurantId: id);
      },
    ),
    GoRoute(
      path: RouteNames.cart,
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: RouteNames.checkout,
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: RouteNames.mapPicker,
      name: 'mapPicker',
      builder: (context, state) => const MapPickerScreen(),
    ),
    GoRoute(
      path: RouteNames.addresses,
      name: 'addresses',
      builder: (context, state) => const SavedAddressesScreen(),
    ),
    GoRoute(
      path: RouteNames.orders,
      name: 'orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: RouteNames.orderDetail,
      name: 'orderDetail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return OrderDetailScreen(orderId: id);
      },
    ),
    GoRoute(
      path: RouteNames.tracking,
      name: 'tracking',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return OrderTrackingScreen(orderId: id);
      },
    ),
    GoRoute(
      path: RouteNames.chat,
      name: 'chat',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ChatScreen(chatId: id);
      },
    ),
    GoRoute(
      path: RouteNames.favorites,
      name: 'favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: RouteNames.reviews,
      name: 'reviews',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return RateOrderScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: RouteNames.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: RouteNames.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.editProfile,
      name: 'editProfile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
