import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _typeIndex = 0;
  final _types = ['All', 'Dine-in', 'Delivery', 'Pickup'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  final _orders = [
    _Order('#1247', 'Table 5', '3 items', 'SAR 185', 'Preparing', AppColors.kpiOrange, 'Dine-in', 18),
    _Order('#1246', 'Delivery', 'Ahmed K.', 'SAR 92', 'Ready', AppColors.kpiGreen, 'Delivery', 32),
    _Order('#1245', 'Table 12', '5 items', 'SAR 340', 'Served', AppColors.kpiBlue, 'Dine-in', 45),
    _Order('#1244', 'Pickup', 'Walk-in', 'SAR 67', 'Completed', AppColors.textSecondaryLight, 'Pickup', 12),
    _Order('#1243', 'Table 3', '2 items', 'SAR 110', 'Pending', AppColors.statusPending, 'Dine-in', 5),
    _Order('#1242', 'Delivery', 'Sara M.', 'SAR 145', 'Preparing', AppColors.kpiOrange, 'Delivery', 22),
    _Order('#1241', 'Table 8', '4 items', 'SAR 280', 'Completed', AppColors.textSecondaryLight, 'Dine-in', 60),
    _Order('#1240', 'Pickup', 'Khalid R.', 'SAR 55', 'Cancelled', AppColors.error, 'Pickup', 8),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('orders.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.kitchen_outlined),
            onPressed: () => context.go(AppRoutes.kitchen),
            tooltip: 'orders.kitchen_screen'.tr(),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            onTap: (_) => setState(() {}),
            tabs: ['All', 'Pending', 'Preparing', 'Ready', 'Done']
                .map((t) => Tab(text: t)).toList(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Type filter chips
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => ChoiceChip(
                label: Text(_types[i]),
                selected: _typeIndex == i,
                onSelected: (_) => setState(() => _typeIndex = i),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: _typeIndex == i ? Colors.white : null,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AppSearchBar(hintText: 'Search orders...'),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _orders.length,
              itemBuilder: (context, i) => _buildOrderCard(context, _orders[i], isDark),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewOrderSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('orders.new_order'.tr(), style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, _Order order, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.id, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 2),
              Row(children: [
                _typeIcon(order.type),
                const SizedBox(width: 4),
                Text(order.type, style: TextStyle(fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ]),
            ]),
            const Spacer(),
            StatusBadge(label: order.status, color: order.statusColor),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _infoChip(Icons.location_on_outlined, order.table),
            const SizedBox(width: 8),
            _infoChip(Icons.shopping_bag_outlined, order.items),
            const Spacer(),
            Text(order.total, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.timer_outlined, size: 13, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
            const SizedBox(width: 4),
            Text('${order.minutes} min', style: TextStyle(fontSize: 11,
                color: order.minutes > 30 ? AppColors.error : (isDark ? AppColors.textHintDark : AppColors.textHintLight))),
            const Spacer(),
            if (order.status == 'Pending')
              _actionBtn('Accept', AppColors.success, () {}),
            if (order.status == 'Preparing')
              _actionBtn('Mark Ready', AppColors.kpiBlue, () {}),
            if (order.status == 'Ready')
              _actionBtn('Serve', AppColors.kpiGreen, () {}),
          ]),
        ],
      ),
    );
  }

  Widget _typeIcon(String type) {
    final icon = type == 'Delivery' ? Icons.delivery_dining :
                 type == 'Pickup' ? Icons.shopping_bag_outlined : Icons.table_restaurant_outlined;
    return Icon(icon, size: 13, color: AppColors.primary);
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(children: [
      Icon(icon, size: 13, color: AppColors.textSecondaryLight),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showNewOrderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (_, sc) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Text('orders.new_order'.tr(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            const Text('Order creation form goes here'),
          ]),
        ),
      ),
    );
  }
}

class _Order {
  final String id, table, items, total, status, type; final Color statusColor; final int minutes;
  _Order(this.id, this.table, this.items, this.total, this.status, this.statusColor, this.type, this.minutes);
}
