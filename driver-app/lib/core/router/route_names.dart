// lib/core/router/route_names.dart
class RouteNames {
  RouteNames._();

  static const String login = '/login';
  static const String verify = '/verify';
  static const String uploadDocs = '/upload-docs';
  static const String home = '/home';
  static const String orderIncoming = '/order-incoming';
  static const String orderActive = '/order-active';
  static const String orderDetail = '/order/:id';
  static const String navigateRestaurant = '/navigate-restaurant';
  static const String navigateCustomer = '/navigate-customer';
  static const String earnings = '/earnings';
  static const String wallet = '/wallet';
  static const String history = '/history';
  static const String reviews = '/reviews';
  static const String support = '/support';
  static const String supportChat = '/support/chat/:ticketId';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Helper for parameterised routes
  static String orderDetailPath(String id) => '/order/$id';
  static String supportChatPath(String ticketId) => '/support/chat/$ticketId';
}
