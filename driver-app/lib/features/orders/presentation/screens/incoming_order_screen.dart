import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';

class IncomingOrderScreen extends StatelessWidget {
  const IncomingOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Spacer(),
            // Offer card
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const CircleAvatar(backgroundColor: Color(0xFFE65100), child: Icon(Icons.store, color: Colors.white)),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Burger District', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Al Olaya Branch', style: TextStyle(color: Colors.grey)),
                  ])),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Al Malqa District', style: TextStyle(color: Colors.grey)),
                  ])),
                ]),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(children: [
                  _InfoTile(Icons.access_time, 'Pickup in', '8 min'),
                  _InfoTile(Icons.route, 'Distance', '4.2 km'),
                  _InfoTile(Icons.payments_outlined, 'Earnings', '32 SAR'),
                  _InfoTile(Icons.shopping_bag_outlined, 'Items', '3'),
                ]),
              ]),
            ),
            const Spacer(),
            // Timer
            const Text('15', style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold)),
            const Text('seconds to decide', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: 0.6, backgroundColor: Colors.white24, color: AppColors.primary),
            const Spacer(),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  minimumSize: const Size.fromHeight(54),
                ),
                child: const Text('Decline', style: TextStyle(fontSize: 16)),
              )),
              const SizedBox(width: 16),
              Expanded(child: FilledButton(
                onPressed: () => context.go(RouteNames.orderActive),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
                child: const Text('Accept', style: TextStyle(fontSize: 16)),
              )),
            ]),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Icon(icon, color: AppColors.primary, size: 22),
    const SizedBox(height: 4),
    Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
  ]));
}
