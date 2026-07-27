import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _period = 2; // default: 30 days

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('analytics.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            tabs: ['Revenue', 'Products', 'Peak Hours', 'Customers'].map((t) => Tab(text: t)).toList(),
          ),
        ),
      ),
      body: Column(children: [
        // Period selector
        Container(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            ...['7 Days', '30 Days', '90 Days', '1 Year'].asMap().entries.map((e) => Padding(
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
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildRevenueTab(isDark),
              _buildProductsTab(isDark),
              _buildPeakHoursTab(isDark),
              _buildCustomersTab(isDark),
            ],
          ),
        ),
      ]),
    );
  }

  // ─── Revenue Tab ────────────────────────────────────────────────────────────
  Widget _buildRevenueTab(bool isDark) {
    final data = [42, 55, 38, 62, 58, 71, 68, 80, 74, 66, 85, 79, 92, 88];
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
        children: [
          KpiCard(title: 'Total Revenue', value: 'SAR 284K', icon: Icons.trending_up, color: AppColors.kpiGreen, change: 14.2, isPositiveChange: true),
          KpiCard(title: 'Avg Daily Revenue', value: 'SAR 9.5K', icon: Icons.bar_chart_outlined, color: AppColors.kpiBlue),
          KpiCard(title: 'Best Day', value: 'SAR 18.4K', icon: Icons.star_outlined, color: AppColors.kpiOrange),
          KpiCard(title: 'Revenue Growth', value: '+14.2%', icon: Icons.show_chart_outlined, color: AppColors.kpiPurple, change: 14.2, isPositiveChange: true),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'analytics.revenue_trend'.tr()),
      const SizedBox(height: 12),
      _buildLineChart(data, AppColors.kpiGreen, isDark, 'Revenue (SAR K)'),
      const SizedBox(height: 20),
      SectionHeader(title: 'analytics.revenue_by_channel'.tr()),
      const SizedBox(height: 12),
      _buildChannelBreakdown(isDark),
    ]);
  }

  Widget _buildChannelBreakdown(bool isDark) {
    final channels = [
      _ChannelData('Dine-in', 0.52, AppColors.kpiBlue),
      _ChannelData('Delivery', 0.30, AppColors.kpiPurple),
      _ChannelData('Pickup', 0.18, AppColors.kpiTeal),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: channels.map((c) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(c.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text('${(c.share * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.color)),
              const SizedBox(width: 6),
              Text('SAR ${(284 * c.share).toStringAsFixed(0)}K',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: c.share,
                backgroundColor: c.color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(c.color),
                minHeight: 8,
              ),
            ),
          ]),
        );
      }).toList()),
    );
  }

  // ─── Products Tab ───────────────────────────────────────────────────────────
  Widget _buildProductsTab(bool isDark) {
    final topItems = [
      _ProductData('Grilled Chicken', 842, 57256, 0.68),
      _ProductData('Beef Burger', 720, 38880, 0.54),
      _ProductData('Lamb Kofta', 610, 51240, 0.72),
      _ProductData('Saffron Rice', 590, 18880, 0.82),
      _ProductData('Chicken Shawarma', 540, 22680, 0.61),
      _ProductData('Chocolate Lava Cake', 410, 13940, 0.78),
      _ProductData('Caesar Salad', 380, 14440, 0.71),
      _ProductData('Lemonade', 920, 16560, 0.88),
    ];
    final colors = AppColors.chartColors;
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
        children: [
          KpiCard(title: 'Items Sold', value: '6,014', icon: Icons.restaurant_menu_outlined, color: AppColors.kpiBlue),
          KpiCard(title: 'Top Item Revenue', value: 'SAR 57K', icon: Icons.star_outlined, color: AppColors.kpiOrange),
          KpiCard(title: 'Avg Item Margin', value: '71.8%', icon: Icons.percent_outlined, color: AppColors.kpiGreen, change: 2.1, isPositiveChange: true),
          KpiCard(title: 'SKUs Active', value: '48', icon: Icons.inventory_2_outlined, color: AppColors.kpiPurple),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'analytics.top_products'.tr()),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          children: topItems.asMap().entries.map((e) {
            final p = e.value;
            final isLast = e.key == topItems.length - 1;
            final color = colors[e.key % colors.length];
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                    child: Center(child: Text('${e.key + 1}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text('${p.orders} orders · ${(p.margin * 100).toStringAsFixed(0)}% margin',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                  ])),
                  Text('SAR ${(p.revenue / 1000).toStringAsFixed(1)}K',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
                ]),
              ),
              if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ]);
          }).toList(),
        ),
      ),
    ]);
  }

  // ─── Peak Hours Tab ─────────────────────────────────────────────────────────
  Widget _buildPeakHoursTab(bool isDark) {
    final hours = List.generate(16, (i) => i + 7);
    final values = [0.1, 0.2, 0.35, 0.5, 0.75, 1.0, 0.95, 0.8, 0.55, 0.45, 0.6, 0.85, 0.95, 0.9, 0.7, 0.4];
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
        children: [
          KpiCard(title: 'Peak Hour', value: '12:00 PM', icon: Icons.schedule_outlined, color: AppColors.kpiOrange),
          KpiCard(title: 'Busiest Day', value: 'Friday', icon: Icons.calendar_today_outlined, color: AppColors.kpiBlue),
          KpiCard(title: 'Avg Wait Time', value: '12 min', icon: Icons.timer_outlined, color: AppColors.warning),
          KpiCard(title: 'Table Turnover', value: '3.2×/day', icon: Icons.table_restaurant_outlined, color: AppColors.kpiGreen),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'analytics.hourly_traffic'.tr()),
      const SizedBox(height: 12),
      Container(
        height: 180, padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: BarChart(BarChartData(
          barGroups: List.generate(hours.length, (i) => BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: values[i],
              color: values[i] >= 0.9 ? AppColors.error : values[i] >= 0.6 ? AppColors.warning : AppColors.kpiBlue,
              width: 16, borderRadius: BorderRadius.circular(4),
            ),
          ])),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(
              showTitles: true, reservedSize: 20,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i % 2 != 0) return const SizedBox();
                final h = hours[i % hours.length];
                return Text('${h}h', style: const TextStyle(fontSize: 10));
              },
            )),
          ),
        )),
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'analytics.busiest_days'.tr()),
      const SizedBox(height: 12),
      _buildDayBreakdown(isDark),
    ]);
  }

  Widget _buildDayBreakdown(bool isDark) {
    final days = [
      ('Saturday', 0.95, AppColors.error),
      ('Friday', 0.90, AppColors.error),
      ('Thursday', 0.78, AppColors.warning),
      ('Sunday', 0.65, AppColors.kpiGreen),
      ('Monday', 0.52, AppColors.kpiGreen),
      ('Tuesday', 0.48, AppColors.kpiBlue),
      ('Wednesday', 0.44, AppColors.kpiBlue),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: days.map((d) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          SizedBox(width: 80, child: Text(d.$1, style: const TextStyle(fontSize: 12))),
          Expanded(child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: d.$2,
              backgroundColor: d.$3.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(d.$3),
              minHeight: 10,
            ),
          )),
          const SizedBox(width: 10),
          Text('${(d.$2 * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: d.$3)),
        ]),
      )).toList()),
    );
  }

  // ─── Customers Tab ──────────────────────────────────────────────────────────
  Widget _buildCustomersTab(bool isDark) {
    final retentionData = [62, 68, 71, 65, 74, 78, 72, 80, 76, 82, 79, 85, 88, 84];
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.7,
        children: [
          KpiCard(title: 'Total Customers', value: '1,284', icon: Icons.people_outline, color: AppColors.kpiBlue, change: 9.3, isPositiveChange: true),
          KpiCard(title: 'New This Month', value: '142', icon: Icons.person_add_outlined, color: AppColors.kpiGreen),
          KpiCard(title: 'Retention Rate', value: '68.4%', icon: Icons.loop_outlined, color: AppColors.kpiPurple, change: 4.1, isPositiveChange: true),
          KpiCard(title: 'Avg Lifetime Value', value: 'SAR 4,200', icon: Icons.star_outlined, color: AppColors.kpiOrange),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'analytics.customer_retention'.tr()),
      const SizedBox(height: 12),
      _buildLineChart(retentionData, AppColors.kpiPurple, isDark, 'Retention (%)'),
      const SizedBox(height: 20),
      SectionHeader(title: 'analytics.customer_segments'.tr()),
      const SizedBox(height: 12),
      _buildSegmentChart(isDark),
    ]);
  }

  Widget _buildSegmentChart(bool isDark) {
    final segments = [
      ('VIP', 0.12, AppColors.kpiPurple),
      ('Regular', 0.45, AppColors.kpiBlue),
      ('Occasional', 0.28, AppColors.kpiGreen),
      ('New', 0.15, AppColors.kpiOrange),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        SizedBox(
          width: 110, height: 110,
          child: PieChart(PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 28,
            sections: segments.map((s) => PieChartSectionData(
              color: s.$3,
              value: s.$2,
              title: '',
              radius: 38,
            )).toList(),
          )),
        ),
        const SizedBox(width: 20),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: segments.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: s.$3, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(child: Text(s.$1, style: const TextStyle(fontSize: 12))),
              Text('${(s.$2 * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: s.$3)),
            ]),
          )).toList(),
        )),
      ]),
    );
  }

  // ─── Shared chart helper ────────────────────────────────────────────────────
  Widget _buildLineChart(List<int> data, Color color, bool isDark, String label) {
    return Container(
      height: 180, padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: LineChart(LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
              color: isDark ? AppColors.borderDark : AppColors.borderLight, strokeWidth: 0.5),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
            isCurved: true,
            color: color,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
      )),
    );
  }
}

class _ChannelData {
  final String label;
  final double share;
  final Color color;
  _ChannelData(this.label, this.share, this.color);
}

class _ProductData {
  final String name;
  final int orders;
  final double revenue, margin;
  _ProductData(this.name, this.orders, this.revenue, this.margin);
}
