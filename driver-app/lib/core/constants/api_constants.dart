// lib/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  // Auth
  static const String authGoogle = '/auth/driver/google';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';

  // Driver
  static const String driverProfile = '/driver/profile';
  static const String driverDocuments = '/driver/documents';
  static const String driverStatus = '/driver/status';
  static const String driverLocation = '/driver/location';
  static const String driverAvailability = '/driver/availability';

  // Orders
  static const String orders = '/driver/orders';
  static const String orderAccept = '/driver/orders/{id}/accept';
  static const String orderReject = '/driver/orders/{id}/reject';
  static const String orderComplete = '/driver/orders/{id}/complete';
  static const String orderPickedUp = '/driver/orders/{id}/picked-up';

  // Navigation / Routes
  static const String route = '/navigation/route';
  static const String shareLocation = '/navigation/share-location';

  // Earnings
  static const String earnings = '/driver/earnings';
  static const String earningsSummary = '/driver/earnings/summary';

  // Wallet
  static const String wallet = '/driver/wallet';
  static const String walletBalance = '/driver/wallet/balance';
  static const String walletCod = '/driver/wallet/cod';
  static const String transactions = '/driver/wallet/transactions';

  // History
  static const String deliveryHistory = '/driver/history';

  // Reviews
  static const String driverReviews = '/driver/reviews';

  // Support
  static const String supportTickets = '/support/tickets';
  static const String supportChat = '/support/tickets/{id}/messages';

  // Notifications
  static const String notifications = '/driver/notifications';
  static const String markNotificationRead = '/driver/notifications/{id}/read';
  static const String fcmToken = '/driver/fcm-token';

  // WebSocket events
  static const String wsEventNewOrder = 'new_order';
  static const String wsEventOrderUpdate = 'order_update';
  static const String wsEventLocationUpdate = 'location_update';
}
