import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});
  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _period = 0;

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

  final _payments = [
    _Payment('#1247', 'Table 5', 185.0, 'Card', 'Completed', '10:42 AM', AppColors.kpiBlue),
    _Payment('#1246', 'Delivery', 94.5, 'Online', 'Completed', '10:15 AM', AppColors.kpiPurple),
    _Payment('#1245', 'Table 12', 320.0, 'Cash', 'Completed', '09:58 AM', AppColors.kpiGreen),
    _Payment('#1244', 'Pickup', 68.0, 'Online', 'Completed', '09:30 AM', AppColors.kpiPurple),
    _Payment('#1243', 'Table 3', 210.0, 'Card', 'Refunded', '09:05 AM', AppColors.error),
    _Payment('#1242', 'Table 7', 145.0, 'Cash', 'Completed', '08:50 AM', AppColors.kpiGreen),
    _Payment('#1241', 'Delivery', 112.0, 'Online', 'Completed', '08:30 AM', AppColors.kpiPurple),
    _Payment('#1240', 'Table 2', 88.5, 'Card', 'Completed', '08:10 AM', AppColors.kpiBlue),
    _Payment('#1239', 'Table 9', 260.0, 'Cash', 'Pending', '07:55 AM', AppColors.warning),
    _Payment('#1238', 'Table 1', 175.0, 'Card', 'Completed', '07:30 AM', AppColors.kpiBlue),
  ];

  List<_Payment> get _filtered {
    final idx = _tab.index;
    if (idx == 1) return _payments.where((p) => p.method == 'Cash').toList();
    if (idx == 2) return _payments.where((p) => p.method == 'Card' || p.method == 'Online').toList();
    return _payments;
  }

  double get _total => _payments.where((p) => p.status == 'Completed').fold(0, (s, p) => s + p.amount);
  double get _cashTotal => _payments.where((p) => p.method == 'Cash' && p.status == 'Completed').fold(0, (s, p) => s + p.amount);
  double get _cardTotal => _payments.where((p) => p.method == 'Card' && p.status == 'Completed').fold(0, (s, p) => s + p.amount);
  double get _onlineTotal => _payments.where((p) => p.method == 'Online' && p.status == 'Completed').fold(0, (s, p) => s + p.amount);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('payments.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            onTap: (_) => setState(() {}),
            tabs: ['All', 'Cash', 'Card & Online'].map((t) => Tab(text: t)).toList(),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period chips
          Row(
            children: [
              ...['Today', 'This Week', 'This Month'].asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(e.value),
                  selected: _period == e.key,
                  onSelected: (_) => setState(() => _period = e.key),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _period == e.key ? Colors.white : null, fontSize: 12),
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),
          // KPI cards
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
            children: [
              KpiCard(title: 'Total Revenue', value: 'SAR ${_total.toStringAsFixed(0)}', icon: Icons.trending_up, color: AppColors.kpiGreen, change: 8.4, isPositiveChange: true),
              KpiCard(title: 'Transactions', value: '${_payments.where((p) => p.status == 'Completed').length}', icon: Icons.receipt_outlined, color: AppColors.kpiBlue),
              KpiCard(title: 'Avg. Transaction', value: 'SAR ${(_total / _payments.where((p) => p.status == 'Completed').length).toStringAsFixed(0)}', icon: Icons.calculate_outlined, color: AppColors.kpiPurple),
              KpiCard(title: 'Pending', value: 'SAR ${_payments.where((p) => p.status == 'Pending').fold(0.0, (s, p) => s + p.amount).toStringAsFixed(0)}', icon: Icons.pending_outlined, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),
          // Payment method breakdown
          SectionHeader(title: 'payments.by_method'.tr()),
          const SizedBox(height: 12),
          _buildMethodBreakdown(isDark),
          const SizedBox(height: 20),
          // Transaction list
          SectionHeader(title: 'payments.transactions'.tr()),
          const SizedBox(height: 12),
          ..._filtered.map((p) => _buildPaymentCard(p, isDark)),
        ],
      ),
    );
  }

  Widget _buildMethodBreakdown(bool isDark) {
    final total = _cashTotal + _cardTotal + _onlineTotal;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: [
        Row(children: [
          SizedBox(
            width: 100, height: 100,
            child: PieChart(PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 25,
              sections: [
                PieChartSectionData(color: AppColors.kpiGreen, value: _cashTotal, title: '', radius: 35),
                PieChartSectionData(color: AppColors.kpiBlue, value: _cardTotal, title: '', radius: 35),
                PieChartSectionData(color: AppColors.kpiPurple, value: _onlineTotal, title: '', radius: 35),
              ],
            )),
          ),
          const SizedBox(width: 20),
          Expanded(child: Column(children: [
            _methodRow('Cash', _cashTotal, total, AppColors.kpiGreen, Icons.money),
            const SizedBox(height: 10),
            _methodRow('Card', _cardTotal, total, AppColors.kpiBlue, Icons.credit_card),
            const SizedBox(height: 10),
            _methodRow('Online', _onlineTotal, total, AppColors.kpiPurple, Icons.phone_android),
          ])),
        ]),
      ]),
    );
  }

  Widget _methodRow(String label, double amount, double total, Color color, IconData icon) {
    final pct = total == 0 ? 0.0 : (amount / total * 100);
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12)),
      const Spacer(),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('SAR ${amount.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        Text('${pct.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
      ]),
    ]);
  }

  Widget _buildPaymentCard(_Payment p, bool isDark) {
    final methodIcon = p.method == 'Cash'
        ? Icons.money
        : p.method == 'Card'
            ? Icons.credit_card
            : Icons.phone_android;
    final methodColor = p.method == 'Cash'
        ? AppColors.kpiGreen
        : p.method == 'Card'
            ? AppColors.kpiBlue
            : AppColors.kpiPurple;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: methodColor.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(methodIcon, color: methodColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Order ${p.orderId}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(width: 8),
            StatusBadge(
              label: p.status,
              color: p.status == 'Completed'
                  ? AppColors.success
                  : p.status == 'Pending'
                      ? AppColors.warning
                      : AppColors.error,
            ),
          ]),
          const SizedBox(height: 2),
          Row(children: [
            Icon(Icons.location_on_outlined, size: 11, color: AppColors.textSecondaryLight),
            const SizedBox(width: 4),
            Text(p.location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
            const SizedBox(width: 10),
            Icon(methodIcon, size: 11, color: methodColor),
            const SizedBox(width: 4),
            Text(p.method, style: TextStyle(fontSize: 12, color: methodColor)),
          ]),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('SAR ${p.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 2),
          Text(p.time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
        ]),
      ]),
    );
  }
}

class _Payment {
  final String orderId, location, method, status, time;
  final double amount;
  final Color color;
  _Payment(this.orderId, this.location, this.amount, this.method, this.status, this.time, this.color);
}
