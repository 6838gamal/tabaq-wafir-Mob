import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/inventory_models.dart';

class ExpiryPage extends ConsumerWidget {
  const ExpiryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final batches = ref.watch(inventoryBatchesProvider);

    final expired = batches.where((b) => b.expiryStatus == ExpiryStatus.expired).toList();
    final urgent = batches.where((b) => b.expiryStatus == ExpiryStatus.urgent).toList();
    final warning = batches.where((b) => b.expiryStatus == ExpiryStatus.warning).toList();
    final ok = batches.where((b) => b.expiryStatus == ExpiryStatus.ok).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Expiry Tracking'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddBatchSheet(context, ref)),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // Summary cards
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.0,
          children: [
            KpiCard(title: 'Expired', value: '${expired.length}', icon: Icons.block, color: AppColors.error),
            KpiCard(title: 'Urgent (≤3 days)', value: '${urgent.length}', icon: Icons.warning_amber, color: AppColors.kpiOrange),
            KpiCard(title: 'Warning (≤7 days)', value: '${warning.length}', icon: Icons.timer_outlined, color: AppColors.warning),
            KpiCard(title: 'OK', value: '${ok.length}', icon: Icons.check_circle_outlined, color: AppColors.success),
          ],
        ),
        const SizedBox(height: 20),
        if (expired.isNotEmpty) ...[
          _SectionTitle('🚨 Expired', AppColors.error),
          const SizedBox(height: 8),
          ...expired.map((b) => _BatchCard(batch: b, isDark: isDark, ref: ref)),
          const SizedBox(height: 16),
        ],
        if (urgent.isNotEmpty) ...[
          _SectionTitle('⚠️ Urgent — Expires within 3 days', AppColors.kpiOrange),
          const SizedBox(height: 8),
          ...urgent.map((b) => _BatchCard(batch: b, isDark: isDark, ref: ref)),
          const SizedBox(height: 16),
        ],
        if (warning.isNotEmpty) ...[
          _SectionTitle('🕐 Expiring within 7 days', AppColors.warning),
          const SizedBox(height: 8),
          ...warning.map((b) => _BatchCard(batch: b, isDark: isDark, ref: ref)),
          const SizedBox(height: 16),
        ],
        if (ok.isNotEmpty) ...[
          _SectionTitle('✅ OK', AppColors.success),
          const SizedBox(height: 8),
          ...ok.map((b) => _BatchCard(batch: b, isDark: isDark, ref: ref)),
        ],
        if (batches.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text('No batches with expiry tracking.\nAdd batches to track expiry dates.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondaryLight)),
            ),
          ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBatchSheet(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Batch', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showAddBatchSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddBatchSheet(ref: ref),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle(this.title, this.color);
  @override
  Widget build(BuildContext context) => Text(title,
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color));
}

