import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_role.dart';
import 'permissions.dart';

final currentRoleProvider = StateProvider<UserRole>((ref) => UserRole.owner);

final userPermissionsProvider = Provider<Set<Permission>>((ref) {
  final role = ref.watch(currentRoleProvider);
  return role.permissions;
});

extension PermissionRef on WidgetRef {
  bool can(Permission permission) => read(userPermissionsProvider).contains(permission);
  UserRole get role => read(currentRoleProvider);
}
