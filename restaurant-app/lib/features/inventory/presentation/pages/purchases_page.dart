import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class PurchasesPage extends ConsumerWidget {
  const PurchasesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final purchases = ref.watch(purchasesProvider);

    final totalOrdered = purchases.where((p) => p.status == 'ordered').length;
    final totalReceived = purchases.where((p) => p.status == 'received').length;
    final totalValue = purchases.fold(0.0, (s, p) => s + p.totalAmount);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Purchase Orders'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showCreateSheet(context, ref))],
      ),
      body: Column(children: [
        // Stats
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: _StatCard('${purchases.length}', 'Total POs', AppColors.kpiBlue, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard('$totalOrdered', 'Pending', AppColors.warning, isDark)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard('SAR ${(totalValue / 1000).toStringAsFixed(1)}K', 'Total Value', AppColors.kpiGreen, isDark)),
          ]),
        ),
        // Filter chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: ['All', 'draft', 'ordered', 'partial', 'received', 'cancelled']
                .map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(s.toUpperCase(), style: const TextStyle(fontSize: 11)),
                        selected: false,
                        onSelected: (_) {},
                        selectedColor: AppColors.primary,
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: purchases.isEmpty
              ? const Center(child: Text('No purchase orders yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: purchases.length,
                  itemBuilder: (ctx, i) => _POCard(
                    purchase: purchases[i],
                    isDark: isDark,
                    onTap: () => _showDetail(context, ref, purchases[i]),
                  ),
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
        label: const Text('New PO', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref, Purchase purchase) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PODetailSheet(purchase: purchase, ref: ref),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CreatePOSheet(ref: ref),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color color;
  final bool isDark;
  const _StatCard(this.value, this.label, this.color, this.isDark);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
    ),
    child: Column(children: [
      Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 15)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight), textAlign: TextAlign.center),
    ]),
  );
}

class _POCard extends StatelessWidget {
  final Purchase purchase;
  final bool isDark;
  final VoidCallback onTap;
  const _POCard({required this.purchase, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(purchase.status);
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.receipt_outlined, color: statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(purchase.poNumber ?? 'PO-${purchase.id.substring(0, 6)}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                StatusBadge(label: purchase.status.toUpperCase(), color: statusColor),
              ]),
              const SizedBox(height: 3),
              Text(purchase.supplierName ?? 'No Supplier',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              Text(_formatDate(purchase.createdAt),
                style: TextStyle(fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
            ])),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _InfoChip('${purchase.items.length} items', Icons.inventory_2_outlined)),
            Expanded(child: _InfoChip('SAR ${purchase.totalAmount.toStringAsFixed(0)}', Icons.monetization_on_outlined)),
            Expanded(child: _InfoChip(purchase.paymentStatus.toUpperCase(), Icons.payment_outlined,
              color: purchase.paymentStatus == 'paid' ? AppColors.success : AppColors.warning)),
          ]),
          if (purchase.expectedAt != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.borderDark : AppColors.borderLight).withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(children: [
                Icon(Icons.calendar_today_outlined, size: 12, color: isDark ? AppColors.textHintDark : AppColors.textHintLight),
                const SizedBox(width: 6),
                Text('Expected: ${_formatDate(purchase.expectedAt!)}',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
              ]),
            ),
          ],
        ]),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'received': return AppColors.success;
      case 'ordered': return AppColors.kpiBlue;
      case 'partial': return AppColors.warning;
      case 'cancelled': return AppColors.error;
      default: return AppColors.textSecondaryLight;
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  const _InfoChip(this.label, this.icon, {this.color});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 12, color: color ?? AppColors.textSecondaryLight),
    const SizedBox(width: 4),
    Text(label, style: TextStyle(fontSize: 11, color: color ?? AppColors.textSecondaryLight, fontWeight: FontWeight.w500)),
  ]);
}

