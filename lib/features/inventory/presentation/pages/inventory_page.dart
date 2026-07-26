import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('inventory.title'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary cards
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6,
            children: [
              KpiCard(title: 'Total Items', value: '342', icon: Icons.inventory_2_outlined, color: AppColors.kpiBlue),
              KpiCard(title: 'Low Stock', value: '14', icon: Icons.warning_amber_outlined, color: AppColors.warning, change: 3, isPositiveChange: false),
              KpiCard(title: 'Out of Stock', value: '3', icon: Icons.remove_shopping_cart, color: AppColors.error),
              KpiCard(title: 'Stock Value', value: 'SAR 48K', icon: Icons.monetization_on_outlined, color: AppColors.kpiGreen),
            ],
          ),
          const SizedBox(height: 20),
          SectionHeader(title: 'Quick Access'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2,
            children: [
              _navCard(context, 'inventory.products'.tr(), Icons.restaurant_menu, AppColors.kpiBlue, AppRoutes.products),
              _navCard(context, 'inventory.stock_count'.tr(), Icons.fact_check_outlined, AppColors.kpiGreen, AppRoutes.stockCount),
              _navCard(context, 'inventory.waste'.tr(), Icons.delete_outline, AppColors.error, AppRoutes.waste),
              _navCard(context, 'inventory.purchases'.tr(), Icons.shopping_cart_outlined, AppColors.kpiPurple, AppRoutes.inventory),
            ],
          ),
          const SizedBox(height: 20),
          SectionHeader(title: 'Low Stock Alert', actionLabel: 'See All', onAction: () {}),
          const SizedBox(height: 12),
          _buildLowStockList(isDark),
          const SizedBox(height: 20),
          SectionHeader(title: 'Recent Stock Movements'),
          const SizedBox(height: 12),
          _buildMovements(isDark),
        ],
      ),
    );
  }

  Widget _navCard(BuildContext context, String label, IconData icon, Color color, String route) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Icon(Icons.chevron_right, size: 16, color: isDark ? AppColors.iconDark : AppColors.iconLight),
        ]),
      ),
    );
  }

  Widget _buildLowStockList(bool isDark) {
    final items = [
      _StockRow('Saffron', '12g', 'g', AppColors.error, 0.12),
      _StockRow('Heavy Cream', '500ml', 'ml', AppColors.error, 0.17),
      _StockRow('Beef Tenderloin', '2kg', 'kg', AppColors.warning, 0.25),
      _StockRow('Cherry Tomatoes', '1.5kg', 'kg', AppColors.warning, 0.38),
      _StockRow('Mozzarella', '800g', 'g', AppColors.warning, 0.4),
    ];
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: items.asMap().entries.map((e) {
        final item = e.value; final isLast = e.key == items.length - 1;
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: item.progress,
                  backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(item.color),
                  minHeight: 3, borderRadius: BorderRadius.circular(2)),
              ])),
              const SizedBox(width: 12),
              StatusBadge(label: item.qty, color: item.color),
            ]),
          ),
          if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ]);
      }).toList()),
    );
  }

  Widget _buildMovements(bool isDark) {
    final movements = [
      _Movement(Icons.arrow_downward, 'Received', 'Beef Tenderloin +5kg', '10:30 AM', AppColors.success),
      _Movement(Icons.arrow_upward, 'Issued', 'Saffron -30g (Kitchen)', '09:15 AM', AppColors.error),
      _Movement(Icons.swap_horiz, 'Transfer', 'Heavy Cream → Branch 2', 'Yesterday', AppColors.info),
      _Movement(Icons.delete_outline, 'Waste', 'Spoiled Tomatoes -2kg', 'Yesterday', AppColors.warning),
    ];
    return Column(children: movements.map((m) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: m.color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(m.icon, color: m.color, size: 16)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(m.description, style: const TextStyle(fontSize: 12)),
        ])),
        Text(m.time, style: TextStyle(fontSize: 11,
            color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
      ]),
    )).toList());
  }
}

class _StockRow { final String name, qty, unit; final Color color; final double progress;
  _StockRow(this.name, this.qty, this.unit, this.color, this.progress); }
class _Movement { final IconData icon; final String label, description, time; final Color color;
  _Movement(this.icon, this.label, this.description, this.time, this.color); }
