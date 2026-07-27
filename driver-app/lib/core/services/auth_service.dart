// lib/core/services/auth_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../network/dio_client.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(dioClientProvider));
});

class AuthService {
  final DioClient _dioClient;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  AuthService(this._dioClient);

  Future<Map<String, dynamic>> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final auth = await googleUser.authentication;
    final idToken = auth.idToken;
    if (idToken == null) throw Exception('Google ID token unavailable');

    final response = await _dioClient.post('/auth/driver/google', data: {
      'id_token': idToken,
    });

    final data = response.data as Map<String, dynamic>;
    await _persistTokens(data);
    return data;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _clearTokens();
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyAccessToken) != null;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyAccessToken);
  }

  Future<void> _persistTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;
    final driverId = data['driver_id'] as String?;

    if (accessToken != null) {
      await prefs.setString(AppConstants.keyAccessToken, accessToken);
    }
    if (refreshToken != null) {
      await prefs.setString(AppConstants.keyRefreshToken, refreshToken);
    }
    if (driverId != null) {
      await prefs.setString(AppConstants.keyDriverId, driverId);
    }
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAccessToken);
    await prefs.remove(AppConstants.keyRefreshToken);
    await prefs.remove(AppConstants.keyDriverId);
  }
}
