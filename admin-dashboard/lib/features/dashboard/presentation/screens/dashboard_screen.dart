import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/sidebar_layout.dart';
import '../../../../core/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Dashboard',
      currentRoute: '/dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LayoutBuilder(builder: (ctx, constraints) {
            final cols = constraints.maxWidth > 900 ? 4 : constraints.maxWidth > 600 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: const [
                StatCard(title: 'Active Restaurants', value: '248', icon: Icons.store_outlined, changePercent: 8.4, subtitle: 'this month'),
                StatCard(title: 'Monthly Revenue', value: '184,620 SAR', icon: Icons.trending_up, iconColor: AppColors.success, changePercent: 8.4),
                StatCard(title: 'Active Drivers', value: '1,426', icon: Icons.delivery_dining_outlined, iconColor: AppColors.info, changePercent: 5.1),
                StatCard(title: 'Open Complaints', value: '18', icon: Icons.support_outlined, iconColor: AppColors.warning, changePercent: 12.5, isPositiveChange: false),
                StatCard(title: 'Orders Today', value: '12,840', icon: Icons.receipt_long_outlined, changePercent: 14.2),
                StatCard(title: 'New Customers', value: '284', icon: Icons.people_outline, iconColor: AppColors.success, changePercent: 22.0),
                StatCard(title: 'AI Alerts', value: '7', icon: Icons.psychology_outlined, iconColor: Colors.purple, subtitle: 'Needs review'),
                StatCard(title: 'Pending Approvals', value: '5', icon: Icons.pending_actions_outlined, iconColor: AppColors.warning, subtitle: 'Restaurants'),
              ],
            );
          }),
          const SizedBox(height: 28),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 2, child: _RecentOrders()),
            const SizedBox(width: 16),
            Expanded(child: _QuickLinks(context)),
          ]),
        ]),
      ),
    );
  }
}

class _RecentOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Recent Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('View all')),
          ]),
          const SizedBox(height: 8),
          for (final o in [
            ('ORD-12840', 'Burger District', 'Delivering', '122 SAR'),
            ('ORD-12839', 'Mina Kitchen', 'Preparing', '78 SAR'),
            ('ORD-12838', 'Green Bowl', 'Delivered', '56 SAR'),
            ('ORD-12837', 'Pizza Palace', 'Cancelled', '95 SAR'),
            ('ORD-12836', 'Sushi Corner', 'Delivered', '145 SAR'),
          ]) ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(o.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text(o.$2),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              _StatusChip(o.$3),
              const SizedBox(width: 8),
              Text(o.$4, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  final BuildContext ctx;
  const _QuickLinks(this.ctx);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          for (final l in [
            ('Pending Approvals', '/restaurants', Icons.pending_actions_outlined),
            ('New Complaints', '/complaints', Icons.report_outlined),
            ('AI Monitoring', '/ai-monitoring', Icons.psychology_outlined),
            ('Audit Logs', '/audit-logs', Icons.history_outlined),
            ('Analytics', '/analytics', Icons.bar_chart_outlined),
          ]) ListTile(
            dense: true,
            leading: Icon(l.$3, size: 20, color: AppColors.primary),
            title: Text(l.$1, style: const TextStyle(fontSize: 13)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.textSecondary),
            onTap: () => context.go(l.$2),
          ),
        ]),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);
  Color get _color {
    switch (status) {
      case 'Delivering': return AppColors.info;
      case 'Preparing': return AppColors.warning;
      case 'Delivered': return AppColors.success;
      case 'Cancelled': return AppColors.error;
      default: return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
    child: Text(status, style: TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.w600)),
  );
}
