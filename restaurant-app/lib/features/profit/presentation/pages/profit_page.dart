import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class ProfitPage extends StatefulWidget {
  const ProfitPage({super.key});
  @override
  State<ProfitPage> createState() => _ProfitPageState();
}

class _ProfitPageState extends State<ProfitPage> {
  int _period = 1;

  final _revenue = [18200.0, 21400.0, 19800.0, 23100.0, 22400.0, 25800.0, 24300.0];
  final _expenses = [12800.0, 14200.0, 13900.0, 15600.0, 14800.0, 17200.0, 16100.0];

  List<double> get _profit => List.generate(_revenue.length, (i) => _revenue[i] - _expenses[i]);

  final _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // P&L breakdown items
  final _plItems = [
    _PLItem('Gross Revenue', 154000, true, AppColors.kpiGreen),
    _PLItem('Food Cost (COGS)', -52800, false, AppColors.kpiRed),
    _PLItem('Gross Profit', 101200, true, AppColors.kpiBlue),
    _PLItem('Staff Salaries', -42000, false, AppColors.kpiOrange),
    _PLItem('Rent & Utilities', -22260, false, AppColors.kpiOrange),
    _PLItem('Marketing', -2500, false, AppColors.kpiOrange),
    _PLItem('Platform Fees', -1840, false, AppColors.kpiOrange),
    _PLItem('Maintenance', -1780, false, AppColors.kpiOrange),
    _PLItem('Other Expenses', -3200, false, AppColors.kpiOrange),
    _PLItem('Net Profit', 27620, true, AppColors.kpiGreen),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final netProfit = _plItems.last.amount;
    final revenue = _plItems.first.amount;
    final margin = (netProfit / revenue * 100);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('profit.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period chips
          Row(children: [
            ...['Daily', 'Weekly', 'Monthly'].asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(e.value),
                selected: _period == e.key,
                onSelected: (_) => setState(() => _period = e.key),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _period == e.key ? Colors.white : null, fontSize: 12),
              ),
            )),
          ]),
          const SizedBox(height: 16),
          // Hero KPIs
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
            children: [
              KpiCard(title: 'profit.revenue'.tr(), value: 'SAR 154K', icon: Icons.trending_up, color: AppColors.kpiGreen, change: 12.4, isPositiveChange: true),
              KpiCard(title: 'profit.total_cost'.tr(), value: 'SAR 126.4K', icon: Icons.trending_down, color: AppColors.kpiOrange, change: 8.1, isPositiveChange: false),
              KpiCard(title: 'profit.net_profit'.tr(), value: 'SAR 27.6K', icon: Icons.account_balance_outlined, color: AppColors.kpiBlue, change: 18.2, isPositiveChange: true),
              KpiCard(title: 'profit.margin'.tr(), value: '${margin.toStringAsFixed(1)}%', icon: Icons.percent_outlined, color: AppColors.kpiPurple, change: 1.4, isPositiveChange: true),
            ],
          ),
          const SizedBox(height: 20),
          // Profit trend chart
          SectionHeader(title: 'profit.weekly_trend'.tr()),
          const SizedBox(height: 12),
          _buildTrendChart(isDark),
          const SizedBox(height: 20),
          // P&L Statement
          SectionHeader(title: 'profit.pl_statement'.tr()),
          const SizedBox(height: 12),
          _buildPLStatement(isDark),
          const SizedBox(height: 20),
          // Cost breakdown
          SectionHeader(title: 'profit.cost_breakdown'.tr()),
          const SizedBox(height: 12),
          _buildCostBreakdown(isDark),
        ],
      ),
    );
  }

  Widget _buildTrendChart(bool isDark) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _legend('Revenue', AppColors.kpiGreen),
          const SizedBox(width: 16),
          _legend('Expenses', AppColors.kpiOrange),
          const SizedBox(width: 16),
          _legend('Profit', AppColors.kpiBlue),
        ]),
        const SizedBox(height: 12),
        Expanded(
          child: LineChart(LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: isDark ? AppColors.borderDark : AppColors.borderLight, strokeWidth: 0.5),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true, reservedSize: 20,
                getTitlesWidget: (v, _) => Text(
                  _days[v.toInt() % _days.length],
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight),
                ),
              )),
            ),
            lineBarsData: [
              _lineBar(_revenue, AppColors.kpiGreen),
              _lineBar(_expenses, AppColors.kpiOrange),
              _lineBar(_profit, AppColors.kpiBlue),
            ],
          )),
        ),
      ]),
    );
  }

  LineChartBarData _lineBar(List<double> data, Color color) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value / 1000)).toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _legend(String label, Color color) {
    return Row(children: [
      Container(width: 12, height: 3, color: color),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
    ]);
  }

  Widget _buildPLStatement(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: _plItems.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == _plItems.length - 1;
          final isHeader = item.isPositive && entry.key != 0 && entry.key != _plItems.length - 1;
          return Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: isLast
                  ? BoxDecoration(
                      color: AppColors.kpiGreen.withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                    )
                  : null,
              child: Row(children: [
                if (!item.isPositive) const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: (item.isPositive) ? FontWeight.w700 : FontWeight.w400,
                      color: isLast ? AppColors.kpiGreen : null,
                    ),
                  ),
                ),
                Text(
                  '${item.amount < 0 ? '- ' : '+ '}SAR ${(item.amount.abs() / 1000).toStringAsFixed(1)}K',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: item.amount < 0 ? AppColors.error : item.color,
                  ),
                ),
              ]),
            ),
            if (!isLast)
              Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildCostBreakdown(bool isDark) {
    final costs = [
      _CostItem('Food Cost', 52800, AppColors.kpiRed),
      _CostItem('Salaries', 42000, AppColors.kpiOrange),
      _CostItem('Rent & Utilities', 22260, AppColors.kpiBlue),
      _CostItem('Marketing', 2500, AppColors.kpiPurple),
      _CostItem('Platform Fees', 1840, AppColors.kpiTeal),
      _CostItem('Other', 4980, AppColors.textSecondaryLight),
    ];
    final total = costs.fold(0.0, (s, c) => s + c.amount);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: costs.map((c) {
        final pct = c.amount / total;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(c.label, style: const TextStyle(fontSize: 13))),
              Text('SAR ${(c.amount / 1000).toStringAsFixed(1)}K',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.color)),
              const SizedBox(width: 8),
              Text('${(pct * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
            ]),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: c.color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(c.color),
                minHeight: 6,
              ),
            ),
          ]),
        );
      }).toList()),
    );
  }
}

class _PLItem {
  final String label;
  final double amount;
  final bool isPositive;
  final Color color;
  _PLItem(this.label, this.amount, this.isPositive, this.color);
}

class _CostItem {
  final String label;
  final double amount;
  final Color color;
  _CostItem(this.label, this.amount, this.color);
}
