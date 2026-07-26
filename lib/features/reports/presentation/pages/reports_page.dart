import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _period = 1; // 0=daily, 1=weekly, 2=monthly
  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reports.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf_outlined), onPressed: () {}, tooltip: 'reports.export_pdf'.tr()),
          IconButton(icon: const Icon(Icons.table_chart_outlined), onPressed: () {}, tooltip: 'reports.export_excel'.tr()),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(controller: _tab, isScrollable: true, onTap: (_) => setState(() {}),
              tabs: ['Sales', 'Inventory', 'Employees', 'Customers'].map((t) => Tab(text: t)).toList()),
        ),
      ),
      body: Column(children: [
        // Period chips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            ...['reports.daily', 'reports.weekly', 'reports.monthly'].asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(e.value.tr()),
                selected: _period == e.key,
                onSelected: (_) => setState(() => _period = e.key),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _period == e.key ? Colors.white : null, fontSize: 12),
              ),
            )),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: [
          _buildSalesReport(),
          _buildInventoryReport(),
          _buildEmployeeReport(),
          _buildCustomerReport(),
        ])),
      ]),
    );
  }

  Widget _buildSalesReport() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6,
        children: [
          KpiCard(title: 'reports.revenue'.tr(), value: 'SAR 284K', icon: Icons.trending_up, color: AppColors.kpiGreen, change: 14.2, isPositiveChange: true),
          KpiCard(title: 'reports.total_orders'.tr(), value: '2,847', icon: Icons.receipt_long_outlined, color: AppColors.kpiBlue, change: 8, isPositiveChange: true),
          KpiCard(title: 'Avg Order Value', value: 'SAR 99.8', icon: Icons.shopping_bag_outlined, color: AppColors.kpiPurple),
          KpiCard(title: 'Cancellation Rate', value: '3.2%', icon: Icons.cancel_outlined, color: AppColors.error, change: 0.5, isPositiveChange: false),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'reports.sales_report'.tr()),
      const SizedBox(height: 12),
      Container(height: 200, padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
        child: LineChart(LineChartData(
          gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: isDark ? AppColors.borderDark : AppColors.borderLight, strokeWidth: 1)),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (v, _) {
              final labels = ['W1', 'W2', 'W3', 'W4'];
              final i = v.toInt();
              if (i < 0 || i >= labels.length) return const SizedBox();
              return Padding(padding: const EdgeInsets.only(top: 6), child: Text(labels[i], style: const TextStyle(fontSize: 11)));
            })),
          ),
          lineBarsData: [
            LineChartBarData(spots: [const FlSpot(0, 62), const FlSpot(1, 74), const FlSpot(2, 68), const FlSpot(3, 80)],
              isCurved: true, color: AppColors.primary, barWidth: 2.5, dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.15), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
            LineChartBarData(spots: [const FlSpot(0, 48), const FlSpot(1, 52), const FlSpot(2, 50), const FlSpot(3, 56)],
              isCurved: true, color: AppColors.kpiGreen, barWidth: 2, dotData: const FlDotData(show: false)),
          ],
        )),
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'reports.top_products'.tr()),
      const SizedBox(height: 12),
      _buildTopProductsTable(isDark),
      const SizedBox(height: 20),
      SectionHeader(title: 'reports.peak_hours'.tr()),
      const SizedBox(height: 12),
      _buildPeakHours(isDark),
    ]);
  }

  Widget _buildTopProductsTable(bool isDark) {
    final products = [
      ['Grilled Chicken', '847', 'SAR 72,000', '25.3%'],
      ['Beef Burger', '634', 'SAR 44,000', '15.5%'],
      ['Caesar Salad', '521', 'SAR 26,000', '9.2%'],
      ['Pasta Carbonara', '489', 'SAR 34,000', '12.0%'],
      ['Chocolate Lava', '412', 'SAR 20,000', '7.0%'],
    ];
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: Column(children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: isDark ? AppColors.surfaceDark : const Color(0xFFF9FAFB),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
          child: const Row(children: [
            SizedBox(width: 24, child: Text('#', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight))),
            SizedBox(width: 8),
            Expanded(child: Text('Product', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
            SizedBox(width: 50, child: Text('Orders', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
            SizedBox(width: 70, child: Text('Revenue', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.end)),
            SizedBox(width: 40, child: Text('Share', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.end)),
          ])),
        ...products.asMap().entries.map((e) {
          final p = e.value; final isLast = e.key == products.length - 1;
          return Column(children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                SizedBox(width: 24, child: Text('${e.key + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.chartColors[e.key % AppColors.chartColors.length]))),
                const SizedBox(width: 8),
                Expanded(child: Text(p[0], style: const TextStyle(fontSize: 13))),
                SizedBox(width: 50, child: Text(p[1], style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                SizedBox(width: 70, child: Text(p[2], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.end)),
                SizedBox(width: 40, child: Text(p[3], style: TextStyle(fontSize: 11, color: AppColors.kpiGreen, fontWeight: FontWeight.w600), textAlign: TextAlign.end)),
              ])),
            if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ]);
        }),
      ]),
    );
  }

  Widget _buildPeakHours(bool isDark) {
    final hours = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];
    final values = [0.2, 0.3, 0.4, 0.7, 0.95, 1.0, 0.85, 0.6, 0.4, 0.5, 0.7, 0.9, 0.95, 0.8, 0.5];
    return Container(height: 120, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: BarChart(BarChartData(
        barGroups: List.generate(hours.length, (i) => BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: values[i], color: values[i] >= 0.9 ? AppColors.error : values[i] >= 0.6 ? AppColors.warning : AppColors.kpiBlue,
            width: 14, borderRadius: BorderRadius.circular(3)),
        ])),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 18, getTitlesWidget: (v, _) {
            final i = v.toInt();
            if (i % 2 != 0) return const SizedBox();
            return Text('${hours[i]}', style: const TextStyle(fontSize: 10));
          })),
        ),
      )),
    );
  }

  Widget _buildInventoryReport() {
    return const Center(child: Text('Inventory Report — coming soon'));
  }

  Widget _buildEmployeeReport() {
    return const Center(child: Text('Employee Report — coming soon'));
  }

  Widget _buildCustomerReport() {
    return const Center(child: Text('Customer Report — coming soon'));
  }
}
