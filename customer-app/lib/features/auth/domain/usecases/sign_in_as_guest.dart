import 'package:restaurant_customer_app/features/auth/domain/entities/user.dart';
import 'package:restaurant_customer_app/features/auth/domain/repositories/auth_repository.dart';

class SignInAsGuest {
  final AuthRepository _repository;

  SignInAsGuest(this._repository);

  Future<UserEntity> call() {
    return _repository.signInAsGuest();
  }
}
