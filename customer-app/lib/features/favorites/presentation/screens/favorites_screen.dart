import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favorites = [
    _FavData('r2', 'Mina Kitchen', 'Arabic · Grills', '4.7', Icons.restaurant, const Color(0xFF4E342E)),
    _FavData('r3', 'Green Bowl', 'Healthy · Salads', '4.9', Icons.eco, const Color(0xFF2E7D32)),
    _FavData('r6', 'Sweet Tooth', 'Desserts · Cafe', '4.7', Icons.cake, const Color(0xFF6A1B9A)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _favorites.isEmpty
          ? _buildEmpty()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _favorites.length,
              itemBuilder: (_, i) => _FavCard(
                fav: _favorites[i],
                onRemove: () => setState(() => _favorites.removeAt(i)),
              ),
            ),
    );
  }

  Widget _buildEmpty() => const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
    SizedBox(height: 16),
    Text('No favorites yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
    SizedBox(height: 8),
    Text('Tap ❤️ on any restaurant to save it here.', style: TextStyle(color: Colors.grey)),
  ]));
}

class _FavCard extends StatelessWidget {
  final _FavData fav;
  final VoidCallback onRemove;
  const _FavCard({required this.fav, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(RouteNames.restaurant.replaceFirst(':id', fav.id)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: fav.color.withOpacity(0.15),
              child: Icon(fav.icon, color: fav.color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(fav.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(fav.cuisine, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(fav.rating, style: const TextStyle(fontSize: 12)),
              ]),
            ])),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.favorite, color: Colors.red),
            ),
          ]),
        ),
      ),
    );
  }
}

class _FavData {
  final String id, name, cuisine, rating;
  final IconData icon;
  final Color color;
  const _FavData(this.id, this.name, this.cuisine, this.rating, this.icon, this.color);
}
