import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';

class ActiveOrderScreen extends StatefulWidget {
  const ActiveOrderScreen({super.key});
  @override
  State<ActiveOrderScreen> createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  int _step = 0; // 0=heading to restaurant, 1=picked up, 2=heading to customer
  final _steps = ['Head to Restaurant', 'Pick Up Order', 'Deliver to Customer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_steps[_step]),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(children: [
        // Map placeholder
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.grey.shade200,
            child: Stack(children: [
              const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 8),
                Text('Live navigation map', style: TextStyle(color: Colors.grey)),
              ])),
              Positioned(
                top: 12, left: 12, right: 12,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(children: [
                      Icon(Icons.navigation, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Expanded(child: Text('Burger District, Al Olaya', style: TextStyle(fontWeight: FontWeight.bold))),
                      const Text('8 min', style: TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ),
            ]),
          ),
        ),

        // Order card
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // Step indicator
            Row(children: List.generate(_steps.length, (i) => Expanded(child: Column(children: [
              Row(children: [
                if (i > 0) Expanded(child: Container(height: 2, color: i <= _step ? AppColors.primary : Colors.grey.shade300)),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: i <= _step ? AppColors.primary : Colors.grey.shade300,
                  child: Text('${i+1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                if (i < _steps.length - 1) Expanded(child: Container(height: 2, color: i < _step ? AppColors.primary : Colors.grey.shade300)),
              ]),
            ])))),
            const SizedBox(height: 12),
            Text(_steps[_step], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            // Order details
            Card(child: Column(children: [
              ListTile(
                dense: true,
                leading: const Icon(Icons.store_outlined),
                title: const Text('Burger District — Al Olaya'),
                subtitle: const Text('Order #ORD-001 · 3 items'),
                trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined, color: AppColors.primary)),
              ),
              if (_step == 1) ListTile(
                dense: true,
                leading: const Icon(Icons.person_outline),
                title: const Text('Ahmed Al-Rashidi'),
                subtitle: const Text('Al Malqa District, Riyadh'),
                trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined, color: AppColors.primary)),
              ),
            ])),
            const SizedBox(height: 12),

            Row(children: [
              if (_step > 0) Expanded(child: OutlinedButton(
                onPressed: () => setState(() => _step--),
                child: const Text('Back'),
              )),
              if (_step > 0) const SizedBox(width: 12),
              Expanded(child: FilledButton(
                onPressed: () {
                  if (_step < 2) {
                    setState(() => _step++);
                  } else {
                    context.go(RouteNames.home);
                  }
                },
                child: Text(_step == 2 ? 'Complete Delivery' : _steps[_step + 1]),
              )),
            ]),
          ]),
        ),
      ]),
    );
  }
}
