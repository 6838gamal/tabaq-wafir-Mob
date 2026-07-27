import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _selectedDate = 'Today';

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

  final _records = [
    _AttendRecord('Hassan Ali', 'Head Chef', '08:02', '—', 'Present', AppColors.success, 4.9),
    _AttendRecord('Ahmed Mohammed', 'Waiter', '08:15', '—', 'Present', AppColors.success, 4.7),
    _AttendRecord('Sara Khalid', 'Cashier', '09:00', '—', 'Present', AppColors.success, 4.5),
    _AttendRecord('Omar Nasser', 'Sous Chef', '07:45', '—', 'Present', AppColors.success, 4.8),
    _AttendRecord('Fatima Rashid', 'Waiter', '—', '—', 'On Leave', AppColors.kpiOrange, 4.3),
    _AttendRecord('Khalid Abdullah', 'Delivery', '—', '—', 'Absent', AppColors.error, 3.8),
    _AttendRecord('Noura Hassan', 'Inventory', '08:30', '—', 'Present', AppColors.success, 4.6),
    _AttendRecord('Yasser Ibrahim', 'Kitchen', '09:45', '—', 'Late', AppColors.warning, 4.0),
    _AttendRecord('Mona Al-Zahra', 'Hostess', '08:00', '—', 'Present', AppColors.success, 4.8),
    _AttendRecord('Rania Saleh', 'Waiter', '—', '—', 'Absent', AppColors.error, 4.1),
  ];

  int get _present => _records.where((r) => r.status == 'Present').length;
  int get _absent => _records.where((r) => r.status == 'Absent').length;
  int get _late => _records.where((r) => r.status == 'Late').length;
  int get _onLeave => _records.where((r) => r.status == 'On Leave').length;

  List<_AttendRecord> get _filtered {
    final idx = _tab.index;
    if (idx == 1) return _records.where((r) => r.status == 'Present' || r.status == 'Late').toList();
    if (idx == 2) return _records.where((r) => r.status == 'Absent' || r.status == 'On Leave').toList();
    return _records;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('attendance.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.calendar_today_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            onTap: (_) => setState(() {}),
            tabs: ['All (${_records.length})', 'Present ($_present)', 'Absent ($_absent)']
                .map((t) => Tab(text: t))
                .toList(),
          ),
        ),
      ),
      body: Column(children: [
        // Date + Summary
        Container(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(children: [
            // Date chips
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primary),
              const SizedBox(width: 8),
              ...['Today', 'Yesterday', 'This Week'].map((d) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(d),
                  selected: _selectedDate == d,
                  onSelected: (_) => setState(() => _selectedDate = d),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _selectedDate == d ? Colors.white : null, fontSize: 11),
                ),
              )),
            ]),
            const SizedBox(height: 10),
            // Summary chips
            Row(children: [
              _chip('Present', _present, AppColors.kpiGreen),
              const SizedBox(width: 8),
              _chip('Late', _late, AppColors.warning),
              const SizedBox(width: 8),
              _chip('Absent', _absent, AppColors.error),
              const SizedBox(width: 8),
              _chip('On Leave', _onLeave, AppColors.kpiOrange),
            ]),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Attendance donut
              _buildAttendanceChart(isDark),
              const SizedBox(height: 20),
              SectionHeader(title: 'attendance.staff_log'.tr()),
              const SizedBox(height: 12),
              ..._filtered.map((r) => _buildRecord(r, isDark)),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _chip(String label, int count, Color color) {
    return Chip(
      avatar: Container(
        width: 16, height: 16,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
      ),
      label: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      backgroundColor: color.withOpacity(0.08),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildAttendanceChart(bool isDark) {
    final total = _records.length.toDouble();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        SizedBox(
          width: 100, height: 100,
          child: PieChart(PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 28,
            centerSpaceColor: isDark ? AppColors.cardDark : AppColors.cardLight,
            sections: [
              PieChartSectionData(color: AppColors.kpiGreen, value: _present.toDouble(), title: '', radius: 36),
              PieChartSectionData(color: AppColors.warning, value: _late.toDouble(), title: '', radius: 36),
              PieChartSectionData(color: AppColors.error, value: _absent.toDouble(), title: '', radius: 36),
              PieChartSectionData(color: AppColors.kpiOrange, value: _onLeave.toDouble(), title: '', radius: 36),
            ],
          )),
        ),
        const SizedBox(width: 20),
        Expanded(child: Column(children: [
          _chartRow('Present', _present, total, AppColors.kpiGreen),
          const SizedBox(height: 8),
          _chartRow('Late', _late, total, AppColors.warning),
          const SizedBox(height: 8),
          _chartRow('Absent', _absent, total, AppColors.error),
          const SizedBox(height: 8),
          _chartRow('On Leave', _onLeave, total, AppColors.kpiOrange),
        ])),
      ]),
    );
  }

  Widget _chartRow(String label, int count, double total, Color color) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
      Text('$count', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
      const SizedBox(width: 6),
      Text('(${(count / total * 100).toStringAsFixed(0)}%)',
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
    ]);
  }

  Widget _buildRecord(_AttendRecord r, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: r.statusColor.withOpacity(0.12),
          child: Text(r.name.substring(0, 1),
              style: TextStyle(fontWeight: FontWeight.w700, color: r.statusColor)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(r.role, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          StatusBadge(label: r.status, color: r.statusColor),
          const SizedBox(height: 4),
          Row(children: [
            if (r.checkIn != '—') ...[
              const Icon(Icons.login, size: 11, color: AppColors.kpiGreen),
              const SizedBox(width: 3),
              Text(r.checkIn, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              const SizedBox(width: 8),
            ],
            if (r.checkOut != '—') ...[
              const Icon(Icons.logout, size: 11, color: AppColors.error),
              const SizedBox(width: 3),
              Text(r.checkOut, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
            ],
          ]),
        ]),
      ]),
    );
  }
}

class _AttendRecord {
  final String name, role, checkIn, checkOut, status;
  final Color statusColor;
  final double rating;
  _AttendRecord(this.name, this.role, this.checkIn, this.checkOut, this.status, this.statusColor, this.rating);
}
