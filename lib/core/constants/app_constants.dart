class AppConstants {
  AppConstants._();

  static const String appName = 'Restaurant Copilot';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.restaurantcopilot.com/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'current_user';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_done';
  static const String biometricKey = 'biometric_enabled';
  static const String sessionTimeoutKey = 'session_timeout';

  // Hive Boxes
  static const String settingsBox = 'settings';
  static const String ordersBox = 'orders';
  static const String inventoryBox = 'inventory';
  static const String customersBox = 'customers';
  static const String syncQueueBox = 'sync_queue';

  // Pagination
  static const int defaultPageSize = 20;

  // Session
  static const int sessionTimeoutMinutes = 30;

  // Locales
  static const String arabicLocale = 'ar';
  static const String englishLocale = 'en';

  // Supported Locales
  static const List<String> supportedLocales = ['en', 'ar'];
}
