import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_l10n.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'dashboard.good_morning';
    if (hour < 17) return 'dashboard.good_afternoon';
    return 'dashboard.good_evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme, isDark),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildQuickAlerts(context, isDark),
                const SizedBox(height: 20),
                _buildKpiGrid(context),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'dashboard.sales_overview'.tr(),
                  actionLabel: 'common.this_week'.tr(),
                ),
                const SizedBox(height: 12),
                _buildSalesChart(context, isDark),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'dashboard.top_items'.tr(),
                  actionLabel: 'common.see_all'.tr(),
                  onAction: () => context.go(AppRoutes.reports),
                ),
                const SizedBox(height: 12),
                _buildTopItems(context, isDark),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'dashboard.recent_orders'.tr(),
                  actionLabel: 'common.see_all'.tr(),
                  onAction: () => context.go(AppRoutes.orders),
                ),
                const SizedBox(height: 12),
                _buildRecentOrders(context, isDark),
                const SizedBox(height: 20),
                SectionHeader(title: 'dashboard.quick_actions'.tr()),
                const SizedBox(height: 12),
                _buildQuickActions(context),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme, bool isDark) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_greeting().tr(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              )),
          Text('Ahmed Al-Rashidi',
              style: theme.textTheme.titleMedium),
        ],
      ),
      actions: [
        IconButton(
          icon: Stack(children: [
            const Icon(Icons.notifications_outlined),
            Positioned(top: 0, right: 0,
              child: Container(width: 8, height: 8,
                decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle))),
          ]),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        IconButton(
          icon: const Icon(Icons.auto_awesome_outlined),
          color: AppColors.primary,
          onPressed: () => context.go(AppRoutes.copilot),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildQuickAlerts(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '3 items are running low on stock · 2 delayed orders',
              style: TextStyle(fontSize: 12, color: AppColors.error.withOpacity(0.9), fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.alerts),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('View', style: TextStyle(fontSize: 12, color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        KpiCard(
          title: 'dashboard.today_sales'.tr(),
          value: 'SAR 18,540',
          icon: Icons.trending_up,
          color: AppColors.kpiBlue,
          change: 12.4,
          isPositiveChange: true,
          subtitle: 'dashboard.vs_yesterday'.tr(),
        ),
        KpiCard(
          title: 'dashboard.total_orders'.tr(),
          value: '247',
          icon: Icons.receipt_long_outlined,
          color: AppColors.kpiGreen,
          change: 8.1,
          isPositiveChange: true,
          subtitle: 'dashboard.vs_yesterday'.tr(),
        ),
        KpiCard(
          title: 'dashboard.avg_order'.tr(),
          value: 'SAR 75',
          icon: Icons.shopping_bag_outlined,
          color: AppColors.kpiPurple,
          change: 3.2,
          isPositiveChange: false,
          subtitle: 'dashboard.vs_yesterday'.tr(),
        ),
        KpiCard(
          title: 'dashboard.active_tables'.tr(),
          value: '18 / 32',
          icon: Icons.table_restaurant_outlined,
          color: AppColors.kpiOrange,
          subtitle: '14 available',
        ),
      ],
    );
  }

  Widget _buildSalesChart(BuildContext context, bool isDark) {
    final spots = [
      const FlSpot(0, 8200),
      const FlSpot(1, 12000),
      const FlSpot(2, 9800),
      const FlSpot(3, 15400),
      const FlSpot(4, 11200),
      const FlSpot(5, 18540),
      const FlSpot(6, 14300),
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= days.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(days[i], style: TextStyle(fontSize: 11,
                        color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.15), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopItems(BuildContext context, bool isDark) {
    final items = [
      _TopItem('Grilled Chicken', 87, 0.87, AppColors.kpiGreen),
      _TopItem('Beef Burger', 72, 0.72, AppColors.kpiBlue),
      _TopItem('Caesar Salad', 65, 0.65, AppColors.kpiPurple),
      _TopItem('Pasta Carbonara', 58, 0.58, AppColors.kpiOrange),
      _TopItem('Chocolate Lava', 54, 0.54, AppColors.kpiRed),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text('${items.indexOf(item) + 1}',
                    style: TextStyle(fontWeight: FontWeight.w700, color: item.color, fontSize: 13)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: item.progress,
                      backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                      valueColor: AlwaysStoppedAnimation<Color>(item.color),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('${item.count}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context, bool isDark) {
    final orders = [
      _OrderItem('#1247', 'Table 5', 'Dine-in', 'SAR 185', 'Preparing', AppColors.kpiOrange),
      _OrderItem('#1246', 'Delivery', 'Ahmed K.', 'SAR 92', 'Ready', AppColors.kpiGreen),
      _OrderItem('#1245', 'Table 12', 'Dine-in', 'SAR 340', 'Served', AppColors.kpiBlue),
      _OrderItem('#1244', 'Pickup', 'Walk-in', 'SAR 67', 'Completed', AppColors.textSecondaryLight),
    ];
    return Column(
      children: orders.map((o) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(o.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(o.sub, style: TextStyle(fontSize: 11,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            ]),
            const SizedBox(width: 12),
            Expanded(child: Text(o.label, style: const TextStyle(fontSize: 12))),
            const SizedBox(width: 8),
            Text(o.amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 12),
            StatusBadge(label: o.status, color: o.statusColor),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(Icons.add_circle_outline, 'New Order', AppRoutes.orders, AppColors.kpiBlue),
      _QuickAction(Icons.kitchen_outlined, 'Kitchen', AppRoutes.kitchen, AppColors.kpiOrange),
      _QuickAction(Icons.inventory_2_outlined, 'Stock', AppRoutes.inventory, AppColors.kpiGreen),
      _QuickAction(Icons.people_outline, 'Staff', AppRoutes.employees, AppColors.kpiPurple),
      _QuickAction(Icons.bar_chart_outlined, 'Reports', AppRoutes.reports, AppColors.kpiTeal),
      _QuickAction(Icons.smart_toy_outlined, 'AI Chat', AppRoutes.aiAssistant, AppColors.kpiRed),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.2,
      children: actions.map((a) => GestureDetector(
        onTap: () => context.go(a.route),
        child: Container(
          decoration: BoxDecoration(
            color: a.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: a.color.withOpacity(0.2)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(a.icon, color: a.color, size: 24),
            const SizedBox(height: 8),
            Text(a.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: a.color)),
          ]),
        ),
      )).toList(),
    );
  }
}

class _TopItem {
  final String name; final int count; final double progress; final Color color;
  _TopItem(this.name, this.count, this.progress, this.color);
}

class _OrderItem {
  final String id, sub, label, amount, status; final Color statusColor;
  _OrderItem(this.id, this.sub, this.label, this.amount, this.status, this.statusColor);
}

class _QuickAction {
  final IconData icon; final String label, route; final Color color;
  _QuickAction(this.icon, this.label, this.route, this.color);
}
