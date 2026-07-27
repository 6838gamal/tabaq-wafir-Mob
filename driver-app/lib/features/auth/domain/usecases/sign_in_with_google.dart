// lib/features/auth/domain/usecases/sign_in_with_google.dart
import '../entities/driver.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  Future<Driver> call() => _repository.signInWithGoogle();
}
