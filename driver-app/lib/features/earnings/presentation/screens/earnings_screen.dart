import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});
  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _period = 0; // 0=Today, 1=Week, 2=Month

  static const _periodLabels = ['Today', 'This Week', 'This Month'];
  static const _periods = [
    _Period('184 SAR', '7 deliveries', '42.5 km', '4h 20min'),
    _Period('1,260 SAR', '48 deliveries', '310 km', '32h 15min'),
    _Period('4,840 SAR', '192 deliveries', '1,240 km', '128h'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = _periods[_period];
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period selector
          SegmentedButton<int>(
            segments: [for (int i = 0; i < _periodLabels.length; i++) ButtonSegment(value: i, label: Text(_periodLabels[i]))],
            selected: {_period},
            onSelectionChanged: (s) => setState(() => _period = s.first),
          ),
          const SizedBox(height: 20),

          // Main earnings card
          Card(
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                Text('Total Earned', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                const SizedBox(height: 8),
                Text(p.earned, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _WhiteStat('Deliveries', p.deliveries),
                  _WhiteStat('Distance', p.distance),
                  _WhiteStat('Hours', p.hours),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Breakdown
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              _EarningRow('Base pay', '112 SAR'),
              _EarningRow('Tips', '36 SAR'),
              _EarningRow('Bonuses', '24 SAR'),
              _EarningRow('Promotions', '12 SAR'),
              const Divider(height: 16),
              _EarningRow('Total', '184 SAR', bold: true),
            ]),
          )),
          const SizedBox(height: 12),

          // Per-delivery table
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Deliveries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              for (final d in [
                ('Burger District → Al Malqa', '32 SAR', '3:12 PM'),
                ('Mina Kitchen → Al Olaya', '28 SAR', '1:45 PM'),
                ('Green Bowl → Al Nakheel', '25 SAR', '12:10 PM'),
              ]) ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(d.$1, style: const TextStyle(fontSize: 13)),
                subtitle: Text(d.$3, style: const TextStyle(fontSize: 11)),
                trailing: Text(d.$2, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
              ),
            ]),
          )),
        ],
      ),
    );
  }
}

class _Period {
  final String earned, deliveries, distance, hours;
  const _Period(this.earned, this.deliveries, this.distance, this.hours);
}

class _WhiteStat extends StatelessWidget {
  final String label, value;
  const _WhiteStat(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 2),
    Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
  ]);
}

class _EarningRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _EarningRow(this.label, this.value, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
      Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, color: bold ? AppColors.success : null)),
    ]),
  );
}
