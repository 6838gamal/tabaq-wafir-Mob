import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});
  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _orderType = 0; // 0=delivery, 1=pickup
  int _paymentMethod = 0; // 0=card, 1=cash, 2=wallet
  bool _isLoading = false;
  String _notes = '';

  static const _orderTypes = ['Delivery', 'Pickup'];
  static const _payments = [
    ('Credit / Debit Card', Icons.credit_card),
    ('Cash on Delivery', Icons.money),
    ('Wallet (85 SAR)', Icons.account_balance_wallet),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order type
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Order Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                SegmentedButton<int>(
                  segments: [
                    for (int i = 0; i < _orderTypes.length; i++)
                      ButtonSegment(value: i, label: Text(_orderTypes[i])),
                  ],
                  selected: {_orderType},
                  onSelectionChanged: (s) => setState(() => _orderType = s.first),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Address (delivery only)
          if (_orderType == 0) Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
              title: const Text('Al Olaya, Riyadh', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Block 5, Villa 12, Near Al Faisaliah Tower'),
              trailing: TextButton(onPressed: () => context.push(RouteNames.addresses), child: const Text('Change')),
            ),
          ),
          const SizedBox(height: 12),

          // Payment
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                for (int i = 0; i < _payments.length; i++)
                  RadioListTile<int>(
                    value: i,
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    secondary: Icon(_payments[i].$2),
                    title: Text(_payments[i].$1),
                    contentPadding: EdgeInsets.zero,
                  ),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Notes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Special instructions (optional)',
                  prefixIcon: Icon(Icons.note_outlined),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (v) => _notes = v,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _Row('Subtotal', '110 SAR'),
                const SizedBox(height: 8),
                if (_orderType == 0) _Row('Delivery fee', '12 SAR'),
                const Divider(height: 20),
                _Row('Total', '122 SAR', bold: true),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _placeOrder,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Place Order · 122 SAR', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(RouteNames.tracking.replaceFirst(':id', 'order-123'));
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _Row(this.label, this.value, {this.bold = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 16 : 14)),
      Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: bold ? 16 : 14, color: bold ? AppColors.primary : null)),
    ],
  );
}
