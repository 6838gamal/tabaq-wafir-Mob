class AppConstants {
  AppConstants._();

  static const String appName = 'Restaurant Copilot';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.restaurantcopilot.com/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Google Sign-In — replace with your real Web Client ID
  // Format: "XXXX.apps.googleusercontent.com"
  static const String googleClientId = '';

  // Secure Storage Keys
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userPhotoKey = 'user_photo';
  static const String userRoleKey = 'user_role';
  static const String userBranchesKey = 'user_branches';
  static const String lastLoginKey = 'last_login';

  // SharedPreferences Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_done';
  static const String biometricKey = 'biometric_enabled';
  static const String sessionTimeoutKey = 'session_timeout';
  static const String selectedBranchKey = 'selected_branch';

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
  static const List<String> supportedLocales = ['en', 'ar'];
}
