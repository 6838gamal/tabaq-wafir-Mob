import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../theme/app_colors.dart';
import '../../l10n/app_l10n.dart';
import '../providers/settings_provider.dart';

// ── Nav item model ────────────────────────────────────────────────────────────
class _NavItem {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String Function(AppLocalizations) label;
  const _NavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

final _navItems = <_NavItem>[
  _NavItem(
    route: '/home',
    icon: Icons.delivery_dining_outlined,
    activeIcon: Icons.delivery_dining,
    label: (l) => l.navDeliveries,
  ),
  _NavItem(
    route: '/earnings',
    icon: Icons.account_balance_wallet_outlined,
    activeIcon: Icons.account_balance_wallet,
    label: (l) => l.navEarnings,
  ),
  _NavItem(
    route: '/history',
    icon: Icons.history,
    activeIcon: Icons.history,
    label: (l) => l.navHistory,
  ),
  _NavItem(
    route: '/support',
    icon: Icons.support_agent_outlined,
    activeIcon: Icons.support_agent,
    label: (l) => l.navSupport,
  ),
];

// ── Shell ─────────────────────────────────────────────────────────────────────
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

// ── Desktop: permanent sidebar ────────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final Widget child;
  const _DesktopLayout({required this.child});

  @override
  Widget build(BuildContext context) {
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

// ── Mobile: drawer + bottom nav ───────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final Widget child;
  const _MobileLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final l10n = context.l10n;
    final selectedIndex = _navItems.indexWhere(
      (item) => location.startsWith(item.route),
    );

    return Scaffold(
      drawer: Drawer(
        width: 280,
        child: _SideBar(permanent: false),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (i) => context.go(_navItems[i].route),
        destinations: _navItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.activeIcon),
                  label: item.label(l10n),
                ))
            .toList(),
      ),
    );
  }
}

// ── Shared sidebar ────────────────────────────────────────────────────────────
class _SideBar extends ConsumerWidget {
  final bool permanent;
  const _SideBar({required this.permanent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delivery_dining,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.appName,
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        Text(l10n.tagline,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Nav items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: _navItems.map((item) {
                  final isActive = location.startsWith(item.route);
                  return _NavTile(
                    item: item,
                    isActive: isActive,
                    label: item.label(l10n),
                    onTap: () {
                      if (!permanent) Navigator.of(context).pop();
                      context.go(item.route);
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1),
            _QuickToggles(),

            // Profile & Settings
            _NavTile(
              item: _NavItem(
                route: '/settings',
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: (l) => l.navSettings,
              ),
              isActive: location.startsWith('/settings'),
              label: l10n.navSettings,
              onTap: () {
                if (!permanent) Navigator.of(context).pop();
                context.go('/settings');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final String label;
  final VoidCallback onTap;
  const _NavTile({
    required this.item,
    required this.isActive,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      : (isDark ? AppColors.iconDark : AppColors.iconLight),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
