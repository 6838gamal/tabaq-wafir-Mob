import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  String? _selectedCategory;
  String? _selectedStatus;
  final _searchCtrl = TextEditingController();

  final _categories = ['All', 'Meat', 'Dairy', 'Vegetables', 'Spices', 'Dry Goods', 'Oils', 'Beverages', 'Bakery'];
  final _statuses = ['All', 'ok', 'low', 'out'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = ref.watch(filteredInventoryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Inventory Items'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterSheet),
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showItemForm(context, ref)),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: AppSearchBar(
              hintText: 'Search items...',
              onChanged: (v) => ref.read(inventorySearchProvider.notifier).state = v,
              onFilterTap: _showFilterSheet,
            ),
          ),

          // Category chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final selected = (i == 0 && _selectedCategory == null) || cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => _selectedCategory = i == 0 ? null : cat);
                    ref.read(inventoryCategoryFilterProvider.notifier).state = i == 0 ? null : cat;
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              },
            ),
          ),

          // Summary bar
          _SummaryBar(items: items, isDark: isDark),

          // Items list
          Expanded(
            child: items.isEmpty
                ? _EmptyState(search: ref.watch(inventorySearchProvider))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => _ItemCard(
                      item: items[i],
                      isDark: isDark,
                      onTap: () => _showItemDetail(context, ref, items[i]),
                      onAdjust: () => _showAdjustSheet(context, ref, items[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemForm(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Filter Items', style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text('Status', style: Theme.of(ctx).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            ChoiceChip(label: const Text('All'), selected: _selectedStatus == null,
              onSelected: (_) { setState(() => _selectedStatus = null); ref.read(inventoryStatusFilterProvider.notifier).state = null; }),
            ChoiceChip(label: const Text('OK'), selected: _selectedStatus == 'ok', selectedColor: AppColors.success,
              onSelected: (_) { setState(() => _selectedStatus = 'ok'); ref.read(inventoryStatusFilterProvider.notifier).state = 'ok'; }),
            ChoiceChip(label: const Text('Low Stock'), selected: _selectedStatus == 'low', selectedColor: AppColors.warning,
              onSelected: (_) { setState(() => _selectedStatus = 'low'); ref.read(inventoryStatusFilterProvider.notifier).state = 'low'; }),
            ChoiceChip(label: const Text('Out of Stock'), selected: _selectedStatus == 'out', selectedColor: AppColors.error,
              onSelected: (_) { setState(() => _selectedStatus = 'out'); ref.read(inventoryStatusFilterProvider.notifier).state = 'out'; }),
          ]),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity,
            child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Apply'))),
        ]),
      ),
    );
  }

  void _showItemForm(BuildContext context, WidgetRef ref, {InventoryItem? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _ItemFormSheet(item: item, ref: ref),
    );
  }

  void _showItemDetail(BuildContext context, WidgetRef ref, InventoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _ItemDetailSheet(item: item),
    );
  }

  void _showAdjustSheet(BuildContext context, WidgetRef ref, InventoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AdjustStockSheet(item: item, ref: ref),
    );
  }
}

// ─── Summary Bar ─────────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  final List<InventoryItem> items;
  final bool isDark;

  const _SummaryBar({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final totalValue = items.fold(0.0, (s, i) => s + i.stockValue);
    final lowCount = items.where((i) => i.stockStatus != StockStatus.ok).length;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(children: [
        _SumStat('${items.length}', 'Items', AppColors.kpiBlue),
        _divider(),
        _SumStat('$lowCount', 'Alerts', AppColors.warning),
        _divider(),
        _SumStat('SAR ${totalValue.toStringAsFixed(0)}', 'Value', AppColors.kpiGreen),
      ]),
    );
  }

  Widget _divider() => Container(height: 30, width: 1, color: AppColors.borderLight, margin: const EdgeInsets.symmetric(horizontal: 12));
}

class _SumStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _SumStat(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
    Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
  ]));
}

