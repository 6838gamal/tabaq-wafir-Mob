// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/admin_user.dart';

abstract class AuthRepository {
  Future<AdminUser> signInWithGoogle();
  Future<void> signOut();
  Future<AdminUser?> getCurrentUser();
  Stream<AdminUser?> get authStateChanges;
}
