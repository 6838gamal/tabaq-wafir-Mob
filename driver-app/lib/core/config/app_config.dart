// lib/core/config/app_config.dart
class AppConfig {
  AppConfig._();

  static const String env = String.fromEnvironment('ENV', defaultValue: 'development');

  static bool get isDevelopment => env == 'development';
  static bool get isProduction => env == 'production';

  static String get baseUrl {
    switch (env) {
      case 'production':
        return 'https://api.restaurant-platform.com';
      case 'staging':
        return 'https://staging-api.restaurant-platform.com';
      default:
        return 'http://10.0.2.2:3000'; // Android emulator localhost
    }
  }

  static String get wsBaseUrl {
    switch (env) {
      case 'production':
        return 'wss://api.restaurant-platform.com';
      case 'staging':
        return 'wss://staging-api.restaurant-platform.com';
      default:
        return 'ws://10.0.2.2:3000';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}
