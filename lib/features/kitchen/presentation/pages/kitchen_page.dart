import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});
  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('kitchen.title'.tr()),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(children: [
              Icon(Icons.circle, color: AppColors.success, size: 8),
              SizedBox(width: 6),
              Text('Kitchen Open', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(controller: _tab,
              tabs: ['Queue (4)', 'In Progress (3)', 'Ready (2)'].map((t) => Tab(text: t)).toList()),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildQueue(isDark),
          _buildInProgress(isDark),
          _buildReady(isDark),
        ],
      ),
    );
  }

  Widget _buildQueue(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildKitchenCard('#1248', 'Table 7', ['Grilled Chicken × 2', 'Caesar Salad × 1', 'Lemonade × 2'], 0, 'Normal', isDark),
        _buildKitchenCard('#1249', 'Delivery', ['Beef Burger × 1', 'Fries × 1'], 2, 'Rush', isDark),
        _buildKitchenCard('#1250', 'Table 2', ['Pasta Carbonara × 3', 'Garlic Bread × 1'], 0, 'Normal', isDark),
        _buildKitchenCard('#1251', 'Pickup', ['Sushi Platter × 1'], 5, 'Normal', isDark),
      ],
    );
  }

  Widget _buildInProgress(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildKitchenCard('#1245', 'Table 12', ['Beef Tenderloin × 2', 'Mashed Potato × 2', 'Cheesecake × 1'], 18, 'Normal', isDark, inProgress: true),
        _buildKitchenCard('#1243', 'Table 3', ['Grilled Fish × 1', 'Steamed Veg × 1'], 32, 'Normal', isDark, inProgress: true, overdue: true),
        _buildKitchenCard('#1244', 'Delivery', ['Pizza Margherita × 2', 'Tiramisu × 1'], 12, 'Rush', isDark, inProgress: true),
      ],
    );
  }

  Widget _buildReady(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _buildKitchenCard('#1242', 'Table 5', ['Chicken Shawarma × 3', 'Hummus × 1'], 25, 'Normal', isDark, ready: true),
        _buildKitchenCard('#1241', 'Delivery', ['Lamb Kofta × 2', 'Rice × 2'], 20, 'Normal', isDark, ready: true),
      ],
    );
  }

  Widget _buildKitchenCard(String id, String location, List<String> items, int minutes, String priority, bool isDark,
      {bool inProgress = false, bool ready = false, bool overdue = false}) {
    final borderColor = overdue ? AppColors.error : ready ? AppColors.success : inProgress ? AppColors.kpiOrange : (isDark ? AppColors.borderDark : AppColors.borderLight);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: overdue ? 1.5 : 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: (overdue ? AppColors.error : ready ? AppColors.success : inProgress ? AppColors.kpiOrange : AppColors.primary).withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(width: 10),
              Icon(location.contains('Table') ? Icons.table_restaurant_outlined :
                   location.contains('Delivery') ? Icons.delivery_dining : Icons.shopping_bag_outlined,
                  size: 14, color: AppColors.textSecondaryLight),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(fontSize: 13)),
              const Spacer(),
              if (priority == 'Rush')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
                  child: const Text('RUSH', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              if (inProgress || ready) ...[
                const SizedBox(width: 8),
                Icon(Icons.timer_outlined, size: 13, color: overdue ? AppColors.error : AppColors.textSecondaryLight),
                const SizedBox(width: 3),
                Text('${minutes}m', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: overdue ? AppColors.error : null)),
              ],
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  const Icon(Icons.fiber_manual_record, size: 6, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 8),
                  Text(item, style: const TextStyle(fontSize: 13)),
                ]),
              )).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ready ? AppColors.success : inProgress ? AppColors.kpiGreen : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  ready ? 'Served' : inProgress ? 'kitchen.mark_ready'.tr() : 'kitchen.start_cooking'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
