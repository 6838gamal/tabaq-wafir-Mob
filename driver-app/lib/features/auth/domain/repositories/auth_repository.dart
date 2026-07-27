// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/driver.dart';

abstract class AuthRepository {
  Future<Driver> signInWithGoogle();
  Future<void> signOut();
  Future<Driver?> getCurrentDriver();
  Future<void> uploadDocument({
    required String documentType,
    required String filePath,
  });
  Future<String> getVerificationStatus();
}
