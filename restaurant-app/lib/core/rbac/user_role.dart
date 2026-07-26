enum UserRole {
  owner,
  generalManager,
  branchManager,
  supervisor,
  cashier,
  kitchen,
  waiter,
  inventoryManager,
  accountant;

  String get displayKey {
    switch (this) {
      case UserRole.owner:            return 'roles.owner';
      case UserRole.generalManager:   return 'roles.general_manager';
      case UserRole.branchManager:    return 'roles.branch_manager';
      case UserRole.supervisor:       return 'roles.supervisor';
      case UserRole.cashier:          return 'roles.cashier';
      case UserRole.kitchen:          return 'roles.kitchen';
      case UserRole.waiter:           return 'roles.waiter';
      case UserRole.inventoryManager: return 'roles.inventory_manager';
      case UserRole.accountant:       return 'roles.accountant';
    }
  }

  /// Fallback display name (English) for contexts without a BuildContext.
  String get displayName {
    switch (this) {
      case UserRole.owner:            return 'Owner';
      case UserRole.generalManager:   return 'General Manager';
      case UserRole.branchManager:    return 'Branch Manager';
      case UserRole.supervisor:       return 'Supervisor';
      case UserRole.cashier:          return 'Cashier';
      case UserRole.kitchen:          return 'Kitchen';
      case UserRole.waiter:           return 'Waiter';
      case UserRole.inventoryManager: return 'Inventory Manager';
      case UserRole.accountant:       return 'Accountant';
    }
  }

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (r) => r.name == value,
      orElse: () => UserRole.owner,
    );
  }
}
