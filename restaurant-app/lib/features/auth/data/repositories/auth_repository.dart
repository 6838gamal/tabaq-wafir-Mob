import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/rbac/user_role.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInAsDemo(UserRole role);
  Future<void> signOut();
  Future<UserModel?> restoreSession();
}

class AuthRepositoryImpl implements AuthRepository {
  final TokenManager _tokenManager;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInitialized = false;

  AuthRepositoryImpl(this._tokenManager);

  @override
  Future<UserModel?> signInWithGoogle() async {
    // ── Mock mode ────────────────────────────────────────────────────────────
    // When no real Web Client ID is configured we return a mock Google user
    // immediately so the UI flow can be tested end-to-end without OAuth setup.
    if (AppConstants.googleClientId.isEmpty) {
      return _signInWithMockGoogle();
    }

    // ── Real Google Sign-In ───────────────────────────────────────────────────
    try {
      if (!_googleInitialized) {
        await _googleSignIn.initialize(clientId: AppConstants.googleClientId);
        _googleInitialized = true;
      }

      final account = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      final auth = await account.authentication;
      final token = auth.idToken ?? '';

      await _tokenManager.saveTokens(accessToken: token);

      final user = UserModel(
        id: account.id,
        name: account.displayName ?? account.email,
        email: account.email,
        photoUrl: account.photoUrl,
        role: await _loadSavedRole() ?? UserRole.owner,
        branchIds: ['branch_1'],
        lastLogin: DateTime.now(),
      );

      await _persistUser(user);
      return user;
    } catch (_) {
      rethrow;
    }
  }

  /// Returns a mock Google user — used when [AppConstants.googleClientId] is
  /// empty (development / demo environment).
  Future<UserModel?> _signInWithMockGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network
    const mockToken = 'mock_google_token_dev';
    await _tokenManager.saveTokens(accessToken: mockToken);

    final user = UserModel(
      id: 'google_mock_001',
      name: 'Demo Manager',
      email: 'demo@restaurantcopilot.app',
      photoUrl: null,
      role: await _loadSavedRole() ?? UserRole.owner,
      branchIds: ['branch_1'],
      lastLogin: DateTime.now(),
    );

    await _persistUser(user);
    return user;
  }

  @override
  Future<UserModel?> signInAsDemo(UserRole role) async {
    final user = UserModel.demo(role: role);
    await _tokenManager.saveTokens(accessToken: 'demo_token_${role.name}');
    await _persistUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _tokenManager.clearAll();
  }

  @override
  Future<UserModel?> restoreSession() async {
    final hasSession = await _tokenManager.hasValidSession();
    if (!hasSession) return null;

    final id = await _tokenManager.getUserData(AppConstants.userIdKey);
    final name = await _tokenManager.getUserData(AppConstants.userNameKey);
    final email = await _tokenManager.getUserData(AppConstants.userEmailKey);
    final photo = await _tokenManager.getUserData(AppConstants.userPhotoKey);
    final roleStr = await _tokenManager.getUserData(AppConstants.userRoleKey);
    final lastLoginStr = await _tokenManager.getUserData(AppConstants.lastLoginKey);

    if (id == null || name == null || email == null) return null;

    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: photo,
      role: UserRole.fromString(roleStr ?? 'owner'),
      branchIds: ['branch_1'],
      lastLogin: lastLoginStr != null
          ? DateTime.tryParse(lastLoginStr) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Future<void> _persistUser(UserModel user) async {
    await _tokenManager.saveUserData({
      AppConstants.userIdKey: user.id,
      AppConstants.userNameKey: user.name,
      AppConstants.userEmailKey: user.email,
      AppConstants.userPhotoKey: user.photoUrl ?? '',
      AppConstants.userRoleKey: user.role.name,
      AppConstants.lastLoginKey: user.lastLogin.toIso8601String(),
    });
  }

  Future<UserRole?> _loadSavedRole() async {
    final roleStr = await _tokenManager.getUserData(AppConstants.userRoleKey);
    if (roleStr == null) return null;
    return UserRole.fromString(roleStr);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(tokenManagerProvider));
});
