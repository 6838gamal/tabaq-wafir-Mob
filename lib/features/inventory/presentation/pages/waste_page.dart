import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class WastePage extends StatelessWidget {
  const WastePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('inventory.waste'.tr()),
        actions: [
          TextButton.icon(
            onPressed: () => _showLogWasteSheet(context),
            icon: const Icon(Icons.add, size: 16),
            label: Text('inventory.log_waste'.tr()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
            children: [
              KpiCard(title: 'Today\'s Waste', value: 'SAR 310', icon: Icons.delete_outline, color: AppColors.error, change: 8, isPositiveChange: false),
              KpiCard(title: 'Waste %', value: '3.2%', icon: Icons.percent, color: AppColors.warning),
              KpiCard(title: 'This Week', value: 'SAR 1,840', icon: Icons.calendar_today_outlined, color: AppColors.kpiOrange),
              KpiCard(title: 'Top Wasted', value: 'Tomatoes', icon: Icons.eco, color: AppColors.kpiGreen),
            ],
          ),
          const SizedBox(height: 20),
          SectionHeader(title: 'Waste by Category'),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: PieChart(PieChartData(
              sections: [
                PieChartSectionData(value: 35, color: AppColors.kpiRed, title: 'Produce', titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                PieChartSectionData(value: 25, color: AppColors.kpiOrange, title: 'Meat', titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                PieChartSectionData(value: 20, color: AppColors.kpiBlue, title: 'Dairy', titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                PieChartSectionData(value: 12, color: AppColors.kpiPurple, title: 'Bread', titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                PieChartSectionData(value: 8, color: AppColors.kpiTeal, title: 'Other', titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            )),
          ),
          const SizedBox(height: 20),
          SectionHeader(title: 'Recent Waste Logs'),
          const SizedBox(height: 12),
          _buildWasteLogs(isDark),
        ],
      ),
    );
  }

  Widget _buildWasteLogs(bool isDark) {
    final logs = [
      _WasteLog('Cherry Tomatoes', '2kg', 'Spoiled', 'Kitchen', AppColors.error, '09:30 AM'),
      _WasteLog('Bread Rolls', '12 pcs', 'Expired', 'Bakery', AppColors.warning, '08:00 AM'),
      _WasteLog('Grilled Chicken', '0.8kg', 'Overcooked', 'Kitchen', AppColors.warning, 'Yesterday'),
      _WasteLog('Heavy Cream', '300ml', 'Spoiled', 'Storage', AppColors.error, 'Yesterday'),
    ];
    return Column(children: logs.map((l) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: l.color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.delete_outline, size: 16, color: AppColors.error)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.item, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          Text('${l.qty} · ${l.reason} · ${l.location}', style: TextStyle(fontSize: 11,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        ])),
        Text(l.time, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
      ]),
    )).toList());
  }

  void _showLogWasteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('inventory.log_waste'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Item')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Quantity')),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Reason')),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Submit'))),
        ]),
      ),
    );
  }
}

class _WasteLog { final String item, qty, reason, location, time; final Color color;
  _WasteLog(this.item, this.qty, this.reason, this.location, this.color, this.time); }
