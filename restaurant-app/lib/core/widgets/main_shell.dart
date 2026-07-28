import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../l10n/app_l10n.dart';
import '../rbac/user_role.dart';
import '../rbac/rbac_provider.dart';
import '../theme/app_colors.dart';
import '../router/app_router.dart';
import 'role_nav_config.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/branches/presentation/providers/branch_provider.dart';
import '../../features/branches/data/models/branch_model.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return isDesktop
        ? _DesktopLayout(child: child)
        : _MobileLayout(child: child);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop — permanent side rail
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopLayout extends ConsumerWidget {
  final Widget child;
  const _DesktopLayout({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          _SideBar(permanent: true),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile — hamburger drawer
// ─────────────────────────────────────────────────────────────────────────────
class _MobileLayout extends ConsumerWidget {
  final Widget child;
  const _MobileLayout({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: Drawer(
        width: 280,
        child: _SideBar(permanent: false),
      ),
      body: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared sidebar contents
// ─────────────────────────────────────────────────────────────────────────────
class _SideBar extends ConsumerWidget {
  final bool permanent;
  const _SideBar({required this.permanent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final groups = roleNavConfig[role] ?? [];
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final location = GoRouterState.of(context).uri.toString();

    final bg = isDark ? AppColors.surfaceDark : Colors.white;
    final width = permanent ? 240.0 : double.infinity;

    return Container(
      width: width,
      color: bg,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _SideBarHeader(user: user, role: role, ref: ref),
            const Divider(height: 1),

            // Branch selector
            _BranchSelector(),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Nav items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  for (final group in groups) ...[
                    if (group.groupLabel != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          group.groupLabel!.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 0.8,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    for (final item in group.items)
                      _NavTile(
                        item: item,
                        isActive: location.startsWith(item.route),
                        onTap: () {
                          if (!permanent) Navigator.of(context).pop();
                          context.go(item.route);
                        },
                      ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            _QuickToggles(),

            // Sign out
            _SignOutTile(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SideBarHeader extends StatelessWidget {
  final dynamic user;
  final UserRole role;
  final WidgetRef ref;
  const _SideBarHeader({this.user, required this.role, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = user?.name ?? 'User';
    final email = user?.email ?? '';
    final photo = user?.photoUrl as String?;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withOpacity(0.15),
            backgroundImage: (photo != null && photo.isNotEmpty)
                ? NetworkImage(photo)
                : null,
            child: (photo == null || photo.isEmpty)
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    role.displayName,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branches = ref.watch(userBranchesProvider);
    final selected = ref.watch(selectedBranchProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (branches.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DropdownButtonFormField<BranchModel?>(
        value: selected,
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          isDense: true,
          prefixIcon: const Icon(Icons.store_outlined, size: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
        hint: Text(l10n.branchAllBranches,
            style: theme.textTheme.bodySmall),
        items: [
          DropdownMenuItem<BranchModel?>(
            value: null,
            child: Text(l10n.branchAllBranches,
                style: const TextStyle(fontSize: 13)),
          ),
          ...branches.map((b) => DropdownMenuItem<BranchModel?>(
                value: b,
                child: Text(b.name, style: const TextStyle(fontSize: 13)),
              )),
        ],
        onChanged: (b) => ref.read(selectedBranchProvider.notifier).select(b),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = context.l10n;

    // Resolve label from ARB key
    final label = _resolveLabel(l10n, item.labelKey);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: isActive
            ? AppColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 20,
                  color: isActive
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.iconDark
                          : AppColors.iconLight),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _resolveLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'navDashboard':      return l10n.navDashboard;
      case 'navCopilot':        return l10n.navCopilot;
      case 'navOrders':         return l10n.navOrders;
      case 'navInventory':      return l10n.navInventory;
      case 'navEmployees':      return l10n.navEmployees;
      case 'navAccounting':     return l10n.navAccounting;
      case 'navReports':        return l10n.navReports;
      case 'navCustomers':      return l10n.navCustomers;
      case 'navSettings':       return l10n.navSettings;
      case 'navAiAssistant':    return l10n.navAiAssistant;
      case 'navAlerts':         return l10n.navAlerts;
      case 'navNotifications':  return l10n.navNotifications;
      case 'navBranches':       return l10n.navBranches;
      case 'navSuppliers':      return l10n.navSuppliers;
      case 'navPurchases':      return l10n.navPurchases;
      case 'navAnalytics':      return l10n.navAnalytics;
      case 'navAuditLogs':      return l10n.navAuditLogs;
      case 'navTodaysTasks':    return l10n.navTodaysTasks;
      case 'navAttendance':     return l10n.navAttendance;
      case 'navPos':            return l10n.navPos;
      case 'navRefunds':        return l10n.navRefunds;
      case 'navTransfers':      return l10n.navTransfers;
      case 'navExpiry':         return l10n.navExpiry;
      case 'navExpenses':       return l10n.navExpenses;
      case 'navInvoices':       return l10n.navInvoices;
      case 'navPayments':       return l10n.navPayments;
      case 'navProfit':         return l10n.navProfit;
      case 'navTables':         return l10n.navTables;
      case 'navKitchenOrders':  return l10n.navKitchenOrders;
      case 'navReadyOrders':    return l10n.navReadyOrders;
      case 'navInventoryAlerts':return l10n.navInventoryAlerts;
      case 'navWaste':          return l10n.navWaste;
      case 'navStockCount':     return l10n.navStockCount;
      case 'navKitchen':        return l10n.navKitchen;
      case 'navReservations':   return l10n.navReservations;
      default:                  return key;
    }
  }
}

class _SignOutTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _confirmSignOut(context, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.logout, size: 20, color: AppColors.error),
                const SizedBox(width: 12),
                Text(l10n.settingsLogout,
                    style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsLogout),
        content: Text(l10n.settingsLogoutConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.commonCancel)),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(l10n.settingsLogout)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) context.go(AppRoutes.login);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick language + theme toggles — sidebar footer
// ─────────────────────────────────────────────────────────────────────────────
class _QuickToggles extends ConsumerWidget {
  const _QuickToggles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale   = ref.watch(localeModeProvider);
    final cs       = Theme.of(context).colorScheme;
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final pillBg   = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.black.withOpacity(0.06);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Row(
        children: [
          // Language pill EN / ع
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: ['en', 'ar'].map((lang) {
                  final selected = locale.languageCode == lang;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(localeModeProvider.notifier).setLocale(lang),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: selected ? cs.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          lang == 'en' ? 'EN' : 'ع',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? cs.onPrimary
                                : (isDark ? Colors.white70 : Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Theme toggle
          GestureDetector(
            onTap: () => ref.read(themeModeProvider.notifier).setTheme(
                  themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                ),
            child: Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(
                isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                size: 18,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