class _PODetailSheet extends StatelessWidget {
  final Purchase purchase;
  final WidgetRef ref;
  const _PODetailSheet({required this.purchase, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = purchase.status == 'received' ? AppColors.success
        : purchase.status == 'ordered' ? AppColors.kpiBlue
        : purchase.status == 'partial' ? AppColors.warning : AppColors.error;

    return DraggableScrollableSheet(
      initialChildSize: 0.85, maxChildSize: 0.95, minChildSize: 0.5,
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
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(purchase.poNumber ?? 'Purchase Order', style: Theme.of(context).textTheme.titleLarge),
              Text(purchase.supplierName ?? 'No Supplier',
                style: const TextStyle(color: AppColors.textSecondaryLight)),
            ])),
            StatusBadge(label: purchase.status.toUpperCase(), color: statusColor),
          ]),
          const SizedBox(height: 16),
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Expanded(child: _KpiItem('SAR ${purchase.totalAmount.toStringAsFixed(2)}', 'Total Amount', AppColors.kpiGreen)),
              Expanded(child: _KpiItem('SAR ${purchase.paidAmount.toStringAsFixed(2)}', 'Paid', AppColors.kpiBlue)),
              Expanded(child: _KpiItem(purchase.paymentStatus.toUpperCase(), 'Payment', purchase.paymentStatus == 'paid' ? AppColors.success : AppColors.warning)),
            ]),
          ),
          const SizedBox(height: 20),
          Text('Items (${purchase.items.length})', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...purchase.items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(item.itemName ?? 'Item', style: const TextStyle(fontWeight: FontWeight.w600))),
                Text('SAR ${item.totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.kpiGreen)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Text('Ordered: ${item.orderedQty} ${item.itemUnit ?? ''}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                const SizedBox(width: 16),
                Text('Received: ${item.receivedQty} ${item.itemUnit ?? ''}',
                  style: TextStyle(fontSize: 12,
                    color: item.receivedQty >= item.orderedQty ? AppColors.success : AppColors.warning)),
                const Spacer(),
                Text('@ SAR ${item.unitCost}/${item.itemUnit ?? ''}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              ]),
              if (item.expiryDate != null) ...[
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.event_outlined, size: 12, color: AppColors.textHintLight),
                  const SizedBox(width: 4),
                  Text('Expires: ${item.expiryDate!.day}/${item.expiryDate!.month}/${item.expiryDate!.year}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textHintLight)),
                ]),
              ],
            ]),
          )),
          const SizedBox(height: 24),
          if (purchase.status == 'ordered' || purchase.status == 'partial') ...[
            ElevatedButton.icon(
              onPressed: () {
                // Mark as received
                final purchases = ref.read(purchasesProvider);
                ref.read(purchasesProvider.notifier).state = purchases.map((p) {
                  if (p.id == purchase.id) {
                    return Purchase(
                      id: p.id, restaurantId: p.restaurantId, branchId: p.branchId,
                      supplierId: p.supplierId, supplierName: p.supplierName,
                      poNumber: p.poNumber, status: 'received',
                      totalAmount: p.totalAmount, paidAmount: p.totalAmount,
                      paymentStatus: 'paid', invoiceNumber: p.invoiceNumber,
                      expectedAt: p.expectedAt, receivedAt: DateTime.now(),
                      notes: p.notes, items: p.items.map((i) => PurchaseItem(
                        id: i.id, itemId: i.itemId, itemName: i.itemName, itemUnit: i.itemUnit,
                        orderedQty: i.orderedQty, receivedQty: i.orderedQty,
                        unitCost: i.unitCost, totalCost: i.totalCost,
                        expiryDate: i.expiryDate, batchNumber: i.batchNumber,
                      )).toList(),
                      createdAt: p.createdAt,
                    );
                  }
                  return p;
                }).toList();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Purchase marked as received & stock updated'),
                  backgroundColor: AppColors.success));
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mark as Received'),
            ),
          ],
        ]),
      ),
    );
  }
}

class _KpiItem extends StatelessWidget {
  final String value, label;
  final Color color;
  const _KpiItem(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight), textAlign: TextAlign.center),
  ]);
}

class _CreatePOSheet extends StatefulWidget {
  final WidgetRef ref;
  const _CreatePOSheet({required this.ref});
  @override
  State<_CreatePOSheet> createState() => _CreatePOSheetState();
}

class _CreatePOSheetState extends State<_CreatePOSheet> {
  String? _supplierId;
  final _notesCtrl = TextEditingController();
  final List<Map<String, dynamic>> _items = [];

