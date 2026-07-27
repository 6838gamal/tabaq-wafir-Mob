import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';

class AvailabilityToggle extends ConsumerWidget {
  const AvailabilityToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(driverOnlineProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          CircleAvatar(
            backgroundColor: isOnline ? AppColors.online.withOpacity(0.12) : AppColors.offline.withOpacity(0.12),
            child: Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              color: isOnline ? AppColors.online : AppColors.offline,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              isOnline ? 'You are Online' : 'You are Offline',
              style: TextStyle(fontWeight: FontWeight.bold, color: isOnline ? AppColors.online : AppColors.textPrimary),
            ),
            Text(
              isOnline ? 'Accepting delivery offers' : 'Go online to receive orders',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ])),
          Switch(
            value: isOnline,
            onChanged: (v) => ref.read(driverOnlineProvider.notifier).state = v,
            activeColor: AppColors.online,
          ),
        ]),
      ),
    );
  }
}
