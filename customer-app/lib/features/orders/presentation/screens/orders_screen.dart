import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class _Order {
  final String id, restaurant, items, total, status, date;
  const _Order(this.id, this.restaurant, this.items, this.total, this.status, this.date);
}

const _kOrders = [
  _Order('ord-001', 'Burger District', '2 Signature Burger, 1 Fries', '102 SAR', 'Delivering', '27 Jul, 2:45 PM'),
  _Order('ord-002', 'Mina Kitchen', '1 Shawarma Mix, 2 Drinks', '58 SAR', 'Delivered', '25 Jul, 7:20 PM'),
  _Order('ord-003', 'Green Bowl', '2 Acai Bowl', '84 SAR', 'Delivered', '22 Jul, 1:10 PM'),
  _Order('ord-004', 'Pizza Palace', '1 Pepperoni Large, 2 Drinks', '75 SAR', 'Cancelled', '18 Jul, 9:00 PM'),
];

Color _statusColor(String s) {
  switch (s) {
    case 'Delivering': return AppColors.info;
    case 'Delivered': return AppColors.success;
    case 'Cancelled': return AppColors.error;
    default: return Colors.orange;
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const TabBar(tabs: [Tab(text: 'Active'), Tab(text: 'Past')]),
        ),
        body: TabBarView(children: [
          _buildList(context, _kOrders.where((o) => o.status == 'Delivering' || o.status == 'Preparing').toList()),
          _buildList(context, _kOrders.where((o) => o.status == 'Delivered' || o.status == 'Cancelled').toList()),
        ]),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<_Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
        SizedBox(height: 12),
        Text('No orders here', style: TextStyle(color: Colors.grey)),
      ]));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (_, i) => _OrderCard(order: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(RouteNames.orderDetail.replaceFirst(':id', order.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(order.restaurant, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(order.status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 6),
            Text(order.items, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            Row(children: [
              Text(order.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Spacer(),
              Text(order.total, style: const TextStyle(fontWeight: FontWeight.bold)),
            ]),
            if (order.status == 'Delivering') ...[
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => context.push(RouteNames.tracking.replaceFirst(':id', order.id)),
                  icon: const Icon(Icons.location_on, size: 16),
                  label: const Text('Track Order'),
                )),
                const SizedBox(width: 8),
                Expanded(child: FilledButton(
                  onPressed: () {},
                  child: const Text('Contact'),
                )),
              ]),
            ],
            if (order.status == 'Delivered') ...[
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Reorder'),
                )),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(
                  onPressed: () => context.push(RouteNames.reviews.replaceFirst(':orderId', order.id)),
                  child: const Text('Rate'),
                )),
              ]),
            ],
          ]),
        ),
      ),
    );
  }
}
