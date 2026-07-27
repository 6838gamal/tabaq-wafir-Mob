import 'package:restaurant_customer_app/features/auth/data/sources/auth_remote_source.dart';
import 'package:restaurant_customer_app/features/auth/domain/entities/user.dart';
import 'package:restaurant_customer_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;

  AuthRepositoryImpl(this._remoteSource);

  @override
  Future<UserEntity> signInWithGoogle() => _remoteSource.signInWithGoogle();

  @override
  Future<UserEntity> signInAsGuest() => _remoteSource.signInAsGuest();

  @override
  Future<void> signOut() => _remoteSource.signOut();

  @override
  Future<UserEntity?> getCurrentUser() => _remoteSource.getCurrentUser();

  @override
  Stream<UserEntity?> get authStateChanges => _remoteSource.authStateChanges;
}
