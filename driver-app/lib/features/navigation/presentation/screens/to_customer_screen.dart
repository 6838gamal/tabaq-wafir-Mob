import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';

class ToCustomerScreen extends StatelessWidget {
  const ToCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate to Customer'),
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
      ),
      body: Column(children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.grey.shade200,
            child: Stack(children: [
              const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 8),
                Text('Turn-by-turn navigation', style: TextStyle(color: Colors.grey)),
                Text('(requires Google Maps API key)', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ])),
              Positioned(
                top: 12, left: 12, right: 12,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(children: [
                      Icon(Icons.turn_left, color: AppColors.success, size: 32),
                      const SizedBox(width: 12),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Turn left on Al Urubah Road', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('In 500 m', style: TextStyle(color: Colors.grey)),
                      ])),
                      const Text('12\nmin', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ]),
                  ),
                ),
              ),
            ]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Card(child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('Ahmed Al-Rashidi', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Al Malqa District, Villa 12 · 6.8 km · 12 min'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined, color: AppColors.primary)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.chat_outlined, color: AppColors.primary)),
              ]),
            )),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close),
                label: const Text('Cancel'),
              )),
              const SizedBox(width: 12),
              Expanded(child: FilledButton.icon(
                onPressed: () => context.push('/delivery-proof/ord-001'),
                icon: const Icon(Icons.check),
                label: const Text('Delivered'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.success),
              )),
            ]),
          ]),
        ),
      ]),
    );
  }
}
