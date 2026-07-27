// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/restaurants/presentation/screens/restaurants_screen.dart';
import '../../features/restaurants/presentation/screens/restaurant_detail_screen.dart';
import '../../features/restaurants/presentation/screens/restaurant_approval_screen.dart';
import '../../features/subscriptions/presentation/screens/subscriptions_screen.dart';
import '../../features/subscriptions/presentation/screens/subscription_detail_screen.dart';
import '../../features/plans/presentation/screens/plans_screen.dart';
import '../../features/plans/presentation/screens/create_plan_screen.dart';
import '../../features/customers/presentation/screens/customers_screen.dart';
import '../../features/customers/presentation/screens/customer_detail_screen.dart';
import '../../features/drivers/presentation/screens/drivers_screen.dart';
import '../../features/drivers/presentation/screens/driver_detail_screen.dart';
import '../../features/drivers/presentation/screens/driver_approval_screen.dart';
import '../../features/cities/presentation/screens/cities_screen.dart';
import '../../features/cities/presentation/screens/create_city_screen.dart';
import '../../features/delivery_zones/presentation/screens/delivery_zones_screen.dart';
import '../../features/delivery_zones/presentation/screens/create_zone_screen.dart';
import '../../features/commissions/presentation/screens/commissions_screen.dart';
import '../../features/payments/presentation/screens/payments_screen.dart';
import '../../features/payments/presentation/screens/payment_detail_screen.dart';
import '../../features/coupons/presentation/screens/coupons_screen.dart';
import '../../features/coupons/presentation/screens/create_coupon_screen.dart';
import '../../features/ads/presentation/screens/ads_screen.dart';
import '../../features/ads/presentation/screens/create_ad_screen.dart';
import '../../features/complaints/presentation/screens/complaints_screen.dart';
import '../../features/complaints/presentation/screens/complaint_detail_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/support/presentation/screens/ticket_detail_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/ai_monitoring/presentation/screens/ai_monitoring_screen.dart';
import '../../features/audit_logs/presentation/screens/audit_logs_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // TODO: Check auth state and redirect to /login if not authenticated
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Restaurants
      GoRoute(
        path: '/restaurants',
        name: 'restaurants',
        builder: (context, state) => const RestaurantsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'restaurantDetail',
            builder: (context, state) =>
                RestaurantDetailScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: ':id/approval',
            name: 'restaurantApproval',
            builder: (context, state) =>
                RestaurantApprovalScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),

      // Subscriptions
      GoRoute(
        path: '/subscriptions',
        name: 'subscriptions',
        builder: (context, state) => const SubscriptionsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'subscriptionDetail',
            builder: (context, state) =>
                SubscriptionDetailScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),

      // Plans
      GoRoute(
        path: '/plans',
        name: 'plans',
        builder: (context, state) => const PlansScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'createPlan',
            builder: (context, state) => const CreatePlanScreen(),
          ),
        ],
      ),

      // Customers
      GoRoute(
        path: '/customers',
        name: 'customers',
        builder: (context, state) => const CustomersScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'customerDetail',
            builder: (context, state) =>
                CustomerDetailScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),

      // Drivers
      GoRoute(
        path: '/drivers',
        name: 'drivers',
        builder: (context, state) => const DriversScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'driverDetail',
            builder: (context, state) =>
                DriverDetailScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: ':id/approval',
            name: 'driverApproval',
            builder: (context, state) =>
                DriverApprovalScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),

      // Cities
      GoRoute(
        path: '/cities',
        name: 'cities',
        builder: (context, state) => const CitiesScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'createCity',
            builder: (context, state) => const CreateCityScreen(),
          ),
        ],
      ),

      // Delivery Zones
      GoRoute(
        path: '/delivery-zones',
        name: 'deliveryZones',
        builder: (context, state) => const DeliveryZonesScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'createZone',
            builder: (context, state) => const CreateZoneScreen(),
          ),
        ],
      ),

      // Commissions
      GoRoute(
        path: '/commissions',
        name: 'commissions',
        builder: (context, state) => const CommissionsScreen(),
      ),

      // Payments
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => const PaymentsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'paymentDetail',
            builder: (context, state) =>
                PaymentDetailScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),

      // Coupons
      GoRoute(
        path: '/coupons',
        name: 'coupons',
        builder: (context, state) => const CouponsScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'createCoupon',
            builder: (context, state) => const CreateCouponScreen(),
          ),
        ],
      ),

      // Ads
      GoRoute(
        path: '/ads',
        name: 'ads',
        builder: (context, state) => const AdsScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'createAd',
            builder: (context, state) => const CreateAdScreen(),
          ),
        ],
      ),

      // Complaints
      GoRoute(
        path: '/complaints',
        name: 'complaints',
        builder: (context, state) => const ComplaintsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'complaintDetail',
            builder: (context, state) =>
                ComplaintDetailScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),

      // Support
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => const SupportScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'ticketDetail',
            builder: (context, state) =>
                TicketDetailScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),

      // Analytics
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),

      // AI Monitoring
      GoRoute(
        path: '/ai-monitoring',
        name: 'aiMonitoring',
        builder: (context, state) => const AiMonitoringScreen(),
      ),

      // Audit Logs
      GoRoute(
        path: '/audit-logs',
        name: 'auditLogs',
        builder: (context, state) => const AuditLogsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});
