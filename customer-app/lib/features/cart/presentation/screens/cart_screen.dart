import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class _CartItem {
  final String name, extras;
  final double price;
  int qty;
  _CartItem(this.name, this.extras, this.price, this.qty);
}

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _items = [
    _CartItem('Signature Burger', 'No pickles', 42, 2),
    _CartItem('Classic Fries', 'Large', 18, 1),
    _CartItem('Soft Drink', 'Pepsi', 8, 2),
  ];
  String _couponCode = '';
  double _discount = 0;

  double get _subtotal => _items.fold(0, (s, i) => s + i.price * i.qty);
  double get _deliveryFee => 12;
  double get _total => _subtotal + _deliveryFee - _discount;

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return _buildEmpty(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          TextButton(
            onPressed: () => setState(() => _items.clear()),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.store_outlined),
                    title: Text('Burger District', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Al Olaya Branch'),
                  ),
                  const Divider(height: 1),
                  ..._items.map((item) => _CartItemTile(
                    item: item,
                    onQtyChanged: (q) => setState(() {
                      if (q == 0) _items.remove(item); else item.qty = q;
                    }),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Coupon code',
                        prefixIcon: Icon(Icons.local_offer_outlined),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (v) => _couponCode = v,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (_couponCode.toUpperCase() == 'SAVE10') {
                        setState(() => _discount = _subtotal * 0.1);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('10% discount applied!')));
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  _SummaryRow('Subtotal', '${_subtotal.toStringAsFixed(0)} SAR'),
                  const SizedBox(height: 8),
                  _SummaryRow('Delivery fee', '${_deliveryFee.toStringAsFixed(0)} SAR'),
                  if (_discount > 0) ...[
                    const SizedBox(height: 8),
                    _SummaryRow('Discount', '-${_discount.toStringAsFixed(0)} SAR', color: Colors.green),
                  ],
                  const Divider(height: 20),
                  _SummaryRow('Total', '${_total.toStringAsFixed(0)} SAR', bold: true),
                ]),
              ),
            ),
          ],
        )),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => context.push(RouteNames.checkout),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: Text('Checkout · ${_total.toStringAsFixed(0)} SAR'),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        const Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
        const SizedBox(height: 12),
        FilledButton(onPressed: () => context.pop(), child: const Text('Browse Restaurants')),
      ])),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final _CartItem item;
  final ValueChanged<int> onQtyChanged;
  const _CartItemTile({required this.item, required this.onQtyChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(item.extras, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('${(item.price * item.qty).toStringAsFixed(0)} SAR', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            _QtyButton(Icons.remove, () => onQtyChanged(item.qty - 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('${item.qty}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            _QtyButton(Icons.add, () => onQtyChanged(item.qty + 1)),
          ]),
        ),
      ]),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(4),
    child: Container(
      width: 24, height: 24,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, size: 16, color: Colors.white),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? color;
  const _SummaryRow(this.label, this.value, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 16 : 14)),
      Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: bold ? 16 : 14, color: color)),
    ],
  );
}
