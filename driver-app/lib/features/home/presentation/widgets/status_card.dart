import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';

class StatusCard extends ConsumerWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(driverOnlineProvider);
    if (!isOnline) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Icon(Icons.bedtime_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('You\'re offline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('Go online to start receiving delivery offers.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
          ]),
        ),
      );
    }
    return Card(
      color: AppColors.primary.withOpacity(0.06),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Waiting for an offer...', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Stay close to restaurants for faster offers.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ])),
        ]),
      ),
    );
  }
}
