import '../../../../core/rbac/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final UserRole role;
  final List<String> branchIds;
  final DateTime lastLogin;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    this.branchIds = const [],
    required this.lastLogin,
    this.isActive = true,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    UserRole? role,
    List<String>? branchIds,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      branchIds: branchIds ?? this.branchIds,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'role': role.name,
    'branchIds': branchIds,
    'lastLogin': lastLogin.toIso8601String(),
    'isActive': isActive,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    photoUrl: json['photoUrl'] as String?,
    role: UserRole.fromString(json['role'] as String? ?? 'owner'),
    branchIds: (json['branchIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    lastLogin: json['lastLogin'] != null
        ? DateTime.parse(json['lastLogin'] as String)
        : DateTime.now(),
    isActive: json['isActive'] as bool? ?? true,
  );

  /// Demo user for testing without a backend.
  factory UserModel.demo({UserRole role = UserRole.owner}) => UserModel(
    id: 'demo_${role.name}',
    name: 'Demo ${role.displayName}',
    email: 'demo@restaurantcopilot.com',
    photoUrl: null,
    role: role,
    branchIds: ['branch_1', 'branch_2'],
    lastLogin: DateTime.now(),
    isActive: true,
  );
}
