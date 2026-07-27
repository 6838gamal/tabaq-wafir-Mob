import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';

class TodaySummaryCard extends ConsumerWidget {
  const TodaySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Today's Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 14),
          summary.when(
            data: (s) => Row(children: [
              _Stat('Deliveries', '${s.completedDeliveries}', Icons.delivery_dining_outlined, AppColors.primary),
              _Stat('Earnings', '${s.earnings.toStringAsFixed(0)} SAR', Icons.account_balance_wallet_outlined, AppColors.success),
              _Stat('Rating', '${s.rating}', Icons.star_outline, Colors.amber),
              _Stat('Distance', '${s.distanceKm.toStringAsFixed(0)} km', Icons.route_outlined, AppColors.info),
            ]),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Could not load summary'),
          ),
        ]),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Icon(icon, color: color, size: 22),
    const SizedBox(height: 4),
    Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
  ]));
}
