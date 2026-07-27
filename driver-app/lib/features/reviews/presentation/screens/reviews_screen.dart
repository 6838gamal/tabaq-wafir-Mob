import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  static const _reviews = [
    _Review('Ahmed Al-Rashidi', 5, 'Very fast delivery! Food was still hot.', '27 Jul'),
    _Review('Sara M.', 5, 'Excellent driver, very professional.', '26 Jul'),
    _Review('Khalid J.', 4, 'Good service. Slightly late but communicated well.', '25 Jul'),
    _Review('Nora A.', 5, 'Perfect delivery experience!', '24 Jul'),
    _Review('Omar S.', 5, 'Driver was very polite and quick.', '22 Jul'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reviews')),
      body: Column(children: [
        // Rating summary
        Container(
          padding: const EdgeInsets.all(20),
          color: AppColors.surfaceVariant,
          child: Row(children: [
            Column(children: const [
              Text('4.9', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Row(children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Icon(Icons.star, color: Colors.amber, size: 16),
                Icon(Icons.star, color: Colors.amber, size: 16),
                Icon(Icons.star, color: Colors.amber, size: 16),
                Icon(Icons.star, color: Colors.amber, size: 16),
              ]),
              SizedBox(height: 4),
              Text('192 reviews', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ]),
            const SizedBox(width: 24),
            Expanded(child: Column(children: [
              _RatingBar(5, 0.85),
              _RatingBar(4, 0.10),
              _RatingBar(3, 0.03),
              _RatingBar(2, 0.01),
              _RatingBar(1, 0.01),
            ])),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _reviews.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => _ReviewTile(r: _reviews[i]),
          ),
        ),
      ]),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int stars;
  final double fraction;
  const _RatingBar(this.stars, this.fraction);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [
      Text('$stars', style: const TextStyle(fontSize: 11)),
      const SizedBox(width: 4),
      const Icon(Icons.star, size: 10, color: Colors.amber),
      const SizedBox(width: 4),
      Expanded(child: LinearProgressIndicator(value: fraction, backgroundColor: Colors.grey.shade300, color: Colors.amber)),
    ]),
  );
}

class _ReviewTile extends StatelessWidget {
  final _Review r;
  const _ReviewTile({required this.r});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(child: Text(r.name[0])),
    title: Row(children: [
      Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      const Spacer(),
      Row(children: List.generate(r.stars, (_) => const Icon(Icons.star, size: 12, color: Colors.amber))),
    ]),
    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(r.comment, style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 2),
      Text(r.date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ]),
    isThreeLine: true,
  );
}

class _Review {
  final String name, comment, date;
  final int stars;
  const _Review(this.name, this.stars, this.comment, this.date);
}
