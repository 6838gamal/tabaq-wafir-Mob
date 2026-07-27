import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/sidebar_layout.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Restaurant Details',
      currentRoute: '/restaurants',
      actions: [
        OutlinedButton.icon(onPressed: () => context.go('/restaurants/$id/approval'), icon: const Icon(Icons.rule, size: 16), label: const Text('Manage Approval')),
        const SizedBox(width: 8),
        FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 16), label: const Text('Edit')),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Card(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              CircleAvatar(radius: 32, backgroundColor: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.store, size: 32, color: AppColors.primary)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Burger District', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const Text('Al Olaya, King Fahd Road, Riyadh', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(children: [
                  _Chip('Approved', AppColors.success),
                  const SizedBox(width: 8),
                  _Chip('Burgers · American', AppColors.primary),
                ]),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
                Text('248', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                Text('total orders', style: TextStyle(color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Row(children: [Icon(Icons.star, size: 14, color: Colors.amber), SizedBox(width: 4), Text('4.8 rating')]),
              ]),
            ]),
          )),
          const SizedBox(height: 16),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(children: [
              _InfoCard('Contact', [
                _Row('Owner', 'Ahmed Al-Rashidi'),
                _Row('Phone', '+966 50 123 4567'),
                _Row('Email', 'admin@burgerdistrict.sa'),
                _Row('WhatsApp', '+966 50 123 4567'),
              ]),
              const SizedBox(height: 16),
              _InfoCard('Subscription', [
                _Row('Plan', 'Professional'),
                _Row('Status', 'Active'),
                _Row('Renewal', '27 Aug 2026'),
                _Row('Monthly fee', '499 SAR'),
              ]),
            ])),
            const SizedBox(width: 16),
            Expanded(child: Column(children: [
              _InfoCard('Performance', [
                _Row('Orders this month', '48'),
                _Row('Revenue this month', '18,420 SAR'),
                _Row('Avg order value', '384 SAR'),
                _Row('Cancellation rate', '2.4%'),
              ]),
              const SizedBox(height: 16),
              _InfoCard('Branches', [
                _Row('Total branches', '2'),
                _Row('Active', '2'),
                _Row('Main branch', 'Al Olaya'),
              ]),
            ])),
          ]),
          const SizedBox(height: 16),

          // Action buttons
          Row(children: [
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.block, color: AppColors.error), label: const Text('Suspend', style: TextStyle(color: AppColors.error))),
            const SizedBox(width: 8),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.email_outlined), label: const Text('Email Owner')),
            const SizedBox(width: 8),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.history_outlined), label: const Text('Audit Log')),
          ]),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
  );
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  const _InfoCard(this.title, this.rows);
  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      const SizedBox(height: 10),
      ...rows,
    ]),
  ));
}

class _Row extends StatelessWidget {
  final String label, value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    ]),
  );
}
