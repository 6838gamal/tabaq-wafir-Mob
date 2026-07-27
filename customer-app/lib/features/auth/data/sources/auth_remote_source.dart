import 'package:restaurant_customer_app/core/services/auth_service.dart';
import 'package:restaurant_customer_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInAsGuest();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final AuthService _authService;

  AuthRemoteSourceImpl(this._authService);

  @override
  Future<UserModel> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    final fbUser = credential.user!;
    return UserModel(
      id: fbUser.uid,
      name: fbUser.displayName,
      email: fbUser.email,
      photoUrl: fbUser.photoURL,
      isGuest: false,
      createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  @override
  Future<UserModel> signInAsGuest() async {
    final credential = await _authService.signInAsGuest();
    final fbUser = credential.user!;
    return UserModel(
      id: fbUser.uid,
      isGuest: true,
      createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _authService.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      isGuest: user.isAnonymous,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      if (user == null) return null;
      return UserModel(
        id: user.uid,
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
        isGuest: user.isAnonymous,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    });
  }
}