// ─── Item Card ────────────────────────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  final InventoryItem item;
  final bool isDark;
  final VoidCallback onTap, onAdjust;

  const _ItemCard({required this.item, required this.isDark, required this.onTap, required this.onAdjust});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.stockStatus);
    final progress = item.minStock > 0 ? (item.currentStock / (item.minStock * 2)).clamp(0.0, 1.0) : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Icon(_categoryIcon(item.category), color: statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                StatusBadge(label: _statusLabel(item.stockStatus), color: statusColor),
              ]),
              const SizedBox(height: 3),
              Text(
                '${item.category ?? 'Uncategorized'} · SAR ${item.costPerUnit}/${item.unit}',
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ])),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  '${item.currentStock} ${item.unit}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor),
                ),
                Text(
                  'Min: ${item.minStock} ${item.unit}',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ]),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 5,
                borderRadius: BorderRadius.circular(3),
              ),
            ])),
            const SizedBox(width: 12),
            Row(children: [
              Text(
                'SAR ${item.stockValue.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kpiGreen),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAdjust,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.tune, size: 16, color: AppColors.primary),
                ),
              ),
            ]),
          ]),
          if (item.expiryTracking) ...[
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.event_available_outlined, size: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
              const SizedBox(width: 4),
              Text('Expiry tracking enabled', style: TextStyle(fontSize: 10, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
            ]),
          ],
        ]),
      ),
    );
  }

  Color _statusColor(StockStatus s) {
    switch (s) {
      case StockStatus.out: return AppColors.error;
      case StockStatus.critical: return AppColors.kpiOrange;
      case StockStatus.low: return AppColors.warning;
      case StockStatus.ok: return AppColors.success;
    }
  }

  String _statusLabel(StockStatus s) {
    switch (s) {
      case StockStatus.out: return 'OUT';
      case StockStatus.critical: return 'CRITICAL';
      case StockStatus.low: return 'LOW';
      case StockStatus.ok: return 'OK';
    }
  }

  IconData _categoryIcon(String? cat) {
    switch (cat?.toLowerCase()) {
      case 'meat': return Icons.set_meal;
      case 'dairy': return Icons.egg_outlined;
      case 'vegetables': return Icons.eco_outlined;
      case 'spices': return Icons.spa_outlined;
      case 'dry goods': return Icons.grain;
      case 'oils': return Icons.opacity_outlined;
      default: return Icons.inventory_2_outlined;
    }
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String search;
  const _EmptyState({required this.search});

  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textHintLight),
    const SizedBox(height: 16),
    Text(search.isEmpty ? 'No items yet' : 'No results for "$search"',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    const SizedBox(height: 8),
    const Text('Tap + to add inventory items', style: TextStyle(color: AppColors.textSecondaryLight)),
  ]));
}

// ─── Item Detail Sheet ────────────────────────────────────────────────────────

class _ItemDetailSheet extends StatelessWidget {
  final InventoryItem item;
  const _ItemDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = item.stockStatus == StockStatus.out ? AppColors.error
        : item.stockStatus == StockStatus.critical ? AppColors.kpiOrange
        : item.stockStatus == StockStatus.low ? AppColors.warning : AppColors.success;

    return DraggableScrollableSheet(
      initialChildSize: 0.7, maxChildSize: 0.95, minChildSize: 0.5,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
          Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Row(children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.inventory_2_outlined, color: statusColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: Theme.of(context).textTheme.titleLarge),
              if (item.nameAr != null) Text(item.nameAr!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
              const SizedBox(height: 4),
              StatusBadge(label: item.stockStatus.name.toUpperCase(), color: statusColor),
            ])),
          ]),
          const SizedBox(height: 24),
          _DetailRow('Category', item.category ?? '-'),
          _DetailRow('SKU / Code', item.sku ?? '-'),
          _DetailRow('Unit', item.unit),
          _DetailRow('Current Stock', '${item.currentStock} ${item.unit}', valueColor: statusColor),
          _DetailRow('Minimum Stock', '${item.minStock} ${item.unit}'),
          if (item.maxStock != null) _DetailRow('Maximum Stock', '${item.maxStock} ${item.unit}'),
          _DetailRow('Reorder Point', '${item.reorderPoint} ${item.unit}'),
          _DetailRow('Cost Per Unit', 'SAR ${item.costPerUnit}'),
          _DetailRow('Total Stock Value', 'SAR ${item.stockValue.toStringAsFixed(2)}', valueColor: AppColors.kpiGreen),
          _DetailRow('Expiry Tracking', item.expiryTracking ? 'Enabled' : 'Disabled'),
          if (item.notes != null) _DetailRow('Notes', item.notes!),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Item'),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune),
              label: const Text('Adjust Stock'),
            )),
          ]),
        ]),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _DetailRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(flex: 2, child: Text(label, style: TextStyle(
          fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
        Expanded(flex: 3, child: Text(value, style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: valueColor))),
      ]),
    );
  }
}

