import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({super.key});
  @override
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('accounting.title'.tr()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(controller: _tab, isScrollable: true,
              tabs: ['Overview', 'Invoices', 'Expenses', 'P&L'].map((t) => Tab(text: t)).toList()),
        ),
      ),
      body: TabBarView(controller: _tab, children: [
        _buildOverview(),
        _buildInvoices(),
        _buildExpenses(),
        _buildPnL(),
      ]),
    );
  }

  Widget _buildOverview() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(padding: const EdgeInsets.all(16), children: [
      // Period selector
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
        child: Row(children: [
          const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('July 2026', style: TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('This Month', style: TextStyle(fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ]),
      ),
      const SizedBox(height: 16),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5,
        children: [
          KpiCard(title: 'accounting.total_revenue'.tr(), value: 'SAR 284K', icon: Icons.trending_up, color: AppColors.kpiGreen, change: 14.2, isPositiveChange: true),
          KpiCard(title: 'accounting.total_expenses'.tr(), value: 'SAR 196K', icon: Icons.trending_down, color: AppColors.error, change: 8.1, isPositiveChange: false),
          KpiCard(title: 'accounting.net_profit'.tr(), value: 'SAR 88K', icon: Icons.account_balance_outlined, color: AppColors.kpiBlue, change: 22.3, isPositiveChange: true),
          KpiCard(title: 'Profit Margin', value: '30.9%', icon: Icons.percent, color: AppColors.kpiPurple),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'Revenue vs Expenses'),
      const SizedBox(height: 12),
      Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
        child: BarChart(BarChartData(
          barGroups: List.generate(7, (i) => BarChartGroupData(x: i, barRods: [
            BarChartRodData(toY: 40 + (i * 5).toDouble(), color: AppColors.kpiGreen, width: 10, borderRadius: BorderRadius.circular(4)),
            BarChartRodData(toY: 28 + (i * 3).toDouble(), color: AppColors.error.withOpacity(0.7), width: 10, borderRadius: BorderRadius.circular(4)),
          ])),
          gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: isDark ? AppColors.borderDark : AppColors.borderLight, strokeWidth: 1)),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (v, _) {
              final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              return Text(days[v.toInt()], style: const TextStyle(fontSize: 11));
            })),
          ),
        )),
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'Expense Breakdown'),
      const SizedBox(height: 12),
      _buildExpenseBreakdown(isDark),
    ]);
  }

  Widget _buildExpenseBreakdown(bool isDark) {
    final expenses = [
      _ExpRow('Food Cost', 'SAR 98K', 0.50, AppColors.kpiOrange),
      _ExpRow('Labor', 'SAR 42K', 0.21, AppColors.kpiBlue),
      _ExpRow('Rent', 'SAR 22K', 0.11, AppColors.kpiPurple),
      _ExpRow('Utilities', 'SAR 18K', 0.09, AppColors.kpiTeal),
      _ExpRow('Marketing', 'SAR 10K', 0.05, AppColors.kpiGreen),
      _ExpRow('Other', 'SAR 6K', 0.03, AppColors.textSecondaryLight),
    ];
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: Column(children: expenses.asMap().entries.map((e) {
        final item = e.value; final isLast = e.key == expenses.length - 1;
        return Column(children: [
          Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: item.pct, backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(item.color), minHeight: 3, borderRadius: BorderRadius.circular(2)),
            ])),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(item.amount, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${(item.pct * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
            ]),
          ])),
          if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ]);
      }).toList()),
    );
  }

  Widget _buildInvoices() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final invoices = [
      _Invoice('INV-2847', 'Al-Rashidi Farms', 'SAR 8,400', 'Overdue', AppColors.error, 'Jul 15'),
      _Invoice('INV-2846', 'Food Supplies Co.', 'SAR 12,200', 'Unpaid', AppColors.warning, 'Jul 28'),
      _Invoice('INV-2845', 'Kitchen Equipment', 'SAR 3,600', 'Paid', AppColors.success, 'Jul 10'),
      _Invoice('INV-2844', 'Dairy Direct', 'SAR 4,800', 'Paid', AppColors.success, 'Jul 8'),
      _Invoice('INV-2843', 'Spice World', 'SAR 1,200', 'Paid', AppColors.success, 'Jul 5'),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: invoices.length,
      itemBuilder: (ctx, i) {
        final inv = invoices[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: inv.statusColor == AppColors.error ? AppColors.error.withOpacity(0.3) : (isDark ? AppColors.borderDark : AppColors.borderLight))),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.kpiBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.receipt_long_outlined, color: AppColors.kpiBlue, size: 18)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(inv.id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(inv.supplier, style: const TextStyle(fontSize: 12)),
              Text('Due: ${inv.dueDate}', style: TextStyle(fontSize: 11,
                  color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(inv.amount, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 6),
              StatusBadge(label: inv.status, color: inv.statusColor),
            ]),
          ]),
        );
      },
    );
  }

  Widget _buildExpenses() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final exps = [
      _ExpenseItem('Electricity Bill', 'Utilities', 'SAR 4,200', 'Jul 25', Icons.electric_bolt_outlined),
      _ExpenseItem('Water Bill', 'Utilities', 'SAR 1,800', 'Jul 24', Icons.water_drop_outlined),
      _ExpenseItem('Staff Uniforms', 'Operations', 'SAR 2,400', 'Jul 20', Icons.checkroom_outlined),
      _ExpenseItem('Cleaning Supplies', 'Operations', 'SAR 680', 'Jul 18', Icons.cleaning_services_outlined),
      _ExpenseItem('Google Ads', 'Marketing', 'SAR 3,000', 'Jul 15', Icons.campaign_outlined),
    ];
    return ListView(padding: const EdgeInsets.all(16), children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 16, color: Colors.white),
          label: Text('accounting.add_expense'.tr(), style: const TextStyle(color: Colors.white))),
      ]),
      const SizedBox(height: 12),
      ...exps.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.kpiOrange.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Icon(e.icon, color: AppColors.kpiOrange, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            Text(e.category, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(e.amount, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)),
            Text(e.date, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          ]),
        ]),
      )),
    ]);
  }

  Widget _buildPnL() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(padding: const EdgeInsets.all(16), children: [
      SectionHeader(title: 'Profit & Loss — July 2026'),
      const SizedBox(height: 12),
      _pnlSection('Revenue', [
        _PnlItem('Food Sales', 'SAR 246,000'),
        _PnlItem('Beverage Sales', 'SAR 32,000'),
        _PnlItem('Delivery Revenue', 'SAR 6,000'),
      ], 'SAR 284,000', AppColors.kpiGreen, isDark),
      const SizedBox(height: 12),
      _pnlSection('Cost of Goods', [
        _PnlItem('Food Cost', 'SAR 78,000'),
        _PnlItem('Beverage Cost', 'SAR 9,600'),
        _PnlItem('Waste & Spoilage', 'SAR 8,000'),
      ], 'SAR 95,600', AppColors.error, isDark),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.kpiGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.kpiGreen.withOpacity(0.3))),
        child: Row(children: [
          const Text('Gross Profit', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const Spacer(),
          Text('SAR 188,400', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.kpiGreen)),
        ]),
      ),
      const SizedBox(height: 12),
      _pnlSection('Operating Expenses', [
        _PnlItem('Labor', 'SAR 42,000'),
        _PnlItem('Rent', 'SAR 22,000'),
        _PnlItem('Utilities', 'SAR 18,000'),
        _PnlItem('Marketing', 'SAR 10,000'),
        _PnlItem('Other', 'SAR 8,400'),
      ], 'SAR 100,400', AppColors.error, isDark),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          const Text('Net Profit', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
          const Spacer(),
          const Text('SAR 88,000', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
        ]),
      ),
    ]);
  }

  Widget _pnlSection(String title, List<_PnlItem> items, String total, Color color, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: Column(children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
          child: Row(children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
            const Spacer(),
            Text(total, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
          ])),
        ...items.map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight))),
          child: Row(children: [
            const SizedBox(width: 12),
            Text(item.label, style: const TextStyle(fontSize: 13)),
            const Spacer(),
            Text(item.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
        )),
      ]),
    );
  }
}

class _ExpRow { final String label, amount; final double pct; final Color color;
  _ExpRow(this.label, this.amount, this.pct, this.color); }
class _Invoice { final String id, supplier, amount, status, dueDate; final Color statusColor;
  _Invoice(this.id, this.supplier, this.amount, this.status, this.statusColor, this.dueDate); }
class _ExpenseItem { final String name, category, amount, date; final IconData icon;
  _ExpenseItem(this.name, this.category, this.amount, this.date, this.icon); }
class _PnlItem { final String label, value; _PnlItem(this.label, this.value); }
