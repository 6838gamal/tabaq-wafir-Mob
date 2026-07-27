import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/models/branch_model.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});
  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  final _branches = [
    _BranchData('Main Branch', 'Riyadh — Al Olaya', true, 'SAR 24,800', 18, 12, 4.8, 0.92),
    _BranchData('North Branch', 'Riyadh — Al Nakheel', true, 'SAR 18,400', 14, 9, 4.6, 0.88),
    _BranchData('South Branch', 'Jeddah — Al Hamra', false, 'SAR 0', 0, 0, 4.3, 0.0),
    _BranchData('West Branch', 'Jeddah — Al Rawdah', true, 'SAR 14,200', 11, 7, 4.7, 0.85),
    _BranchData('East Branch', 'Dammam — Al Faisaliyah', true, 'SAR 9,600', 8, 5, 4.4, 0.79),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBranches = _branches.where((b) => b.isOpen).length;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('branches.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddSheet(context)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary row
          Row(children: [
            Expanded(child: _kpi('Active', '$activeBranches / ${_branches.length}', AppColors.kpiGreen, Icons.store_outlined)),
            const SizedBox(width: 10),
            Expanded(child: _kpi('Total Revenue', 'SAR 67K', AppColors.kpiBlue, Icons.trending_up)),
            const SizedBox(width: 10),
            Expanded(child: _kpi('Total Staff', '${_branches.fold(0, (s, b) => s + b.totalStaff)}', AppColors.kpiPurple, Icons.people_outline)),
          ]),
          const SizedBox(height: 20),
          SectionHeader(title: 'branches.all_branches'.tr()),
          const SizedBox(height: 12),
          ..._branches.map((b) => _buildBranchCard(b, isDark)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business_outlined, color: Colors.white),
        label: Text('branches.add'.tr(), style: const TextStyle(color: Colors.white)),
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

  Widget _buildBranchCard(_BranchData b, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            color: (b.isOpen ? AppColors.kpiGreen : AppColors.textSecondaryLight).withOpacity(0.06),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: (b.isOpen ? AppColors.kpiGreen : AppColors.textSecondaryLight).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.store_outlined,
                  color: b.isOpen ? AppColors.kpiGreen : AppColors.textSecondaryLight, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textSecondaryLight),
                const SizedBox(width: 4),
                Text(b.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              StatusBadge(
                label: b.isOpen ? 'Open' : 'Closed',
                color: b.isOpen ? AppColors.success : AppColors.textSecondaryLight,
              ),
              const SizedBox(height: 6),
              Switch(
                value: b.isOpen,
                onChanged: (v) => setState(() => b.isOpen = v),
                activeColor: AppColors.kpiGreen,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ]),
          ]),
        ),
        // Stats
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(children: [
            _statCell('Revenue Today', b.revenueToday, AppColors.kpiGreen),
            _divider(),
            _statCell('Staff', '${b.totalStaff} total · ${b.staffOnDuty} on duty', AppColors.kpiBlue),
            _divider(),
            _statCell('Rating', '⭐ ${b.rating.toStringAsFixed(1)}', AppColors.kpiOrange),
          ]),
        ),
        // Capacity bar
        if (b.isOpen)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Capacity', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                Text('${(b.capacity * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: b.capacity > 0.8 ? AppColors.error : AppColors.kpiGreen,
                    )),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: b.capacity,
                  backgroundColor: AppColors.kpiGreen.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    b.capacity > 0.8 ? AppColors.error : AppColors.kpiGreen),
                  minHeight: 6,
                ),
              ),
            ]),
          ),
      ]),
    );
  }

  Widget _statCell(String label, String value, Color color) {
    return Expanded(child: Column(children: [
      Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
          textAlign: TextAlign.center),
    ]));
  }

  Widget _divider() {
    return Container(width: 1, height: 32, color: AppColors.borderLight);
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('branches.add'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Branch Name', prefixIcon: Icon(Icons.store_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Manager Name', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: Text('common.save'.tr()))),
        ]),
      ),
    );
  }
}

class _BranchData {
  final String name, address, revenueToday;
  bool isOpen;
  final int totalStaff, staffOnDuty;
  final double rating, capacity;
  _BranchData(this.name, this.address, this.isOpen, this.revenueToday,
      this.totalStaff, this.staffOnDuty, this.rating, this.capacity);
}
