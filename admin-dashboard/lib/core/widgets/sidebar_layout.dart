// lib/core/widgets/sidebar_layout.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class SidebarLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const SidebarLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1024;
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: isDesktop ? null : _buildSidebar(context),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(context),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: AppConstants.sidebarWidth,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          _buildLogo(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildNavItems(context),
            ),
          ),
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: AppConstants.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Admin Portal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final sections = _navSections;
    final items = <Widget>[];
    for (final section in sections) {
      if (section.title != null) {
        items.add(_buildSectionHeader(section.title!));
      }
      for (final item in section.items) {
        items.add(_buildNavItem(context, item));
      }
    }
    return items;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textDisabled,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item) {
    final isActive = currentRoute == item.route ||
        currentRoute.startsWith(item.route + '/');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: isActive ? AppColors.sidebarItemActiveBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          item.icon,
          size: 20,
          color: isActive ? AppColors.sidebarItemActive : AppColors.sidebarItem,
        ),
        title: Text(
          item.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color:
                isActive ? AppColors.sidebarItemActive : AppColors.sidebarItem,
          ),
        ),
        onTap: () {
          if (Scaffold.of(context).isDrawerOpen) {
            Navigator.of(context).pop();
          }
          context.go(item.route);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      child: _buildNavItem(
        context,
        const _NavItem(
          label: 'Settings',
          icon: Icons.settings_outlined,
          route: '/settings',
        ),
      ),
    );
  }

  static List<_NavSection> get _navSections => [
        const _NavSection(
          title: 'Overview',
          items: [
            _NavItem(
                label: 'Dashboard',
                icon: Icons.dashboard_outlined,
                route: '/dashboard'),
            _NavItem(
                label: 'Analytics',
                icon: Icons.bar_chart_outlined,
                route: '/analytics'),
          ],
        ),
        const _NavSection(
          title: 'Business',
          items: [
            _NavItem(
                label: 'Restaurants',
                icon: Icons.store_outlined,
                route: '/restaurants'),
            _NavItem(
                label: 'Customers',
                icon: Icons.people_outline,
                route: '/customers'),
            _NavItem(
                label: 'Drivers',
                icon: Icons.delivery_dining_outlined,
                route: '/drivers'),
          ],
        ),
        const _NavSection(
          title: 'Finance',
          items: [
            _NavItem(
                label: 'Subscriptions',
                icon: Icons.subscriptions_outlined,
                route: '/subscriptions'),
            _NavItem(
                label: 'Plans',
                icon: Icons.layers_outlined,
                route: '/plans'),
            _NavItem(
                label: 'Payments',
                icon: Icons.payment_outlined,
                route: '/payments'),
            _NavItem(
                label: 'Commissions',
                icon: Icons.percent_outlined,
                route: '/commissions'),
            _NavItem(
                label: 'Coupons',
                icon: Icons.local_offer_outlined,
                route: '/coupons'),
          ],
        ),
        const _NavSection(
          title: 'Operations',
          items: [
            _NavItem(
                label: 'Cities',
                icon: Icons.location_city_outlined,
                route: '/cities'),
            _NavItem(
                label: 'Delivery Zones',
                icon: Icons.map_outlined,
                route: '/delivery-zones'),
            _NavItem(
                label: 'Ads',
                icon: Icons.campaign_outlined,
                route: '/ads'),
          ],
        ),
        const _NavSection(
          title: 'Support',
          items: [
            _NavItem(
                label: 'Complaints',
                icon: Icons.report_outlined,
                route: '/complaints'),
            _NavItem(
                label: 'Support Tickets',
                icon: Icons.support_agent_outlined,
                route: '/support'),
          ],
        ),
        const _NavSection(
          title: 'System',
          items: [
            _NavItem(
                label: 'AI Monitoring',
                icon: Icons.psychology_outlined,
                route: '/ai-monitoring'),
            _NavItem(
                label: 'Audit Logs',
                icon: Icons.history_outlined,
                route: '/audit-logs'),
          ],
        ),
      ];
}

class _NavSection {
  final String? title;
  final List<_NavItem> items;
  const _NavSection({this.title, required this.items});
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem(
      {required this.label, required this.icon, required this.route});
}

class AdminScaffold extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget body;
  final List<Widget>? actions;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1024;
    return SidebarLayout(
      currentRoute: currentRoute,
      child: Column(
        children: [
          _buildTopBar(context, isDesktop),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDesktop) {
    return Container(
      height: AppConstants.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (!isDesktop)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (actions != null) ...actions!,
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
