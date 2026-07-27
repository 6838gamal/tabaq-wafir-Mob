import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${orderId.toUpperCase()}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status timeline
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Order Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                _StatusStep('Order placed', true, '2:45 PM'),
                _StatusStep('Restaurant accepted', true, '2:48 PM'),
                _StatusStep('Being prepared', true, '2:50 PM'),
                _StatusStep('Driver picked up', true, '3:05 PM'),
                _StatusStep('Delivered', false, ''),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Items
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                const _ItemRow('Signature Burger', 2, 84),
                const _ItemRow('Classic Fries', 1, 18),
                const Divider(height: 20),
                const _ItemRow('Subtotal', null, 102),
                const SizedBox(height: 4),
                const _ItemRow('Delivery fee', null, 12),
                const Divider(height: 16),
                const _ItemRow('Total', null, 114, bold: true),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Delivery details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Delivery Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                const ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.location_on_outlined, color: AppColors.primary),
                  title: Text('Al Olaya, Riyadh'),
                  subtitle: Text('Block 5, Villa 12, Near Al Faisaliah Tower'),
                ),
                const ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.payment_outlined),
                  title: Text('Credit Card'),
                  subtitle: Text('Paid'),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Actions
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () => context.push(RouteNames.tracking.replaceFirst(':id', orderId)),
              icon: const Icon(Icons.location_on),
              label: const Text('Track'),
            )),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton.icon(
              onPressed: () => context.push(RouteNames.chat.replaceFirst(':id', orderId)),
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Chat'),
            )),
            const SizedBox(width: 8),
            Expanded(child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.replay),
              label: const Text('Reorder'),
            )),
          ]),
        ],
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String label, time;
  final bool done;
  const _StatusStep(this.label, this.done, this.time);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(children: [
        Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? AppColors.success : Colors.grey, size: 20),
        if (label != 'Delivered')
          Container(width: 2, height: 28, color: done ? AppColors.success : Colors.grey.shade300),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Text(label, style: TextStyle(color: done ? null : Colors.grey)),
          const Spacer(),
          if (done) Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      )),
    ]);
  }
}

class _ItemRow extends StatelessWidget {
  final String name;
  final int? qty;
  final double price;
  final bool bold;
  const _ItemRow(this.name, this.qty, this.price, {this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [
      if (qty != null) Text('${qty}x  ', style: const TextStyle(color: Colors.grey)),
      Expanded(child: Text(name, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
      Text('${price.toStringAsFixed(0)} SAR', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500, color: bold ? AppColors.primary : null)),
    ]),
  );
}
