import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});
  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _period = 1;

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

  final _expenses = [
    _Expense('Branch Rent', 'Rent & Lease', 18000, 'Monthly', 'Paid', AppColors.kpiBlue, Icons.home_work_outlined, '1 Jul 2026'),
    _Expense('Electricity Bill', 'Utilities', 3200, 'Monthly', 'Paid', AppColors.kpiOrange, Icons.bolt_outlined, '5 Jul 2026'),
    _Expense('Water Bill', 'Utilities', 640, 'Monthly', 'Paid', AppColors.kpiTeal, Icons.water_drop_outlined, '5 Jul 2026'),
    _Expense('Internet & Phone', 'Utilities', 420, 'Monthly', 'Paid', AppColors.kpiTeal, Icons.wifi_outlined, '3 Jul 2026'),
    _Expense('Staff Salaries', 'Payroll', 42000, 'Monthly', 'Pending', AppColors.kpiGreen, Icons.people_outline, '28 Jul 2026'),
    _Expense('Food Supplies', 'Procurement', 14800, 'Weekly', 'Paid', AppColors.kpiPurple, Icons.shopping_cart_outlined, '21 Jul 2026'),
    _Expense('Cleaning Supplies', 'Maintenance', 580, 'Monthly', 'Paid', AppColors.kpiOrange, Icons.cleaning_services_outlined, '10 Jul 2026'),
    _Expense('Equipment Service', 'Maintenance', 1200, 'One-time', 'Paid', AppColors.warning, Icons.build_outlined, '15 Jul 2026'),
    _Expense('Marketing Ads', 'Marketing', 2500, 'Monthly', 'Pending', AppColors.kpiRed, Icons.campaign_outlined, '30 Jul 2026'),
    _Expense('Delivery Platform Fee', 'Platform', 1840, 'Monthly', 'Paid', AppColors.info, Icons.delivery_dining_outlined, '1 Jul 2026'),
  ];

  List<_Expense> get _filtered {
    final idx = _tab.index;
    if (idx == 1) return _expenses.where((e) => e.status == 'Paid').toList();
    if (idx == 2) return _expenses.where((e) => e.status == 'Pending').toList();
    return _expenses;
  }

  double get _total => _expenses.fold(0, (s, e) => s + e.amount);
  double get _paid => _expenses.where((e) => e.status == 'Paid').fold(0, (s, e) => s + e.amount);
  double get _pending => _expenses.where((e) => e.status == 'Pending').fold(0, (s, e) => s + e.amount);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('expenses.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            onTap: (_) => setState(() {}),
            tabs: ['All (${_expenses.length})', 'Paid', 'Pending'].map((t) => Tab(text: t)).toList(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Period selector
          Container(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: ['expenses.daily', 'expenses.weekly', 'expenses.monthly']
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(e.value.tr()),
                          selected: _period == e.key,
                          onSelected: (_) => setState(() => _period = e.key),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                              color: _period == e.key ? Colors.white : null,
                              fontSize: 12),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // KPI row
                Row(children: [
                  Expanded(child: _kpi('Total', 'SAR ${_formatNum(_total)}', AppColors.kpiBlue, Icons.receipt_long_outlined)),
                  const SizedBox(width: 10),
                  Expanded(child: _kpi('Paid', 'SAR ${_formatNum(_paid)}', AppColors.kpiGreen, Icons.check_circle_outline)),
                  const SizedBox(width: 10),
                  Expanded(child: _kpi('Pending', 'SAR ${_formatNum(_pending)}', AppColors.warning, Icons.pending_outlined)),
                ]),
                const SizedBox(height: 20),
                // Category chart
                SectionHeader(title: 'expenses.by_category'.tr()),
                const SizedBox(height: 12),
                _buildCategoryChart(isDark),
                const SizedBox(height: 20),
                SectionHeader(title: 'expenses.all_expenses'.tr()),
                const SizedBox(height: 12),
                ..._filtered.map((e) => _buildExpenseCard(e, isDark)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('expenses.add'.tr(), style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _kpi(String label, String value, Color color, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
      ]),
    );
  }

  Widget _buildCategoryChart(bool isDark) {
    final categories = <String, double>{};
    for (final e in _expenses) {
      categories[e.category] = (categories[e.category] ?? 0) + e.amount;
    }
    final entries = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final colors = [AppColors.kpiBlue, AppColors.kpiGreen, AppColors.kpiOrange, AppColors.kpiPurple, AppColors.kpiTeal, AppColors.kpiRed];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        SizedBox(
          width: 120, height: 120,
          child: PieChart(PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 30,
            sections: entries.asMap().entries.map((e) => PieChartSectionData(
              color: colors[e.key % colors.length],
              value: e.value.value,
              title: '',
              radius: 40,
            )).toList(),
          )),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(
                  color: colors[e.key % colors.length], shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(e.value.key, style: const TextStyle(fontSize: 12))),
                Text('SAR ${_formatNum(e.value.value)}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: colors[e.key % colors.length])),
              ]),
            )).toList(),
          ),
        ),
      ]),
    );
  }

  Widget _buildExpenseCard(_Expense e, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: e.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(e.icon, color: e.color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 2),
          Row(children: [
            StatusBadge(label: e.category, color: e.color),
            const SizedBox(width: 8),
            Text(e.date, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          ]),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('SAR ${_formatNum(e.amount)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 4),
          StatusBadge(
            label: e.status,
            color: e.status == 'Paid' ? AppColors.success : AppColors.warning,
          ),
        ]),
      ]),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('expenses.add'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Expense Name', prefixIcon: Icon(Icons.receipt_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Amount (SAR)', prefixIcon: Icon(Icons.payments_outlined)), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category_outlined))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: Text('common.save'.tr()))),
        ]),
      ),
    );
  }

  String _formatNum(double n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toStringAsFixed(0);
  }
}

class _Expense {
  final String name, category, status, date, frequency;
  final double amount;
  final Color color;
  final IconData icon;
  _Expense(this.name, this.category, this.amount, this.frequency, this.status, this.color, this.icon, this.date);
}
