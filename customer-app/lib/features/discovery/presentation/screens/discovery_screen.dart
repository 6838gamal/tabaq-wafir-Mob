import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

const _kCategories = ['All', 'Burgers', 'Pizza', 'Arabic', 'Healthy', 'Sushi', 'Sandwiches', 'Desserts'];

const _kRestaurants = [
  _RestaurantData('r1', 'Burger District', 'Burgers · American', '4.8', '25–35 min', '12 SAR delivery', Icons.lunch_dining, Color(0xFFE65100)),
  _RestaurantData('r2', 'Mina Kitchen', 'Arabic · Grills', '4.7', '30–45 min', 'Free delivery', Icons.restaurant, Color(0xFF4E342E)),
  _RestaurantData('r3', 'Green Bowl', 'Healthy · Salads', '4.9', '20–30 min', '8 SAR delivery', Icons.eco, Color(0xFF2E7D32)),
  _RestaurantData('r4', 'Pizza Palace', 'Italian · Pizza', '4.6', '35–50 min', '15 SAR delivery', Icons.local_pizza, Color(0xFFC62828)),
  _RestaurantData('r5', 'Sushi Corner', 'Japanese · Sushi', '4.8', '40–55 min', '20 SAR delivery', Icons.set_meal, Color(0xFF1565C0)),
  _RestaurantData('r6', 'Sweet Tooth', 'Desserts · Cafe', '4.7', '20–25 min', 'Free delivery', Icons.cake, Color(0xFF6A1B9A)),
];

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deliver to', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Row(children: [
              Icon(Icons.location_on, size: 16, color: Colors.orange),
              SizedBox(width: 4),
              Text('Al Olaya, Riyadh', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Icon(Icons.keyboard_arrow_down, size: 18),
            ]),
          ],
        ),
        actions: [
          IconButton(onPressed: () => context.push(RouteNames.notifications), icon: const Icon(Icons.notifications_outlined)),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildSearchBar(context)),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(child: _buildPromoCard(context)),
            SliverToBoxAdapter(child: _buildSectionTitle('Popular Near You')),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _RestaurantCard(restaurant: _kRestaurants[i]),
                childCount: _kRestaurants.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: GestureDetector(
        onTap: () => context.push(RouteNames.search),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(children: [
            SizedBox(width: 12),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8),
            Text('Search restaurants or dishes', style: TextStyle(color: Colors.grey)),
          ]),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _kCategories.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: FilterChip(
            label: Text(_kCategories[i]),
            selected: _selectedCategory == i,
            onSelected: (_) => setState(() => _selectedCategory = i),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: AppColors.primary,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: const Icon(Icons.local_offer, color: Colors.white, size: 32),
          title: const Text('Free delivery this week!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('On orders above 50 SAR', style: TextStyle(color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.white),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final _RestaurantData restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(RouteNames.restaurant.replaceFirst(':id', restaurant.id)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: restaurant.color.withOpacity(0.15),
              child: Icon(restaurant.icon, color: restaurant.color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Text(restaurant.cuisine, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(restaurant.rating, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 2),
                Text(restaurant.deliveryTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
              const SizedBox(height: 8),
              Text(restaurant.deliveryFee, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _RestaurantData {
  final String id, name, cuisine, rating, deliveryTime, deliveryFee;
  final IconData icon;
  final Color color;
  const _RestaurantData(this.id, this.name, this.cuisine, this.rating, this.deliveryTime, this.deliveryFee, this.icon, this.color);
}
