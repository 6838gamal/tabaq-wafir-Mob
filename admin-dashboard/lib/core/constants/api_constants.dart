// lib/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  // Auth
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String authRefresh = '/auth/refresh';

  // Dashboard
  static const String dashboardStats = '/admin/dashboard/stats';
  static const String platformAnalytics = '/admin/analytics';

  // Restaurants
  static const String restaurants = '/admin/restaurants';
  static String restaurantById(String id) => '/admin/restaurants/$id';
  static String restaurantApprove(String id) =>
      '/admin/restaurants/$id/approve';
  static String restaurantSuspend(String id) =>
      '/admin/restaurants/$id/suspend';

  // Subscriptions
  static const String subscriptions = '/admin/subscriptions';
  static String subscriptionById(String id) => '/admin/subscriptions/$id';
  static String cancelSubscription(String id) =>
      '/admin/subscriptions/$id/cancel';

  // Plans
  static const String plans = '/admin/plans';
  static String planById(String id) => '/admin/plans/$id';

  // Customers
  static const String customers = '/admin/customers';
  static String customerById(String id) => '/admin/customers/$id';
  static String banCustomer(String id) => '/admin/customers/$id/ban';

  // Drivers
  static const String drivers = '/admin/drivers';
  static String driverById(String id) => '/admin/drivers/$id';
  static String approveDriver(String id) => '/admin/drivers/$id/approve';
  static String suspendDriver(String id) => '/admin/drivers/$id/suspend';

  // Cities
  static const String cities = '/admin/cities';
  static String cityById(String id) => '/admin/cities/$id';

  // Delivery Zones
  static const String zones = '/admin/delivery-zones';
  static String zoneById(String id) => '/admin/delivery-zones/$id';

  // Commissions
  static const String commissions = '/admin/commissions';
  static String commissionById(String id) => '/admin/commissions/$id';

  // Payments
  static const String payments = '/admin/payments';
  static String paymentById(String id) => '/admin/payments/$id';
  static String refundPayment(String id) => '/admin/payments/$id/refund';

  // Coupons
  static const String coupons = '/admin/coupons';
  static String couponById(String id) => '/admin/coupons/$id';
  static String deactivateCoupon(String id) =>
      '/admin/coupons/$id/deactivate';

  // Ads
  static const String ads = '/admin/ads';
  static String adById(String id) => '/admin/ads/$id';

  // Complaints
  static const String complaints = '/admin/complaints';
  static String complaintById(String id) => '/admin/complaints/$id';
  static String resolveComplaint(String id) =>
      '/admin/complaints/$id/resolve';

  // Support
  static const String tickets = '/admin/support/tickets';
  static String ticketById(String id) => '/admin/support/tickets/$id';
  static String closeTicket(String id) =>
      '/admin/support/tickets/$id/close';

  // AI Monitoring
  static const String aiEvents = '/admin/ai/events';

  // Audit Logs
  static const String auditLogs = '/admin/audit-logs';
}