class _BatchCard extends StatelessWidget {
  final InventoryBatch batch;
  final bool isDark;
  final WidgetRef ref;
  const _BatchCard({required this.batch, required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final color = batch.expiryStatus == ExpiryStatus.expired ? AppColors.error
        : batch.expiryStatus == ExpiryStatus.urgent ? AppColors.kpiOrange
        : batch.expiryStatus == ExpiryStatus.warning ? AppColors.warning : AppColors.success;

    String expiryText;
    if (batch.daysUntilExpiry != null) {
      if (batch.daysUntilExpiry! < 0) expiryText = 'Expired ${batch.daysUntilExpiry!.abs()} day(s) ago';
      else if (batch.daysUntilExpiry == 0) expiryText = 'Expires TODAY';
      else expiryText = 'Expires in ${batch.daysUntilExpiry} day(s)';
    } else expiryText = 'No expiry date';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(children: [
        Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(batch.itemName ?? 'Unknown Item', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Row(children: [
            Text('Qty: ${batch.quantity}  ', style: TextStyle(fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            if (batch.batchNumber != null)
              Text('Batch: ${batch.batchNumber}', style: TextStyle(fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.event_outlined, size: 12, color: color),
            const SizedBox(width: 4),
            Text(expiryText, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ]),
          if (batch.expiryDate != null) ...[
            const SizedBox(height: 2),
            Text('Date: ${batch.expiryDate!.day}/${batch.expiryDate!.month}/${batch.expiryDate!.year}',
              style: TextStyle(fontSize: 11, color: isDark ? AppColors.textHintDark : AppColors.textHintLight)),
          ],
        ])),
        Column(children: [
          StatusBadge(
            label: batch.expiryStatus == ExpiryStatus.expired ? 'EXPIRED'
                : batch.expiryStatus == ExpiryStatus.urgent ? 'URGENT'
                : batch.expiryStatus == ExpiryStatus.warning ? 'WARNING' : 'OK',
            color: color,
          ),
          const SizedBox(height: 8),
          Text('SAR ${(batch.quantity * batch.costPerUnit).toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.kpiGreen)),
        ]),
      ]),
    );
  }
}

class _AddBatchSheet extends StatefulWidget {
  final WidgetRef ref;
  const _AddBatchSheet({required this.ref});
  @override
  State<_AddBatchSheet> createState() => _AddBatchSheetState();
}

class _AddBatchSheetState extends State<_AddBatchSheet> {
  InventoryItem? _selectedItem;
  final _qtyCtrl = TextEditingController();
  final _batchCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  DateTime? _expiryDate;

  @override
  Widget build(BuildContext context) {
    final items = widget.ref.watch(inventoryItemsProvider).where((i) => i.expiryTracking).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Add Expiry Batch', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (items.isEmpty)
          const Text('No items with expiry tracking. Enable it in item settings.',
            style: TextStyle(color: AppColors.warning))
        else ...[
          DropdownButtonFormField<InventoryItem>(
            value: _selectedItem,
            decoration: const InputDecoration(labelText: 'Select Item *'),
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.name))).toList(),
            onChanged: (v) => setState(() { _selectedItem = v; _costCtrl.text = v?.costPerUnit.toString() ?? ''; }),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Quantity (${_selectedItem?.unit ?? ''})'))),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _batchCtrl,
              decoration: const InputDecoration(labelText: 'Batch Number'))),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _costCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Cost Per Unit (SAR)')),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
              );
              if (date != null) setState(() => _expiryDate = date);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                const Icon(Icons.event_outlined, color: AppColors.textSecondaryLight),
                const SizedBox(width: 12),
                Text(
                  _expiryDate == null ? 'Select Expiry Date *'
                      : '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                  style: TextStyle(color: _expiryDate == null ? AppColors.textHintLight : null),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              if (_selectedItem == null || _expiryDate == null) return;
              final qty = double.tryParse(_qtyCtrl.text) ?? 0;
              final cost = double.tryParse(_costCtrl.text) ?? _selectedItem!.costPerUnit;
              if (qty <= 0) return;

              final today = DateTime.now();
              final days = _expiryDate!.difference(today).inDays;
              ExpiryStatus status;
              if (days < 0) status = ExpiryStatus.expired;
              else if (days <= 3) status = ExpiryStatus.urgent;
              else if (days <= 7) status = ExpiryStatus.warning;
              else status = ExpiryStatus.ok;

              final batch = InventoryBatch(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                itemId: _selectedItem!.id, itemName: _selectedItem!.name,
                quantity: qty,
                batchNumber: _batchCtrl.text.isNotEmpty ? _batchCtrl.text : null,
                expiryDate: _expiryDate, costPerUnit: cost,
                daysUntilExpiry: days, expiryStatus: status,
                createdAt: DateTime.now(),
              );
              widget.ref.read(inventoryBatchesProvider.notifier).state = [
                ...widget.ref.read(inventoryBatchesProvider), batch,
              ];
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Batch added'), backgroundColor: AppColors.success));
            },
            child: const Text('Add Batch'),
          )),
        ],
      ]),
    );
  }
}