  @override
  Widget build(BuildContext context) {
    final suppliers = widget.ref.watch(suppliersProvider);
    final invItems = widget.ref.watch(inventoryItemsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.85, maxChildSize: 0.95, minChildSize: 0.5,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
          Text('New Purchase Order', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _supplierId,
            decoration: const InputDecoration(labelText: 'Supplier (optional)'),
            items: suppliers.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
            onChanged: (v) => setState(() => _supplierId = v),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Items', style: Theme.of(context).textTheme.titleMedium),
            TextButton.icon(
              onPressed: () => _addItem(invItems),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Item'),
            ),
          ]),
          if (_items.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No items added yet', style: TextStyle(color: AppColors.textSecondaryLight)),
            )),
          ..._items.asMap().entries.map((e) {
            final item = e.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${item['qty']} ${item['unit']} × SAR ${item['cost']} = SAR ${(item['qty'] * item['cost']).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                ])),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                  onPressed: () => setState(() => _items.removeAt(e.key)),
                ),
              ]),
            );
          }),
          if (_items.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: Text(
              'Total: SAR ${_items.fold(0.0, (s, i) => s + (i['qty'] as double) * (i['cost'] as double)).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.kpiGreen, fontSize: 15),
            )),
          ],
          const SizedBox(height: 16),
          TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 2),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _items.isEmpty ? null : () {
              final supplier = suppliers.firstWhere((s) => s.id == _supplierId, orElse: () => suppliers.first);
              final newPO = Purchase(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                restaurantId: 'r1', supplierId: _supplierId,
                supplierName: _supplierId != null ? supplier.name : null,
                poNumber: 'PO-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}-${(widget.ref.read(purchasesProvider).length + 1).toString().padLeft(4, '0')}',
                status: 'ordered',
                totalAmount: _items.fold(0.0, (s, i) => s + (i['qty'] as double) * (i['cost'] as double)),
                paidAmount: 0,
                paymentStatus: 'unpaid',
                notes: _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
                items: _items.map((i) => PurchaseItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString() + i['itemId'],
                  itemId: i['itemId'], itemName: i['name'], itemUnit: i['unit'],
                  orderedQty: i['qty'], receivedQty: 0,
                  unitCost: i['cost'], totalCost: (i['qty'] as double) * (i['cost'] as double),
                )).toList(),
                createdAt: DateTime.now(),
              );
              widget.ref.read(purchasesProvider.notifier).state = [newPO, ...widget.ref.read(purchasesProvider)];
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Purchase order created'), backgroundColor: AppColors.success));
            },
            child: const Text('Create Purchase Order'),
          ),
        ]),
      ),
    );
  }

  void _addItem(List<InventoryItem> invItems) {
    showDialog(
      context: context,
      builder: (_) => _AddItemDialog(
        items: invItems,
        onAdd: (itemId, name, unit, qty, cost) => setState(() => _items.add({
          'itemId': itemId, 'name': name, 'unit': unit, 'qty': qty, 'cost': cost,
        })),
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final List<InventoryItem> items;
  final Function(String, String, String, double, double) onAdd;
  const _AddItemDialog({required this.items, required this.onAdd});
  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  InventoryItem? _selected;
  final _qtyCtrl = TextEditingController();
  final _costCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<InventoryItem>(
          value: _selected,
          decoration: const InputDecoration(labelText: 'Select Item'),
          items: widget.items.map((i) => DropdownMenuItem(value: i, child: Text(i.name))).toList(),
          onChanged: (v) => setState(() {
            _selected = v;
            _costCtrl.text = v?.costPerUnit.toString() ?? '';
          }),
        ),
        const SizedBox(height: 12),
        TextField(controller: _qtyCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Quantity (${_selected?.unit ?? ''})'),
        ),
        const SizedBox(height: 12),
        TextField(controller: _costCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Unit Cost (SAR)'),
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_selected == null) return;
            final qty = double.tryParse(_qtyCtrl.text) ?? 0;
            final cost = double.tryParse(_costCtrl.text) ?? 0;
            if (qty <= 0 || cost <= 0) return;
            widget.onAdd(_selected!.id, _selected!.name, _selected!.unit, qty, cost);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
