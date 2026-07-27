// lib/features/auth/data/models/admin_model.dart
import '../../domain/entities/admin_user.dart';

class AdminModel extends AdminUser {
  const AdminModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoUrl,
    super.role,
    super.permissions,
    super.lastLoginAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'admin',
      permissions: List<String>.from(json['permissions'] as List? ?? []),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'permissions': permissions,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory AdminModel.fromEntity(AdminUser user) {
    return AdminModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      role: user.role,
      permissions: user.permissions,
      lastLoginAt: user.lastLoginAt,
    );
  }
}
