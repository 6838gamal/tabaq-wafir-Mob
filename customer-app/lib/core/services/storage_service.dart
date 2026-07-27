import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_customer_app/core/constants/app_constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Auth token
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(AppConstants.keyAuthToken, token);
  }

  Future<String?> getAuthToken() async {
    return _prefs.getString(AppConstants.keyAuthToken);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove(AppConstants.keyAuthToken);
  }

  // Refresh token
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(AppConstants.keyRefreshToken, token);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(AppConstants.keyRefreshToken);
  }

  // User id
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.keyUserId, userId);
  }

  Future<String?> getUserId() async {
    return _prefs.getString(AppConstants.keyUserId);
  }

  // Theme
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConstants.keyThemeMode, mode);
  }

  String getThemeMode() {
    return _prefs.getString(AppConstants.keyThemeMode) ?? 'light';
  }

  // Locale
  Future<void> saveLocale(String locale) async {
    await _prefs.setString(AppConstants.keyLocale, locale);
  }

  String getLocale() {
    return _prefs.getString(AppConstants.keyLocale) ?? AppConstants.defaultLocale;
  }

  // Onboarding
  Future<void> setOnboarded(bool value) async {
    await _prefs.setBool(AppConstants.keyOnboarded, value);
  }

  bool isOnboarded() {
    return _prefs.getBool(AppConstants.keyOnboarded) ?? false;
  }

  // Clear all
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Generic helpers
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
}
