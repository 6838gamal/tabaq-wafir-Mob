import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class RateOrderScreen extends StatefulWidget {
  final String orderId;
  const RateOrderScreen({super.key, required this.orderId});
  @override
  State<RateOrderScreen> createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> {
  int _restaurantRating = 0;
  int _driverRating = 0;
  final _commentCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() { _commentCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildThankYou(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Order')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(child: CircleAvatar(radius: 36, child: Icon(Icons.restaurant, size: 36))),
          const SizedBox(height: 12),
          const Center(child: Text('Burger District', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          const Center(child: Text('Order #ORD-001', style: TextStyle(color: Colors.grey))),
          const SizedBox(height: 28),

          _RatingSection('Rate the restaurant', _restaurantRating, (r) => setState(() => _restaurantRating = r)),
          const SizedBox(height: 20),
          _RatingSection('Rate the driver', _driverRating, (r) => setState(() => _driverRating = r)),
          const SizedBox(height: 20),

          // Quick tags
          const Text('What did you like?', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            'Good packaging', 'Hot food', 'Fast delivery', 'Tasty food', 'Friendly driver', 'Great value',
          ].map((t) => FilterChip(label: Text(t), onSelected: (_) {})).toList()),
          const SizedBox(height: 16),

          TextField(
            controller: _commentCtrl,
            decoration: const InputDecoration(
              labelText: 'Leave a comment (optional)',
              border: OutlineInputBorder(),
              hintText: 'Tell us about your experience...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: (_restaurantRating > 0 && _driverRating > 0) ? _submit : null,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            child: const Text('Submit Review'),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Skip')),
        ],
      ),
    );
  }

  void _submit() => setState(() => _submitted = true);

  Widget _buildThankYou(BuildContext context) => Scaffold(
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.check_circle, size: 80, color: AppColors.success),
      const SizedBox(height: 16),
      const Text('Thank you!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Your review helps others choose better.', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 24),
      FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Home')),
    ])),
  );
}

class _RatingSection extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  const _RatingSection(this.label, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(
      onPressed: () => onChanged(i + 1),
      icon: Icon(i < value ? Icons.star : Icons.star_border, color: Colors.amber, size: 36),
    ))),
  ]);
}
