// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/admin_model.dart';
import '../../../../core/services/auth_service.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(authServiceProvider)),
);

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final _authStateController = Stream<AdminUser?>.empty();

  AuthRepositoryImpl(this._authService);

  @override
  Future<AdminUser> signInWithGoogle() async {
    final userData = await _authService.signInWithGoogle();
    if (userData == null) {
      throw Exception('Google Sign-In cancelled');
    }
    return AdminModel(
      uid: userData['uid'] as String,
      email: userData['email'] as String,
      displayName: userData['displayName'] as String,
      photoUrl: userData['photoUrl'] as String?,
      role: 'admin',
    );
  }

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<AdminUser?> getCurrentUser() async {
    final token = await _authService.getToken();
    if (token == null) return null;
    // In a real app, decode the JWT or fetch from API
    return null;
  }

  @override
  Stream<AdminUser?> get authStateChanges => _authStateController;
}
