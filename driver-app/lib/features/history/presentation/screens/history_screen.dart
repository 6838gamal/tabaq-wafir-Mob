import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _deliveries = [
    _Delivery('Burger District → Al Malqa', '32 SAR', '4.2 km', '28 min', '27 Jul, 3:12 PM', 5),
    _Delivery('Mina Kitchen → Al Olaya', '28 SAR', '3.8 km', '22 min', '27 Jul, 1:45 PM', 5),
    _Delivery('Green Bowl → Al Nakheel', '25 SAR', '3.1 km', '19 min', '27 Jul, 12:10 PM', 4),
    _Delivery('Pizza Palace → Al Aqiq', '38 SAR', '6.2 km', '42 min', '26 Jul, 8:30 PM', 5),
    _Delivery('Sweet Tooth → Al Wurud', '22 SAR', '2.8 km', '18 min', '26 Jul, 6:00 PM', 5),
    _Delivery('Sushi Corner → Al Hamra', '35 SAR', '5.1 km', '35 min', '25 Jul, 7:20 PM', 4),
  ];

  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => _filter = v),
            itemBuilder: (_) => ['All', 'Today', 'This week'].map((f) => PopupMenuItem(value: f, child: Text(f))).toList(),
            child: Padding(padding: const EdgeInsets.only(right: 12), child: Row(children: [Text(_filter), const Icon(Icons.arrow_drop_down)])),
          ),
        ],
      ),
      body: Column(children: [
        // Summary bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: AppColors.surfaceVariant,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
            _SumStat('192', 'Total'),
            _SumStat('4,840 SAR', 'Earned'),
            _SumStat('1,240 km', 'Distance'),
            _SumStat('4.9 ★', 'Rating'),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _deliveries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (_, i) => _DeliveryCard(d: _deliveries[i]),
          ),
        ),
      ]),
    );
  }
}

class _SumStat extends StatelessWidget {
  final String value, label;
  const _SumStat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
  ]);
}

class _DeliveryCard extends StatelessWidget {
  final _Delivery d;
  const _DeliveryCard({required this.d});
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.success.withOpacity(0.1),
        child: const Icon(Icons.check, color: AppColors.success),
      ),
      title: Text(d.route, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text('${d.distance} · ${d.time} · ${d.date}', style: const TextStyle(fontSize: 11)),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(d.earnings, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
        Row(mainAxisSize: MainAxisSize.min, children: List.generate(d.rating, (_) => const Icon(Icons.star, size: 10, color: Colors.amber))),
      ]),
    ),
  );
}

class _Delivery {
  final String route, earnings, distance, time, date;
  final int rating;
  const _Delivery(this.route, this.earnings, this.distance, this.time, this.date, this.rating);
}