// ─── Adjust Stock Sheet ───────────────────────────────────────────────────────

class _AdjustStockSheet extends StatefulWidget {
  final InventoryItem item;
  final WidgetRef ref;
  const _AdjustStockSheet({required this.item, required this.ref});

  @override
  State<_AdjustStockSheet> createState() => _AdjustStockSheetState();
}

class _AdjustStockSheetState extends State<_AdjustStockSheet> {
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _type = 'adjustment';
  bool _isAdd = true;

  final _types = ['adjustment', 'purchase', 'waste', 'transfer_out', 'count'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Adjust Stock — ${widget.item.name}', style: Theme.of(context).textTheme.titleLarge),
        Text('Current: ${widget.item.currentStock} ${widget.item.unit}',
          style: const TextStyle(color: AppColors.textSecondaryLight)),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _isAdd = true),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isAdd ? AppColors.success.withOpacity(0.12) : null,
                border: Border.all(color: _isAdd ? AppColors.success : AppColors.borderLight),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_circle_outline, color: _isAdd ? AppColors.success : AppColors.textSecondaryLight, size: 18),
                const SizedBox(width: 6),
                Text('Add', style: TextStyle(color: _isAdd ? AppColors.success : null, fontWeight: FontWeight.w600)),
              ]),
            ),
          )),
          const SizedBox(width: 12),
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _isAdd = false),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: !_isAdd ? AppColors.error.withOpacity(0.12) : null,
                border: Border.all(color: !_isAdd ? AppColors.error : AppColors.borderLight),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.remove_circle_outline, color: !_isAdd ? AppColors.error : AppColors.textSecondaryLight, size: 18),
                const SizedBox(width: 6),
                Text('Remove', style: TextStyle(color: !_isAdd ? AppColors.error : null, fontWeight: FontWeight.w600)),
              ]),
            ),
          )),
        ]),
        const SizedBox(height: 16),
        TextField(
          controller: _qtyCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Quantity (${widget.item.unit})',
            prefixIcon: Icon(_isAdd ? Icons.add : Icons.remove, color: _isAdd ? AppColors.success : AppColors.error),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _type,
          decoration: const InputDecoration(labelText: 'Reason'),
          items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t.replaceAll('_', ' ').toUpperCase()))).toList(),
          onChanged: (v) => setState(() => _type = v!),
        ),
        const SizedBox(height: 12),
        TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Notes (optional)')),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final qty = double.tryParse(_qtyCtrl.text) ?? 0;
              if (qty <= 0) return;
              final adjustedQty = _isAdd ? qty : -qty;
              // Update local state
              final items = widget.ref.read(inventoryItemsProvider);
              final updated = items.map((i) {
                if (i.id == widget.item.id) {
                  final newStock = i.currentStock + adjustedQty;
                  StockStatus newStatus;
                  if (newStock <= 0) newStatus = StockStatus.out;
                  else if (newStock <= i.minStock * 0.5) newStatus = StockStatus.critical;
                  else if (newStock <= i.minStock) newStatus = StockStatus.low;
                  else newStatus = StockStatus.ok;
                  return InventoryItem(
                    id: i.id, restaurantId: i.restaurantId, branchId: i.branchId,
                    name: i.name, nameAr: i.nameAr, sku: i.sku, category: i.category, unit: i.unit,
                    currentStock: newStock, minStock: i.minStock, maxStock: i.maxStock,
                    reorderPoint: i.reorderPoint, costPerUnit: i.costPerUnit,
                    stockValue: newStock * i.costPerUnit, expiryTracking: i.expiryTracking,
                    isActive: i.isActive, stockStatus: newStatus, notes: i.notes,
                    createdAt: i.createdAt, updatedAt: DateTime.now(),
                  );
                }
                return i;
              }).toList();
              widget.ref.read(inventoryItemsProvider.notifier).state = updated;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stock adjusted: ${_isAdd ? '+' : ''}$adjustedQty ${widget.item.unit}'),
                  backgroundColor: AppColors.success));
            },
            child: const Text('Confirm Adjustment'),
          ),
        ),
      ]),
    );
  }
}

