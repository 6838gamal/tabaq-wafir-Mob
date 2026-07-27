// lib/features/auth/domain/usecases/sign_in_with_google.dart
import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  Future<AdminUser> call() => _repository.signInWithGoogle();
}
