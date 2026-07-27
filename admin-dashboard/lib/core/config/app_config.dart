// lib/core/config/app_config.dart
class AppConfig {
  AppConfig._();

  static const String appName = 'Restaurant Admin Dashboard';
  static const String appVersion = '1.0.0';

  // Environment
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const String environment =
      bool.fromEnvironment('dart.vm.product') ? 'production' : 'development';

  // API
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.restaurantplatform.com/v1',
  );

  // Firebase project settings (populated from firebase_options.dart at runtime)
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'restaurant-platform',
  );

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts (milliseconds)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
