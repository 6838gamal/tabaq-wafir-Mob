import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/rbac/user_role.dart';
import '../../../../core/rbac/rbac_provider.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, sessionExpired, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final Ref _ref;

  AuthNotifier(this._repo, this._ref) : super(const AuthState());

  Future<void> checkSession() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repo.restoreSession();
      if (user != null) {
        _applyUser(user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repo.signInWithGoogle();
      if (user != null) {
        _applyUser(user);
        return true;
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> signInAsDemo(UserRole role) async {
    state = state.copyWith(status: AuthStatus.loading);
    final user = await _repo.signInAsDemo(role);
    if (user != null) _applyUser(user);
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void markSessionExpired() {
    state = state.copyWith(status: AuthStatus.sessionExpired);
  }

  /// Called from SplashPage when checkSession times out or throws,
  /// so the router redirect can fire and leave the splash screen.
  void forceUnauthenticated() {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  void _applyUser(UserModel user) {
    // Sync role into RBAC provider
    _ref.read(currentRoleProvider.notifier).state = user.role;
    // Sync locale-compat layer
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider), ref);
});

// Convenience selectors
final currentUserProvider = Provider<UserModel?>((ref) => ref.watch(authProvider).user);
final isAuthenticatedProvider = Provider<bool>((ref) => ref.watch(authProvider).isAuthenticated);
