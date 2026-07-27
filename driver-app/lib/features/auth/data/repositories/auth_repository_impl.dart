// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/driver.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_source.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  final authService = ref.read(authServiceProvider);
  final remoteSource = AuthRemoteSourceImpl(dioClient, authService);
  return AuthRepositoryImpl(remoteSource, authService);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final AuthService _authService;

  AuthRepositoryImpl(this._remoteSource, this._authService);

  @override
  Future<Driver> signInWithGoogle() => _remoteSource.signInWithGoogle();

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<Driver?> getCurrentDriver() async {
    final isAuth = await _authService.isAuthenticated();
    if (!isAuth) return null;
    return _remoteSource.getDriverProfile();
  }

  @override
  Future<void> uploadDocument({
    required String documentType,
    required String filePath,
  }) =>
      _remoteSource.uploadDocument(
        documentType: documentType,
        filePath: filePath,
      );

  @override
  Future<String> getVerificationStatus() => _remoteSource.getVerificationStatus();
}
