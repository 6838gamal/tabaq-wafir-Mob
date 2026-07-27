import 'package:restaurant_customer_app/features/auth/domain/entities/user.dart';
import 'package:restaurant_customer_app/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  Future<UserEntity> call() {
    return _repository.signInWithGoogle();
  }
}
