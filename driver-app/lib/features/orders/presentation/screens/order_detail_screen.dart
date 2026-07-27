import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Order Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _ItemRow('2x', 'Signature Burger', '84 SAR'),
              _ItemRow('1x', 'Classic Fries', '18 SAR'),
              _ItemRow('2x', 'Soft Drink', '16 SAR'),
              const Divider(height: 20),
              _ItemRow('', 'Total', '118 SAR', bold: true),
            ]),
          )),
          const SizedBox(height: 12),
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Pickup Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.store_outlined, color: AppColors.primary),
                title: Text('Burger District'),
                subtitle: Text('Al Olaya, King Fahd Road, Riyadh'),
              ),
            ]),
          )),
          const SizedBox(height: 12),
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Delivery Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.home_outlined, color: AppColors.success),
                title: Text('Ahmed Al-Rashidi'),
                subtitle: Text('Al Malqa District, Villa 12, Riyadh'),
              ),
            ]),
          )),
          const SizedBox(height: 12),
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _InfoRow('Method', 'Credit Card'),
              _InfoRow('Status', 'Paid online'),
              _InfoRow('Your earnings', '32 SAR', color: AppColors.success),
            ]),
          )),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String qty, name, price;
  final bool bold;
  const _ItemRow(this.qty, this.name, this.price, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      if (qty.isNotEmpty) SizedBox(width: 28, child: Text(qty, style: const TextStyle(color: Colors.grey))),
      Expanded(child: Text(name, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
      Text(price, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500, color: bold ? AppColors.primary : null)),
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _InfoRow(this.label, this.value, {this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: Colors.grey))),
      Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
    ]),
  );
}
