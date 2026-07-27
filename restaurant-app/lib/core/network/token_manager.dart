import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

/// Platform-aware token / user-data storage.
///
/// • Web     → [SharedPreferences] (localStorage). flutter_secure_storage uses
///             the Web Crypto API which requires HTTPS; on HTTP it hangs silently.
/// • Mobile  → [FlutterSecureStorage] with encrypted shared preferences.
class TokenManager {
  FlutterSecureStorage? _secureStorage;
  SharedPreferences? _prefs;

  TokenManager();

  Future<void> _ensureInit() async {
    if (kIsWeb) {
      _prefs ??= await SharedPreferences.getInstance();
    } else {
      _secureStorage ??= const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
    }
  }

  Future<String?> _read(String key) async {
    await _ensureInit();
    if (kIsWeb) return _prefs!.getString(key);
    return _secureStorage!.read(key: key);
  }

  Future<void> _write(String key, String value) async {
    await _ensureInit();
    if (kIsWeb) {
      await _prefs!.setString(key, value);
    } else {
      await _secureStorage!.write(key: key, value: value);
    }
  }

  Future<void> _delete(String key) async {
    await _ensureInit();
    if (kIsWeb) {
      await _prefs!.remove(key);
    } else {
      await _secureStorage!.delete(key: key);
    }
  }

  Future<void> _deleteAll() async {
    await _ensureInit();
    if (kIsWeb) {
      await _prefs!.clear();
    } else {
      await _secureStorage!.deleteAll();
    }
  }

  // ── Public API ────────────────────────────────────────────────────────────

  Future<String?> getAccessToken() => _read(AppConstants.tokenKey);
  Future<String?> getRefreshToken() => _read(AppConstants.refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _write(AppConstants.tokenKey, accessToken);
    if (refreshToken != null) {
      await _write(AppConstants.refreshTokenKey, refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await _delete(AppConstants.tokenKey);
    await _delete(AppConstants.refreshTokenKey);
  }

  Future<void> saveUserData(Map<String, String> data) async {
    for (final entry in data.entries) {
      await _write(entry.key, entry.value);
    }
  }

  Future<String?> getUserData(String key) => _read(key);

  Future<void> clearAll() => _deleteAll();

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

final tokenManagerProvider = Provider<TokenManager>((_) => TokenManager());
