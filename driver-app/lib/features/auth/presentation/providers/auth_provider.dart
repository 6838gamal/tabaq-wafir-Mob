// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/driver.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_google.dart';

// Current authenticated driver state
final currentDriverProvider = StateProvider<Driver?>((ref) => null);

// Auth notifier
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, Driver?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<Driver?> {
  late AuthRepository _repository;
  late SignInWithGoogle _signInWithGoogle;

  @override
  Future<Driver?> build() async {
    _repository = ref.read(authRepositoryProvider);
    _signInWithGoogle = SignInWithGoogle(_repository);
    return _repository.getCurrentDriver();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_signInWithGoogle.call);
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(null);
  }

  Future<void> uploadDocument({
    required String documentType,
    required String filePath,
  }) async {
    await _repository.uploadDocument(
      documentType: documentType,
      filePath: filePath,
    );
  }

  Future<String> getVerificationStatus() =>
      _repository.getVerificationStatus();
}
