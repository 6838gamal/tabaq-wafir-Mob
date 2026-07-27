import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class RefundsPage extends StatefulWidget {
  const RefundsPage({super.key});
  @override
  State<RefundsPage> createState() => _RefundsPageState();
}

class _RefundsPageState extends State<RefundsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  final _refunds = [
    _Refund('#1243', 'Table 3', 210.0, 'Wrong order delivered', 'Approved', 'Card', 'Today 9:05 AM', AppColors.kpiGreen),
    _Refund('#1220', 'Delivery', 94.5, 'Order arrived cold', 'Approved', 'Online', 'Yesterday 6:30 PM', AppColors.kpiGreen),
    _Refund('#1198', 'Table 8', 145.0, 'Item unavailable after order', 'Pending', 'Cash', 'Yesterday 1:15 PM', AppColors.warning),
    _Refund('#1185', 'Pickup', 55.0, 'Duplicate charge', 'Approved', 'Card', '25 Jul 2026', AppColors.kpiGreen),
    _Refund('#1170', 'Table 5', 320.0, 'Customer dispute', 'Rejected', 'Card', '24 Jul 2026', AppColors.error),
    _Refund('#1162', 'Delivery', 88.0, 'Missing items', 'Approved', 'Online', '23 Jul 2026', AppColors.kpiGreen),
    _Refund('#1148', 'Table 11', 175.0, 'Food quality issue', 'Pending', 'Cash', '22 Jul 2026', AppColors.warning),
    _Refund('#1130', 'Table 2', 62.0, 'Payment error', 'Approved', 'Card', '20 Jul 2026', AppColors.kpiGreen),
  ];

  List<_Refund> get _filtered {
    final idx = _tab.index;
    if (idx == 1) return _refunds.where((r) => r.status == 'Approved').toList();
    if (idx == 2) return _refunds.where((r) => r.status == 'Pending').toList();
    return _refunds;
  }

  double get _totalRefunded => _refunds.where((r) => r.status == 'Approved').fold(0, (s, r) => s + r.amount);
  double get _pendingAmount => _refunds.where((r) => r.status == 'Pending').fold(0, (s, r) => s + r.amount);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('refunds.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            onTap: (_) => setState(() {}),
            tabs: [
              Tab(text: 'All (${_refunds.length})'),
              Tab(text: 'Approved (${_refunds.where((r) => r.status == 'Approved').length})'),
              Tab(text: 'Pending (${_refunds.where((r) => r.status == 'Pending').length})'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(children: [
              Expanded(child: _summaryTile('Refunded', 'SAR ${_totalRefunded.toStringAsFixed(0)}', AppColors.kpiGreen, Icons.check_circle_outline)),
              const SizedBox(width: 12),
              Expanded(child: _summaryTile('Pending Review', 'SAR ${_pendingAmount.toStringAsFixed(0)}', AppColors.warning, Icons.pending_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _summaryTile('Total Cases', '${_refunds.length}', AppColors.kpiBlue, Icons.list_alt_outlined)),
            ]),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.assignment_return_outlined,
                    title: 'No refunds',
                    subtitle: 'No refund cases match this filter.')
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _buildCard(_filtered[i], isDark),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(String label, String value, Color color, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
        ])),
      ]),
    );
  }

  Widget _buildCard(_Refund r, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Row(children: [
            Text('Order ${r.orderId}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(width: 8),
            StatusBadge(label: r.status, color: r.statusColor),
          ])),
          Text('SAR ${r.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.error)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondaryLight),
          const SizedBox(width: 4),
          Text(r.location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
          const SizedBox(width: 12),
          const Icon(Icons.credit_card, size: 12, color: AppColors.textSecondaryLight),
          const SizedBox(width: 4),
          Text(r.method, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
        ]),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            const Icon(Icons.info_outline, size: 12, color: AppColors.error),
            const SizedBox(width: 6),
            Expanded(child: Text(r.reason, style: const TextStyle(fontSize: 12, color: AppColors.error))),
          ]),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(r.date, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          if (r.status == 'Pending')
            Row(children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                ),
                child: const Text('Reject', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kpiGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                ),
                child: const Text('Approve', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ]),
        ]),
      ]),
    );
  }
}

class _Refund {
  final String orderId, location, reason, status, method, date;
  final double amount;
  final Color statusColor;
  _Refund(this.orderId, this.location, this.amount, this.reason, this.status, this.method, this.date, this.statusColor);
}
