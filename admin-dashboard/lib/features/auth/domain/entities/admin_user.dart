// lib/features/auth/domain/entities/admin_user.dart
import 'package:equatable/equatable.dart';

class AdminUser extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String role;
  final List<String> permissions;
  final DateTime? lastLoginAt;

  const AdminUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.role = 'admin',
    this.permissions = const [],
    this.lastLoginAt,
  });

  bool get isSuperAdmin => role == 'super_admin';

  bool hasPermission(String permission) =>
      isSuperAdmin || permissions.contains(permission);

  AdminUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? role,
    List<String>? permissions,
    DateTime? lastLoginAt,
  }) {
    return AdminUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props =>
      [uid, email, displayName, photoUrl, role, permissions, lastLoginAt];
}
