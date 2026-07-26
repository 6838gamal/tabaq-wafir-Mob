import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _navItems = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, labelKey: 'nav.dashboard', route: AppRoutes.dashboard),
    _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, labelKey: 'nav.copilot', route: AppRoutes.copilot),
    _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, labelKey: 'nav.orders', route: AppRoutes.orders),
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, labelKey: 'nav.inventory', route: AppRoutes.inventory),
    _NavItem(icon: Icons.more_horiz, activeIcon: Icons.more_horiz, labelKey: 'common.all', route: AppRoutes.settings),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.copilot)) return 1;
    if (location.startsWith(AppRoutes.orders) || location.startsWith(AppRoutes.kitchen)) return 2;
    if (location.startsWith(AppRoutes.inventory)) return 3;
    if (location.startsWith(AppRoutes.settings) || location.startsWith(AppRoutes.employees) ||
        location.startsWith(AppRoutes.accounting) || location.startsWith(AppRoutes.reports) ||
        location.startsWith(AppRoutes.customers) || location.startsWith(AppRoutes.reservations)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isSelected = selectedIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => context.go(item.route),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 22,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.iconDark : AppColors.iconLight),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.labelKey.tr(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.iconDark : AppColors.iconLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String labelKey;
  final String route;
  const _NavItem({required this.icon, required this.activeIcon, required this.labelKey, required this.route});
}
