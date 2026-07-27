import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/offer.dart';
import '../providers/promotions_provider.dart';
import '../../../../core/theme/app_colors.dart';

class CreateOfferScreen extends ConsumerStatefulWidget {
  final Offer? existing;
  const CreateOfferScreen({super.key, this.existing});

  @override
  ConsumerState<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends ConsumerState<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  final _minOrderCtrl = TextEditingController();
  final _maxDiscountCtrl = TextEditingController();
  final _buyQtyCtrl = TextEditingController();
  final _getQtyCtrl = TextEditingController();

  OfferType _type = OfferType.percentage;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _isAutoApplied = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final o = widget.existing!;
      _titleCtrl.text = o.title;
      _descCtrl.text = o.description ?? '';
      _discountCtrl.text = o.discountValue.toString();
      _minOrderCtrl.text = o.minOrderAmount?.toString() ?? '';
      _maxDiscountCtrl.text = o.maxDiscountAmount?.toString() ?? '';
      _buyQtyCtrl.text = o.buyQuantity?.toString() ?? '';
      _getQtyCtrl.text = o.getQuantity?.toString() ?? '';
      _type = o.type;
      _startDate = o.startDate;
      _endDate = o.endDate;
      _isAutoApplied = o.isAutoApplied;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _discountCtrl.dispose();
    _minOrderCtrl.dispose();
    _maxDiscountCtrl.dispose();
    _buyQtyCtrl.dispose();
    _getQtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final offer = Offer(
      id: widget.existing?.id ?? const Uuid().v4(),
      restaurantId: 'r1',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      type: _type,
      discountValue: double.tryParse(_discountCtrl.text) ?? 0,
      minOrderAmount: _minOrderCtrl.text.isEmpty
          ? null
          : double.tryParse(_minOrderCtrl.text),
      maxDiscountAmount: _maxDiscountCtrl.text.isEmpty
          ? null
          : double.tryParse(_maxDiscountCtrl.text),
      buyQuantity:
          _buyQtyCtrl.text.isEmpty ? null : int.tryParse(_buyQtyCtrl.text),
      getQuantity:
          _getQtyCtrl.text.isEmpty ? null : int.tryParse(_getQtyCtrl.text),
      startDate: _startDate,
      endDate: _endDate,
      status: OfferStatus.active,
      isAutoApplied: _isAutoApplied,
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    if (widget.existing == null) {
      await ref.read(offersProvider.notifier).createOffer(offer);
    } else {
      await ref.read(offersProvider.notifier).updateOffer(offer);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Create Offer' : 'Edit Offer'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Offer type
            Text('Offer Type', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: OfferType.values.map((t) {
                final labels = {
                  OfferType.percentage: '% Discount',
                  OfferType.fixedAmount: 'Fixed Amount',
                  OfferType.buyXGetY: 'Buy X Get Y',
                  OfferType.freeItem: 'Free Item',
                };
                return ChoiceChip(
                  label: Text(labels[t]!),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                  selectedColor: AppColors.primary.withOpacity(0.15),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Offer Title *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // Description
            TextFormField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Discount value (if applicable)
            if (_type == OfferType.percentage || _type == OfferType.fixedAmount)
              Column(
                children: [
                  TextFormField(
                    controller: _discountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _type == OfferType.percentage
                          ? 'Discount %  *'
                          : 'Discount Amount (SAR) *',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            // Buy/Get quantities
            if (_type == OfferType.buyXGetY)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buyQtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Buy Qty *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _getQtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Get Qty *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),

            // Min order / max discount
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minOrderCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Order (SAR)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _maxDiscountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Discount (SAR)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date range
            Text('Duration', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DateTile(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTile(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Auto apply
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto Apply'),
              subtitle: const Text('Apply offer automatically at checkout'),
              value: _isAutoApplied,
              onChanged: (v) => setState(() => _isAutoApplied = v),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                  widget.existing == null ? 'Create Offer' : 'Update Offer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const _DateTile(
      {required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondaryLight)),
            const SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
