import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_customer_app/core/services/auth_service.dart';
import 'package:restaurant_customer_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_customer_app/features/auth/data/sources/auth_remote_source.dart';
import 'package:restaurant_customer_app/features/auth/domain/entities/user.dart';
import 'package:restaurant_customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurant_customer_app/features/auth/domain/usecases/sign_in_as_guest.dart';
import 'package:restaurant_customer_app/features/auth/domain/usecases/sign_in_with_google.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSourceImpl(ref.watch(authServiceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteSourceProvider));
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  return SignInWithGoogle(ref.watch(authRepositoryProvider));
});

final signInAsGuestProvider = Provider<SignInAsGuest>((ref) {
  return SignInAsGuest(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    return ref.watch(authRepositoryProvider).getCurrentUser();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref.read(signInWithGoogleProvider).call();
    });
  }

  Future<void> signInAsGuest() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref.read(signInAsGuestProvider).call();
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(() => AuthNotifier());
