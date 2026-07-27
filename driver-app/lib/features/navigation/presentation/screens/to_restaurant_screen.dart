import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';

class ToRestaurantScreen extends StatelessWidget {
  const ToRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate to Restaurant'),
        backgroundColor: AppColors.primary,
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
                      Icon(Icons.turn_right, color: AppColors.primary, size: 32),
                      const SizedBox(width: 12),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Turn right on King Fahd Road', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('In 200 m', style: TextStyle(color: Colors.grey)),
                      ])),
                      const Text('8\nmin', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE65100),
                child: Icon(Icons.store, color: Colors.white),
              ),
              title: const Text('Burger District — Al Olaya', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('4.2 km · 8 min away'),
              trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined, color: AppColors.primary)),
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
                onPressed: () => context.go(RouteNames.orderActive),
                icon: const Icon(Icons.check),
                label: const Text('Arrived'),
              )),
            ]),
          ]),
        ),
      ]),
    );
  }
}
