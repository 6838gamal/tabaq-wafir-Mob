import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class TransfersPage extends ConsumerWidget {
  const TransfersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final transfers = [
      _Transfer('TR-001', 'Branch 1', 'Branch 2', [{'name': 'Beef Tenderloin', 'qty': 5, 'unit': 'kg'}], DateTime.now().subtract(const Duration(hours: 2)), 'completed'),
      _Transfer('TR-002', 'Branch 2', 'Branch 1', [{'name': 'Basmati Rice', 'qty': 10, 'unit': 'kg'}, {'name': 'Olive Oil', 'qty': 2, 'unit': 'L'}], DateTime.now().subtract(const Duration(days: 1)), 'completed'),
      _Transfer('TR-003', 'Branch 1', 'Branch 3', [{'name': 'Fresh Cream', 'qty': 3, 'unit': 'L'}], DateTime.now().subtract(const Duration(days: 3)), 'completed'),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Stock Transfers')),
      body: Column(children: [
        // Summary
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _StatItem('${transfers.length}', 'Total', AppColors.kpiBlue),
              _StatItem('${transfers.where((t) => t.status == 'completed').length}', 'Completed', AppColors.success),
              _StatItem('${transfers.where((t) => t.status == 'pending').length}', 'Pending', AppColors.warning),
            ]),
          ),
        ),
        Expanded(
          child: transfers.isEmpty
              ? const Center(child: Text('No transfers yet'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: transfers.length,
                  itemBuilder: (ctx, i) => _TransferCard(transfer: transfers[i], isDark: isDark),
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTransferSheet(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.swap_horiz, color: Colors.white),
        label: const Text('New Transfer', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showTransferSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _NewTransferSheet(ref: ref),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatItem(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 18)),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
  ]);
}

class _Transfer {
  final String id, from, to;
  final List<Map<String, dynamic>> items;
  final DateTime date;
  final String status;
  _Transfer(this.id, this.from, this.to, this.items, this.date, this.status);
}

class _TransferCard extends StatelessWidget {
  final _Transfer transfer;
  final bool isDark;
  const _TransferCard({required this.transfer, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.swap_horiz, color: AppColors.info, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(transfer.id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text('${_formatDate(transfer.date)}', style: TextStyle(fontSize: 11,
              color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
          ])),
          StatusBadge(label: transfer.status.toUpperCase(), color: transfer.status == 'completed' ? AppColors.success : AppColors.warning),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _BranchBox(transfer.from, Icons.upload_outlined, AppColors.error, isDark)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.arrow_forward, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, size: 18),
          ),
          Expanded(child: _BranchBox(transfer.to, Icons.download_outlined, AppColors.success, isDark)),
        ]),
        const SizedBox(height: 10),
        ...transfer.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            const Icon(Icons.inventory_2_outlined, size: 12, color: AppColors.textSecondaryLight),
            const SizedBox(width: 6),
            Text('${item['name']}', style: const TextStyle(fontSize: 12)),
            const Spacer(),
            Text('${item['qty']} ${item['unit']}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kpiBlue)),
          ]),
        )),
      ]),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _BranchBox extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isDark;
  const _BranchBox(this.name, this.icon, this.color, this.isDark);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 6),
      Flexible(child: Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color))),
    ]),
  );
}

class _NewTransferSheet extends StatefulWidget {
  final WidgetRef ref;
  const _NewTransferSheet({required this.ref});
  @override
  State<_NewTransferSheet> createState() => _NewTransferSheetState();
}

class _NewTransferSheetState extends State<_NewTransferSheet> {
  String _from = 'Branch 1';
  String _to = 'Branch 2';
  final _branches = ['Branch 1', 'Branch 2', 'Branch 3'];
  final List<Map<String, dynamic>> _items = [];
  InventoryItem? _selectedItem;
  final _qtyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          Text('New Stock Transfer', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: DropdownButtonFormField<String>(
              value: _from,
              decoration: const InputDecoration(labelText: 'From Branch'),
              items: _branches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (v) => setState(() => _from = v!),
            )),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward, color: AppColors.textSecondaryLight),
            const SizedBox(width: 12),
            Expanded(child: DropdownButtonFormField<String>(
              value: _to,
              decoration: const InputDecoration(labelText: 'To Branch'),
              items: _branches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (v) => setState(() => _to = v!),
            )),
          ]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Items to Transfer', style: Theme.of(context).textTheme.titleMedium),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
              onPressed: () => _showAddDialog(invItems),
            ),
          ]),
          ..._items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Expanded(child: Text('${item['name']}  ${item['qty']} ${item['unit']}',
                style: const TextStyle(fontWeight: FontWeight.w500))),
              IconButton(icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                onPressed: () => setState(() => _items.remove(item))),
            ]),
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _items.isEmpty || _from == _to ? null : () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Transfer completed & stock updated'), backgroundColor: AppColors.success));
            },
            child: const Text('Execute Transfer'),
          ),
        ]),
      ),
    );
  }

  void _showAddDialog(List<InventoryItem> items) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Item to Transfer'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<InventoryItem>(
            value: _selectedItem,
            decoration: const InputDecoration(labelText: 'Item'),
            items: items.map((i) => DropdownMenuItem(value: i, child: Text('${i.name} (${i.currentStock} ${i.unit})'))).toList(),
            onChanged: (v) => setState(() => _selectedItem = v),
          ),
          const SizedBox(height: 12),
          TextField(controller: _qtyCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Quantity (${_selectedItem?.unit ?? ''})')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            if (_selectedItem == null) return;
            final qty = double.tryParse(_qtyCtrl.text) ?? 0;
            if (qty <= 0) return;
            setState(() => _items.add({
              'itemId': _selectedItem!.id, 'name': _selectedItem!.name,
              'qty': qty, 'unit': _selectedItem!.unit,
            }));
            _qtyCtrl.clear();
            Navigator.pop(context);
          }, child: const Text('Add')),
        ],
      ),
    );
  }
}