// ─── Item Form Sheet ──────────────────────────────────────────────────────────

class _ItemFormSheet extends StatefulWidget {
  final InventoryItem? item;
  final WidgetRef ref;
  const _ItemFormSheet({this.item, required this.ref});

  @override
  State<_ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<_ItemFormSheet> {
  final _nameCtrl = TextEditingController();
  final _nameArCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _minCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  String _unit = 'kg';
  String? _category;
  bool _expiryTracking = false;
  final _units = ['kg', 'g', 'L', 'mL', 'pcs', 'box', 'pack', 'bottle', 'can'];
  final _categories = ['Meat', 'Dairy', 'Vegetables', 'Spices', 'Dry Goods', 'Oils', 'Beverages', 'Bakery'];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameCtrl.text = widget.item!.name;
      _nameArCtrl.text = widget.item!.nameAr ?? '';
      _skuCtrl.text = widget.item!.sku ?? '';
      _stockCtrl.text = widget.item!.currentStock.toString();
      _minCtrl.text = widget.item!.minStock.toString();
      _costCtrl.text = widget.item!.costPerUnit.toString();
      _unit = widget.item!.unit;
      _category = widget.item!.category;
      _expiryTracking = widget.item!.expiryTracking;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9, maxChildSize: 0.95, minChildSize: 0.5,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
          Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text(widget.item == null ? 'Add Inventory Item' : 'Edit Item',
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Item Name *', hintText: 'e.g. Beef Tenderloin')),
          const SizedBox(height: 12),
          TextField(controller: _nameArCtrl, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'اسم المادة (Arabic)', hintText: 'لحم بقري')),
          const SizedBox(height: 12),
          TextField(controller: _skuCtrl, decoration: const InputDecoration(labelText: 'SKU / Barcode', prefixIcon: Icon(Icons.qr_code))),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v),
            )),
            const SizedBox(width: 12),
            Expanded(child: DropdownButtonFormField<String>(
              value: _unit,
              decoration: const InputDecoration(labelText: 'Unit *'),
              items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => setState(() => _unit = v!),
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _stockCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Current Stock'))),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _minCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Min Stock'))),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _costCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Cost Per Unit (SAR)', prefixIcon: Icon(Icons.monetization_on_outlined))),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Expiry Tracking'),
            subtitle: const Text('Track batches and expiry dates'),
            value: _expiryTracking,
            onChanged: (v) => setState(() => _expiryTracking = v),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_nameCtrl.text.isEmpty) return;
              final stock = double.tryParse(_stockCtrl.text) ?? 0;
              final min = double.tryParse(_minCtrl.text) ?? 0;
              final cost = double.tryParse(_costCtrl.text) ?? 0;
              StockStatus status;
              if (stock <= 0) status = StockStatus.out;
              else if (stock <= min * 0.5) status = StockStatus.critical;
              else if (stock <= min) status = StockStatus.low;
              else status = StockStatus.ok;

              final newItem = InventoryItem(
                id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                restaurantId: 'r1', name: _nameCtrl.text,
                nameAr: _nameArCtrl.text.isNotEmpty ? _nameArCtrl.text : null,
                sku: _skuCtrl.text.isNotEmpty ? _skuCtrl.text : null,
                category: _category, unit: _unit,
                currentStock: stock, minStock: min, reorderPoint: min * 0.8, costPerUnit: cost,
                stockValue: stock * cost, expiryTracking: _expiryTracking,
                isActive: true, stockStatus: status,
                createdAt: widget.item?.createdAt ?? DateTime.now(), updatedAt: DateTime.now(),
              );
              final items = widget.ref.read(inventoryItemsProvider);
              if (widget.item != null) {
                widget.ref.read(inventoryItemsProvider.notifier).state =
                    items.map((i) => i.id == widget.item!.id ? newItem : i).toList();
              } else {
                widget.ref.read(inventoryItemsProvider.notifier).state = [...items, newItem];
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.item == null ? 'Item added' : 'Item updated'),
                  backgroundColor: AppColors.success));
            },
            child: Text(widget.item == null ? 'Add Item' : 'Save Changes'),
          ),
        ]),
      ),
    );
  }
}
