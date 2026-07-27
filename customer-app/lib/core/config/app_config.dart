class AppConfig {
  static const String appName = 'Restaurant Customer App';
  static const String appVersion = '1.0.0';
  static const bool isDebug = true;

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.restaurant-platform.com/v1',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  AppConfig._();
}
