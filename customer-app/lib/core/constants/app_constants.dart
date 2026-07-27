class AppConstants {
  AppConstants._();

  static const int defaultPageSize = 20;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration networkTimeout = Duration(seconds: 30);

  static const String defaultCurrency = 'USD';
  static const String defaultLocale = 'en';

  static const double defaultMapZoom = 15.0;
  static const double defaultDeliveryRadiusKm = 10.0;

  // Storage keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';
  static const String keyOnboarded = 'onboarded';
}
