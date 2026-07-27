import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/coupon.dart';
import '../providers/promotions_provider.dart';
import '../../../../core/theme/app_colors.dart';

class CreateCouponScreen extends ConsumerStatefulWidget {
  final Coupon? existing;
  const CreateCouponScreen({super.key, this.existing});

  @override
  ConsumerState<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends ConsumerState<CreateCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  final _minOrderCtrl = TextEditingController();
  final _maxDiscountCtrl = TextEditingController();
  final _usageLimitCtrl = TextEditingController();
  final _perCustomerCtrl = TextEditingController();

  CouponDiscountType _discountType = CouponDiscountType.percentage;
  DateTime? _expiryDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final c = widget.existing!;
      _codeCtrl.text = c.code;
      _descCtrl.text = c.description ?? '';
      _discountCtrl.text = c.discountValue.toString();
      _minOrderCtrl.text = c.minOrderAmount?.toString() ?? '';
      _maxDiscountCtrl.text = c.maxDiscountAmount?.toString() ?? '';
      _usageLimitCtrl.text = c.usageLimit?.toString() ?? '';
      _perCustomerCtrl.text = c.perCustomerLimit?.toString() ?? '';
      _discountType = c.discountType;
      _expiryDate = c.expiryDate;
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _discountCtrl.dispose();
    _minOrderCtrl.dispose();
    _maxDiscountCtrl.dispose();
    _usageLimitCtrl.dispose();
    _perCustomerCtrl.dispose();
    super.dispose();
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
        8, (i) => chars[(rand + i * 7) % chars.length]).join();
  }

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final coupon = Coupon(
      id: widget.existing?.id ?? const Uuid().v4(),
      restaurantId: 'r1',
      code: _codeCtrl.text.trim().toUpperCase(),
      description:
          _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      discountType: _discountType,
      discountValue: double.tryParse(_discountCtrl.text) ?? 0,
      minOrderAmount: _minOrderCtrl.text.isEmpty
          ? null
          : double.tryParse(_minOrderCtrl.text),
      maxDiscountAmount: _maxDiscountCtrl.text.isEmpty
          ? null
          : double.tryParse(_maxDiscountCtrl.text),
      expiryDate: _expiryDate,
      status: CouponStatus.active,
      usageLimit: _usageLimitCtrl.text.isEmpty
          ? null
          : int.tryParse(_usageLimitCtrl.text),
      perCustomerLimit: _perCustomerCtrl.text.isEmpty
          ? null
          : int.tryParse(_perCustomerCtrl.text),
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    if (widget.existing == null) {
      await ref.read(couponsProvider.notifier).createCoupon(coupon);
    } else {
      await ref.read(couponsProvider.notifier).updateCoupon(coupon);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Create Coupon' : 'Edit Coupon'),
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
            // Code
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _codeCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Coupon Code *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () =>
                      setState(() => _codeCtrl.text = _generateCode()),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Auto'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Discount type
            Text('Discount Type', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<CouponDiscountType>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Percentage'),
                    value: CouponDiscountType.percentage,
                    groupValue: _discountType,
                    onChanged: (v) => setState(() => _discountType = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<CouponDiscountType>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fixed Amount'),
                    value: CouponDiscountType.fixedAmount,
                    groupValue: _discountType,
                    onChanged: (v) => setState(() => _discountType = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

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

            // Discount value
            TextFormField(
              controller: _discountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _discountType == CouponDiscountType.percentage
                    ? 'Discount % *'
                    : 'Discount Amount (SAR) *',
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),

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
            const SizedBox(height: 12),

            // Usage limits
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _usageLimitCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Usage Limit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _perCustomerCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Per Customer Limit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expiry
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(_expiryDate == null
                  ? 'No Expiry Date'
                  : 'Expires: ${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_expiryDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _expiryDate = null),
                    ),
                  TextButton(onPressed: _pickExpiry, child: const Text('Set')),
                ],
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kpiPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                  widget.existing == null ? 'Create Coupon' : 'Update Coupon'),
            ),
          ],
        ),
      ),
    );
  }
}
