import 'package:flutter/material.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/restaurant_table.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});
  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _selectedFloor = 'Ground Floor';
  final _floors = ['Ground Floor', '1st Floor', 'Terrace'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  final List<_TableData> _tables = [
    _TableData('T01', 4, TableStatus.occupied, '45m', 'Dine-in', 'Order #1247'),
    _TableData('T02', 2, TableStatus.available, null, 'Dine-in', null),
    _TableData('T03', 6, TableStatus.reserved, '7:30 PM', 'Reserved', 'Sara Al-Otaibi'),
    _TableData('T04', 4, TableStatus.occupied, '20m', 'Dine-in', 'Order #1245'),
    _TableData('T05', 8, TableStatus.available, null, 'Dine-in', null),
    _TableData('T06', 2, TableStatus.cleaning, null, 'Cleaning', null),
    _TableData('T07', 4, TableStatus.occupied, '62m', 'Dine-in', 'Order #1243'),
    _TableData('T08', 6, TableStatus.reserved, '8:00 PM', 'Reserved', 'Khalid Rashidi'),
    _TableData('T09', 4, TableStatus.available, null, 'Dine-in', null),
    _TableData('T10', 2, TableStatus.occupied, '15m', 'Dine-in', 'Order #1248'),
    _TableData('T11', 10, TableStatus.available, null, 'Private', null),
    _TableData('T12', 4, TableStatus.occupied, '38m', 'Dine-in', 'Order #1242'),
    _TableData('T13', 2, TableStatus.cleaning, null, 'Cleaning', null),
    _TableData('T14', 8, TableStatus.reserved, '9:00 PM', 'Reserved', 'Ahmed Qasim'),
  ];

  int get _available => _tables.where((t) => t.status == TableStatus.available).length;
  int get _occupied => _tables.where((t) => t.status == TableStatus.occupied).length;
  int get _reserved => _tables.where((t) => t.status == TableStatus.reserved).length;
  int get _cleaning => _tables.where((t) => t.status == TableStatus.cleaning).length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('tables.title'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.add_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            controller: _tab,
            tabs: ['Floor Plan', 'List View'].map((t) => Tab(text: t)).toList(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Status legend + summary
          Container(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(children: [
              _legend('Available', _available, AppColors.kpiGreen),
              const SizedBox(width: 12),
              _legend('Occupied', _occupied, AppColors.error),
              const SizedBox(width: 12),
              _legend('Reserved', _reserved, AppColors.warning),
              const SizedBox(width: 12),
              _legend('Cleaning', _cleaning, AppColors.kpiBlue),
            ]),
          ),
          // Floor selector
          Container(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: _floors.map((f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f),
                  selected: _selectedFloor == f,
                  onSelected: (_) => setState(() => _selectedFloor = f),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _selectedFloor == f ? Colors.white : null, fontSize: 12),
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _buildFloorPlan(isDark),
                _buildListView(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorPlan(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: _tables.length,
      itemBuilder: (ctx, i) {
        final t = _tables[i];
        final color = _statusColor(t.status);
        return GestureDetector(
          onTap: () => _showTableDetail(context, t),
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(_statusIcon(t.status), color: color, size: 22),
              const SizedBox(height: 6),
              Text(t.number,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color)),
              Text('${t.capacity} seats',
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
              if (t.timer != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(t.timer!,
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: _isOverdue(t.timer) ? AppColors.error : AppColors.textSecondaryLight,
                      )),
                ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildListView(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tables.length,
      itemBuilder: (ctx, i) {
        final t = _tables[i];
        final color = _statusColor(t.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(_statusIcon(t.status), color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Table ${t.number}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(width: 8),
                StatusBadge(label: t.statusLabel, color: color),
              ]),
              const SizedBox(height: 3),
              Text('${t.capacity} seats · ${t.type}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
              if (t.detail != null)
                Text(t.detail!, style: TextStyle(fontSize: 12, color: color)),
            ])),
            if (t.status == TableStatus.available)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                ),
                child: const Text('Seat', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
          ]),
        );
      },
    );
  }

  void _showTableDetail(BuildContext context, _TableData t) {
    final color = _statusColor(t.status);
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(_statusIcon(t.status), color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Table ${t.number}', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              StatusBadge(label: t.statusLabel, color: color),
            ]),
          ]),
          const SizedBox(height: 20),
          _detailRow('Capacity', '${t.capacity} seats', Icons.people_outline),
          _detailRow('Type', t.type, Icons.category_outlined),
          if (t.detail != null) _detailRow('Info', t.detail!, Icons.info_outline),
          if (t.timer != null) _detailRow('Time', t.timer!, Icons.timer_outlined),
          const SizedBox(height: 20),
          Row(children: [
            if (t.status == TableStatus.occupied)
              Expanded(child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 16),
                label: const Text('View Order', style: TextStyle(color: Colors.white)),
              )),
            if (t.status == TableStatus.available) ...[
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Reserve'),
              )),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Seat Guests', style: TextStyle(color: Colors.white)),
              )),
            ],
          ]),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ]),
    );
  }

  Widget _legend(String label, int count, Color color) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text('$count $label', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    ]);
  }

  Color _statusColor(TableStatus s) {
    switch (s) {
      case TableStatus.available: return AppColors.kpiGreen;
      case TableStatus.occupied: return AppColors.error;
      case TableStatus.reserved: return AppColors.warning;
      case TableStatus.cleaning: return AppColors.kpiBlue;
      default: return AppColors.textSecondaryLight;
    }
  }

  IconData _statusIcon(TableStatus s) {
    switch (s) {
      case TableStatus.available: return Icons.check_circle_outline;
      case TableStatus.occupied: return Icons.restaurant_outlined;
      case TableStatus.reserved: return Icons.event_outlined;
      case TableStatus.cleaning: return Icons.cleaning_services_outlined;
      default: return Icons.block_outlined;
    }
  }

  bool _isOverdue(String? timer) {
    if (timer == null) return false;
    final m = int.tryParse(timer.replaceAll('m', '')) ?? 0;
    return m > 60;
  }
}

class _TableData {
  final String number, type;
  final int capacity;
  final TableStatus status;
  final String? timer, detail;
  _TableData(this.number, this.capacity, this.status, this.timer, this.type, this.detail);
  String get statusLabel {
    switch (status) {
      case TableStatus.available: return 'Available';
      case TableStatus.occupied: return 'Occupied';
      case TableStatus.reserved: return 'Reserved';
      case TableStatus.cleaning: return 'Cleaning';
      default: return 'Blocked';
    }
  }
}
