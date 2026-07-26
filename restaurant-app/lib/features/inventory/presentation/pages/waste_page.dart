import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class WastePage extends ConsumerStatefulWidget {
  const WastePage({super.key});

  @override
  ConsumerState<WastePage> createState() => _WastePageState();
}

class _WastePageState extends ConsumerState<WastePage> {
  final List<_WasteLog> _logs = [
    _WasteLog('Bread Rolls', 12, 'pcs', 'Expired', 'Bakery', 2.5, DateTime.now()),
    _WasteLog('Grilled Chicken', 0.8, 'kg', 'Overcooked', 'Kitchen', 25.6, DateTime.now().subtract(const Duration(hours: 3))),
    _WasteLog('Heavy Cream', 0.3, 'L', 'Spoiled', 'Storage', 6.6, DateTime.now().subtract(const Duration(days: 1))),
    _WasteLog('Tomatoes', 1.5, 'kg', 'Damaged', 'Storage', 9.0, DateTime.now().subtract(const Duration(days: 1))),
    _WasteLog('Rice', 2.0, 'kg', 'Excess Prep', 'Kitchen', 17.0, DateTime.now().subtract(const Duration(days: 2))),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalWasteValue = _logs.fold(0.0, (s, l) => s + l.cost);
    final today = _logs.where((l) => l.date.day == DateTime.now().day).length;

    final categoryTotals = <String, double>{};
    for (final log in _logs) {
      categoryTotals[log.category] = (categoryTotals[log.category] ?? 0) + log.cost;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Waste Management'),
        actions: [
          IconButton(icon: const Icon(Icons.file_download_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // KPIs
        Row(children: [
          Expanded(child: KpiCard(title: 'Today\'s Waste', value: '$today items', icon: Icons.delete_outline, color: AppColors.error)),
          const SizedBox(width: 12),
          Expanded(child: KpiCard(title: 'Total Cost', value: 'SAR ${totalWasteValue.toStringAsFixed(0)}', icon: Icons.monetization_on_outlined, color: AppColors.warning)),
        ]),
        const SizedBox(height: 20),

        // Waste by category chart
        if (categoryTotals.isNotEmpty) ...[
          SectionHeader(title: 'Waste by Category'),
          const SizedBox(height: 12),
          Container(
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(children: [
              SizedBox(
                width: 140,
                child: PieChart(PieChartData(
                  sections: categoryTotals.entries.toList().asMap().entries.map((e) {
                    final idx = e.key;
                    final entry = e.value;
                    return PieChartSectionData(
                      value: entry.value,
                      color: AppColors.chartColors[idx % AppColors.chartColors.length],
                      radius: 50,
                      showTitle: false,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                )),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: categoryTotals.entries.toList().asMap().entries.map((e) {
                  final idx = e.key;
                  final entry = e.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(
                        color: AppColors.chartColors[idx % AppColors.chartColors.length],
                        borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entry.key, style: const TextStyle(fontSize: 11))),
                      Text('SAR ${entry.value.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ]),
                  );
                }).toList(),
              )),
            ]),
          ),
          const SizedBox(height: 20),
        ],

        // Waste log
        SectionHeader(title: 'Waste Log', actionLabel: 'Export', onAction: () {}),
        const SizedBox(height: 12),
        ..._logs.map((log) => _WasteCard(log: log, isDark: isDark)),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogSheet(context),
        backgroundColor: AppColors.error,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Log Waste', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showLogSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _LogWasteSheet(
        ref: ref,
        onAdd: (log) => setState(() => _logs.insert(0, log)),
      ),
    );
  }
}

class _WasteLog {
  final String item, unit, reason, category;
  final double quantity, cost;
  final DateTime date;
  _WasteLog(this.item, this.quantity, this.unit, this.reason, this.category, this.cost, this.date);
}

class _WasteCard extends StatelessWidget {
  final _WasteLog log;
  final bool isDark;
  const _WasteCard({required this.log, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(log.item, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 3),
          Row(children: [
            Text('${log.quantity} ${log.unit}', style: TextStyle(fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(log.reason, style: const TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 6),
            Text('· ${log.category}', style: TextStyle(fontSize: 11,
              color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
          ]),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('SAR ${log.cost.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.error, fontSize: 13)),
          const SizedBox(height: 2),
          Text(_timeAgo(log.date), style: TextStyle(fontSize: 10,
            color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
        ]),
      ]),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _LogWasteSheet extends StatefulWidget {
  final WidgetRef ref;
  final Function(_WasteLog) onAdd;
  const _LogWasteSheet({required this.ref, required this.onAdd});
  @override
  State<_LogWasteSheet> createState() => _LogWasteSheetState();
}

class _LogWasteSheetState extends State<_LogWasteSheet> {
  InventoryItem? _selected;
  final _qtyCtrl = TextEditingController();
  String _reason = 'Expired';
  final _reasons = ['Expired', 'Spoiled', 'Overcooked', 'Damaged', 'Excess Prep', 'Other'];

  @override
  Widget build(BuildContext context) {
    final items = widget.ref.watch(inventoryItemsProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Log Waste', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        DropdownButtonFormField<InventoryItem>(
          value: _selected,
          decoration: const InputDecoration(labelText: 'Item *'),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.name))).toList(),
          onChanged: (v) => setState(() => _selected = v),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(
            controller: _qtyCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Quantity (${_selected?.unit ?? ''})'),
          )),
          const SizedBox(width: 12),
          Expanded(child: DropdownButtonFormField<String>(
            value: _reason,
            decoration: const InputDecoration(labelText: 'Reason'),
            items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
            onChanged: (v) => setState(() => _reason = v!),
          )),
        ]),
        if (_selected != null && _qtyCtrl.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Cost impact: SAR ${((double.tryParse(_qtyCtrl.text) ?? 0) * _selected!.costPerUnit).toStringAsFixed(2)}',
            style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () {
            if (_selected == null) return;
            final qty = double.tryParse(_qtyCtrl.text) ?? 0;
            if (qty <= 0) return;
            final cost = qty * _selected!.costPerUnit;
            widget.onAdd(_WasteLog(_selected!.name, qty, _selected!.unit, _reason, _selected!.category ?? 'Other', cost, DateTime.now()));
            // Deduct from stock
            final items = widget.ref.read(inventoryItemsProvider);
            widget.ref.read(inventoryItemsProvider.notifier).state = items.map((i) {
              if (i.id != _selected!.id) return i;
              final newStock = (i.currentStock - qty).clamp(0.0, double.infinity);
              StockStatus status;
              if (newStock <= 0) status = StockStatus.out;
              else if (newStock <= i.minStock * 0.5) status = StockStatus.critical;
              else if (newStock <= i.minStock) status = StockStatus.low;
              else status = StockStatus.ok;
              return InventoryItem(
                id: i.id, restaurantId: i.restaurantId, branchId: i.branchId,
                name: i.name, nameAr: i.nameAr, sku: i.sku, category: i.category, unit: i.unit,
                currentStock: newStock, minStock: i.minStock, maxStock: i.maxStock,
                reorderPoint: i.reorderPoint, costPerUnit: i.costPerUnit,
                stockValue: newStock * i.costPerUnit, expiryTracking: i.expiryTracking,
                isActive: i.isActive, stockStatus: status, notes: i.notes,
                createdAt: i.createdAt, updatedAt: DateTime.now(),
              );
            }).toList();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Waste logged: ${qty} ${_selected!.unit} of ${_selected!.name}'),
              backgroundColor: AppColors.warning));
          },
          child: const Text('Log Waste', style: TextStyle(color: Colors.white)),
        )),
      ]),
    );
  }
}
