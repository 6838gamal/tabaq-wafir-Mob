import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class StockCountPage extends ConsumerStatefulWidget {
  const StockCountPage({super.key});

  @override
  ConsumerState<StockCountPage> createState() => _StockCountPageState();
}

class _StockCountPageState extends ConsumerState<StockCountPage> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isSubmitting = false;
  String? _selectedCategory;
  int _counted = 0;

  @override
  void dispose() {
    for (final ctrl in _controllers.values) ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allItems = ref.watch(inventoryItemsProvider);
    final filtered = _selectedCategory == null
        ? allItems
        : allItems.where((i) => i.category == _selectedCategory).toList();
    final categories = allItems.map((i) => i.category).whereType<String>().toSet().toList()..sort();

    // Init controllers
    for (final item in filtered) {
      _controllers.putIfAbsent(item.id, () => TextEditingController(text: item.currentStock.toString()));
    }

    _counted = _controllers.entries.where((e) => e.value.text.isNotEmpty).length;
    final progress = filtered.isEmpty ? 0.0 : _counted / filtered.length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Stock Count'),
        actions: [
          TextButton(
            onPressed: _isSubmitting || filtered.isEmpty ? null : _confirmSubmit,
            child: const Text('Submit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(children: [
        // Progress header
        Container(
          padding: const EdgeInsets.all(16),
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Progress: $_counted / ${filtered.length} items', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontWeight: FontWeight.w700, color: progress == 1 ? AppColors.success : AppColors.primary)),
            ]),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(progress == 1 ? AppColors.success : AppColors.primary),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ]),
        ),
        // Category filter
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            children: [
              Padding(padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(label: const Text('All'), selected: _selectedCategory == null,
                  onSelected: (_) => setState(() => _selectedCategory = null),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _selectedCategory == null ? Colors.white : null, fontSize: 12))),
              ...categories.map((cat) => Padding(padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(label: Text(cat), selected: _selectedCategory == cat,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _selectedCategory == cat ? Colors.white : null, fontSize: 12)))),
            ],
          ),
        ),
        // Items list
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No items to count'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final item = filtered[i];
                    final ctrl = _controllers[item.id]!;
                    final actual = double.tryParse(ctrl.text) ?? item.currentStock;
                    final diff = actual - item.currentStock;
                    final hasDiff = diff.abs() > 0.001;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasDiff
                              ? (diff > 0 ? AppColors.success.withOpacity(0.4) : AppColors.error.withOpacity(0.4))
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: hasDiff ? 1.5 : 1,
                        ),
                      ),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(item.category ?? 'Uncategorized',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                          const SizedBox(height: 4),
                          Row(children: [
                            Text('Expected: ${item.currentStock} ${item.unit}',
                              style: TextStyle(fontSize: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
                            if (hasDiff) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (diff > 0 ? AppColors.success : AppColors.error).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} ${item.unit}',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                    color: diff > 0 ? AppColors.success : AppColors.error),
                                ),
                              ),
                            ],
                          ]),
                        ])),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: ctrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: item.unit,
                              labelStyle: const TextStyle(fontSize: 11),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
        ),
      ]),
    );
  }

  void _confirmSubmit() {
    final items = ref.read(inventoryItemsProvider);
    final discrepancies = <Map<String, dynamic>>[];

    for (final item in items) {
      final ctrl = _controllers[item.id];
      if (ctrl == null) continue;
      final actual = double.tryParse(ctrl.text);
      if (actual == null) continue;
      final diff = actual - item.currentStock;
      if (diff.abs() > 0.001) {
        discrepancies.add({'name': item.name, 'diff': diff, 'unit': item.unit});
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Stock Count'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${_controllers.length} items counted'),
          if (discrepancies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('${discrepancies.length} discrepancies found:', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...discrepancies.take(5).map((d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                Icon(d['diff'] > 0 ? Icons.trending_up : Icons.trending_down, size: 14,
                  color: (d['diff'] as double) > 0 ? AppColors.success : AppColors.error),
                const SizedBox(width: 6),
                Expanded(child: Text('${d['name']}: ${(d['diff'] as double) > 0 ? '+' : ''}${(d['diff'] as double).toStringAsFixed(1)} ${d['unit']}',
                  style: const TextStyle(fontSize: 12))),
              ]),
            )),
            if (discrepancies.length > 5)
              Text('... and ${discrepancies.length - 5} more', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
          ] else
            const Text('No discrepancies found. Stock is accurate!', style: TextStyle(color: AppColors.success)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitCount();
            },
            child: const Text('Confirm & Update'),
          ),
        ],
      ),
    );
  }

  void _submitCount() {
    setState(() => _isSubmitting = true);
    final items = ref.read(inventoryItemsProvider);
    final updated = items.map((item) {
      final ctrl = _controllers[item.id];
      if (ctrl == null) return item;
      final actual = double.tryParse(ctrl.text);
      if (actual == null) return item;
      StockStatus status;
      if (actual <= 0) status = StockStatus.out;
      else if (actual <= item.minStock * 0.5) status = StockStatus.critical;
      else if (actual <= item.minStock) status = StockStatus.low;
      else status = StockStatus.ok;
      return InventoryItem(
        id: item.id, restaurantId: item.restaurantId, branchId: item.branchId,
        name: item.name, nameAr: item.nameAr, sku: item.sku, category: item.category, unit: item.unit,
        currentStock: actual, minStock: item.minStock, maxStock: item.maxStock,
        reorderPoint: item.reorderPoint, costPerUnit: item.costPerUnit,
        stockValue: actual * item.costPerUnit, expiryTracking: item.expiryTracking,
        isActive: item.isActive, stockStatus: status, notes: item.notes,
        createdAt: item.createdAt, updatedAt: DateTime.now(),
      );
    }).toList();

    ref.read(inventoryItemsProvider.notifier).state = updated;
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Stock count saved. Inventory updated.'),
      backgroundColor: AppColors.success,
      duration: Duration(seconds: 3),
    ));
  }
}
