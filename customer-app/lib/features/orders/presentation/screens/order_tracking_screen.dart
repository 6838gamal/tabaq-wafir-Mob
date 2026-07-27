import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
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
                Text('Live map tracking', style: TextStyle(color: Colors.grey)),
                Text('(requires Google Maps API key)', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ])),
              // Driver pin
              Positioned(
                top: 120, left: 180,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.delivery_dining, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 4),
                  const Text('Faris', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
              ),
              // Restaurant pin
              Positioned(
                top: 60, left: 80,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.store, color: Colors.white, size: 20),
                  ),
                ]),
              ),
              // Customer pin
              Positioned(
                bottom: 60, right: 80,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.home, color: Colors.white, size: 20),
                  ),
                ]),
              ),
            ]),
          ),
        ),

        // Driver info + status
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              // ETA banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.access_time, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Arriving in ~8 min', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                ]),
              ),
              const SizedBox(height: 16),

              // Driver card
              Card(
                child: ListTile(
                  leading: const CircleAvatar(radius: 24, child: Icon(Icons.person, size: 28)),
                  title: const Text('Faris Al-Otaibi', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Row(children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: 2),
                    Text('4.9 · Honda Civic · RUH-4521'),
                  ]),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(
                      backgroundColor: AppColors.success.withOpacity(0.1),
                      child: Icon(Icons.call, color: AppColors.success, size: 20),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(Icons.chat, color: AppColors.primary, size: 20),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 12),

              // Progress steps
              Row(children: [
                _Step('Placed', true),
                _StepLine(true),
                _Step('Preparing', true),
                _StepLine(true),
                _Step('Picked Up', true),
                _StepLine(false),
                _Step('Delivered', false),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _Step extends StatelessWidget {
  final String label;
  final bool done;
  const _Step(this.label, this.done);

  @override
  Widget build(BuildContext context) => Column(children: [
    Icon(done ? Icons.check_circle : Icons.circle_outlined,
        color: done ? AppColors.success : Colors.grey, size: 20),
    const SizedBox(height: 4),
    Text(label, style: TextStyle(fontSize: 10, color: done ? null : Colors.grey)),
  ]);
}

class _StepLine extends StatelessWidget {
  final bool done;
  const _StepLine(this.done);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(height: 2, color: done ? AppColors.success : Colors.grey.shade300),
  );
}
