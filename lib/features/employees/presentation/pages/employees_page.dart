import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});
  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  final _employees = [
    _Employee('Hassan Ali', 'Head Chef', 'Kitchen', 'Present', AppColors.success, '08:02 AM', 4.9, true),
    _Employee('Ahmed Mohammed', 'Waiter', 'Front of House', 'Present', AppColors.success, '08:15 AM', 4.7, false),
    _Employee('Sara Khalid', 'Cashier', 'Front of House', 'Present', AppColors.success, '09:00 AM', 4.5, false),
    _Employee('Omar Nasser', 'Sous Chef', 'Kitchen', 'Present', AppColors.success, '07:45 AM', 4.8, false),
    _Employee('Fatima Rashid', 'Waiter', 'Front of House', 'On Leave', AppColors.kpiOrange, '—', 4.3, false),
    _Employee('Khalid Abdullah', 'Delivery', 'Delivery', 'Absent', AppColors.error, '—', 3.8, false),
    _Employee('Noura Hassan', 'Inventory', 'Storage', 'Present', AppColors.success, '08:30 AM', 4.6, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('employees.title'.tr()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(controller: _tab, isScrollable: true,
              tabs: ['Staff', 'Attendance', 'Schedule', 'Payroll'].map((t) => Tab(text: t)).toList()),
        ),
      ),
      body: TabBarView(controller: _tab, children: [
        _buildStaffTab(),
        _buildAttendanceTab(),
        _buildScheduleTab(),
        _buildPayrollTab(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildStaffTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(children: [
          Expanded(child: AppSearchBar(hintText: 'Search staff...')),
        ]),
      ),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _employees.length,
        itemBuilder: (ctx, i) {
          final e = _employees[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(children: [
              Stack(children: [
                CircleAvatar(radius: 22, backgroundColor: e.statusColor.withOpacity(0.12),
                  child: Text(e.name.substring(0, 1), style: TextStyle(fontWeight: FontWeight.w700, color: e.statusColor, fontSize: 16))),
                if (e.isTopPerformer) Positioned(bottom: 0, right: 0,
                  child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: AppColors.kpiOrange, shape: BoxShape.circle),
                    child: const Icon(Icons.star, size: 8, color: Colors.white))),
              ]),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text('${e.role} · ${e.department}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star, size: 12, color: AppColors.kpiOrange),
                  const SizedBox(width: 2),
                  Text(e.rating.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                StatusBadge(label: e.status, color: e.statusColor),
                const SizedBox(height: 6),
                if (e.checkIn != '—') Text(e.checkIn, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              ]),
            ]),
          );
        },
      )),
    ]);
  }

  Widget _buildAttendanceTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final present = _employees.where((e) => e.status == 'Present').length;
    final absent = _employees.where((e) => e.status == 'Absent').length;
    final onLeave = _employees.where((e) => e.status == 'On Leave').length;
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4,
        children: [
          _attCard('Present', present.toString(), AppColors.success),
          _attCard('Absent', absent.toString(), AppColors.error),
          _attCard('On Leave', onLeave.toString(), AppColors.warning),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'Today\'s Attendance'),
      const SizedBox(height: 12),
      ..._employees.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(children: [
          CircleAvatar(radius: 16, backgroundColor: e.statusColor.withOpacity(0.12),
            child: Text(e.name.substring(0, 1), style: TextStyle(color: e.statusColor, fontWeight: FontWeight.w600))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            Text(e.role, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          ])),
          if (e.checkIn != '—') Row(children: [
            const Icon(Icons.login, size: 12, color: AppColors.success),
            const SizedBox(width: 4),
            Text(e.checkIn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(width: 10),
          StatusBadge(label: e.status, color: e.statusColor),
        ]),
      )),
    ]);
  }

  Widget _attCard(String label, String value, Color color) {
    return Container(padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ]));
  }

  Widget _buildScheduleTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final shifts = ['Morning 6-2', 'Afternoon 2-10', 'Night 10-6'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        SectionHeader(title: 'This Week\'s Schedule', actionLabel: 'Edit', onAction: () {}),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
          child: Column(children: [
            // Header row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
              child: Row(children: [
                const SizedBox(width: 80),
                ...days.map((d) => Expanded(child: Text(d, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)))),
              ]),
            ),
            // Shift rows
            ...shifts.asMap().entries.map((entry) {
              final si = entry.key; final shift = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight))),
                child: Row(children: [
                  SizedBox(width: 80, child: Text(shift, style: const TextStyle(fontSize: 10))),
                  ...List.generate(7, (di) {
                    final hasStaff = (si + di) % 3 != 2;
                    return Expanded(child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: hasStaff ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(4)),
                      child: Text(hasStaff ? '${2 + si}' : '—',
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 10,
                              color: hasStaff ? AppColors.primary : (isDark ? AppColors.textHintDark : AppColors.textHintLight))),
                    ));
                  }),
                ]),
              );
            }),
          ]),
        ),
      ]),
    );
  }

  Widget _buildPayrollTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(padding: const EdgeInsets.all(16), children: [
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6,
        children: [
          KpiCard(title: 'Total Payroll', value: 'SAR 42K', icon: Icons.payments_outlined, color: AppColors.kpiBlue),
          KpiCard(title: 'Overtime', value: 'SAR 3,200', icon: Icons.timer_outlined, color: AppColors.warning, change: 12, isPositiveChange: false),
          KpiCard(title: 'Deductions', value: 'SAR 1,800', icon: Icons.remove_circle_outline, color: AppColors.error),
          KpiCard(title: 'Net Payroll', value: 'SAR 43.4K', icon: Icons.account_balance_outlined, color: AppColors.kpiGreen),
        ],
      ),
      const SizedBox(height: 20),
      SectionHeader(title: 'Payroll Summary — July 2026'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
        child: Column(children: _employees.asMap().entries.map((e) {
          final emp = e.value; final isLast = e.key == _employees.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(children: [
                CircleAvatar(radius: 16, backgroundColor: emp.statusColor.withOpacity(0.12),
                  child: Text(emp.name.substring(0, 1), style: TextStyle(color: emp.statusColor, fontWeight: FontWeight.w600, fontSize: 12))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(emp.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  Text(emp.role, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                ])),
                Text('SAR ${(4000 + e.key * 800)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primary)),
              ]),
            ),
            if (!isLast) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ]);
        }).toList()),
      ),
    ]);
  }
}

class _Employee {
  final String name, role, department, status, checkIn; final Color statusColor; final double rating; final bool isTopPerformer;
  _Employee(this.name, this.role, this.department, this.status, this.statusColor, this.checkIn, this.rating, this.isTopPerformer);
}
