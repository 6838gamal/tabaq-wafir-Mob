import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});
  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _tabs = ['All', 'Critical', 'Warning', 'Info'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  final _alerts = [
    _Alert('Stock Depleted', 'Saffron is completely out of stock', AppColors.error, Icons.inventory_2_outlined, '2m ago', false, 'critical'),
    _Alert('Delayed Order', 'Order #1243 has been waiting 45 minutes', AppColors.error, Icons.timer_off, '5m ago', false, 'critical'),
    _Alert('High Waste', 'Beef waste exceeded 8% threshold today', AppColors.warning, Icons.delete_outline, '15m ago', false, 'warning'),
    _Alert('Sales Drop', 'Lunch revenue down 22% from last Monday', AppColors.warning, Icons.trending_down, '1h ago', false, 'warning'),
    _Alert('Labor Cost High', 'Overtime cost SAR 1,200 above budget', AppColors.warning, Icons.people_outline, '2h ago', true, 'warning'),
    _Alert('Low Ratings', 'Google rating dropped to 4.1 · 3 new 2-star reviews', AppColors.warning, Icons.star_border, '3h ago', true, 'warning'),
    _Alert('Invoice Mismatch', 'Supplier invoice #INV-2847 doesn\'t match PO', AppColors.warning, Icons.receipt_long_outlined, '4h ago', true, 'warning'),
    _Alert('High Cancellations', '8 orders cancelled today (4% rate)', AppColors.info, Icons.cancel_outlined, '5h ago', true, 'info'),
    _Alert('Delayed Supplier', 'Al-Rashidi Farms delivery delayed by 3 hours', AppColors.info, Icons.local_shipping_outlined, '6h ago', true, 'info'),
    _Alert('Stock Low', 'Heavy Cream below reorder point (500ml left)', AppColors.info, Icons.warning_amber_outlined, '8h ago', true, 'info'),
  ];

  List<_Alert> get _filtered {
    final sel = _tabs[_tab.index].toLowerCase();
    if (sel == 'all') return _alerts;
    return _alerts.where((a) => a.type == sel).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('alerts.title'.tr()),
        actions: [
          TextButton(
            onPressed: () => setState(() => _alerts.forEach((a) => a.isRead = true)),
            child: Text('alerts.mark_all_read'.tr(), style: const TextStyle(fontSize: 12)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(controller: _tab, isScrollable: true,
              onTap: (_) => setState(() {}),
              tabs: _tabs.map((t) => Tab(text: t)).toList()),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary row
          Row(
            children: [
              _summaryChip('Critical', _alerts.where((a) => a.type == 'critical' && !a.isRead).length, AppColors.error),
              const SizedBox(width: 8),
              _summaryChip('Warning', _alerts.where((a) => a.type == 'warning' && !a.isRead).length, AppColors.warning),
              const SizedBox(width: 8),
              _summaryChip('Info', _alerts.where((a) => a.type == 'info' && !a.isRead).length, AppColors.info),
            ],
          ),
          const SizedBox(height: 16),
          ..._filtered.map((a) => AlertCard(
            title: a.title,
            description: a.description,
            color: a.color,
            icon: a.icon,
            time: a.time,
            isRead: a.isRead,
            onTap: () => setState(() => a.isRead = true),
          )),
        ],
      ),
    );
  }

  Widget _summaryChip(String label, int count, Color color) {
    return Chip(
      avatar: Container(
        width: 16, height: 16,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
      ),
      label: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      backgroundColor: color.withOpacity(0.08),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _Alert {
  final String title, description, time, type; final Color color; final IconData icon; bool isRead;
  _Alert(this.title, this.description, this.color, this.icon, this.time, this.isRead, this.type);
}
