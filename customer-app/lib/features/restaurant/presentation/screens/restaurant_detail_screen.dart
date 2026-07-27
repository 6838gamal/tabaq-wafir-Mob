import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isFavorite = false;
  int _cartCount = 0;

  static const _categories = ['All', 'Starters', 'Main', 'Sides', 'Drinks', 'Desserts'];
  static const _menuItems = [
    _MenuItem('Signature Burger', 'Crispy beef with special sauce, lettuce, tomato', '42 SAR', Icons.lunch_dining),
    _MenuItem('Double Smash', 'Double patty smash burger with cheddar', '58 SAR', Icons.lunch_dining),
    _MenuItem('Crispy Chicken', 'Spicy fried chicken fillet with pickles', '38 SAR', Icons.restaurant),
    _MenuItem('Classic Fries', 'Golden crispy fries with dipping sauce', '18 SAR', Icons.restaurant_menu),
    _MenuItem('Onion Rings', 'Beer-battered onion rings', '22 SAR', Icons.restaurant_menu),
    _MenuItem('Soft Drink', 'Pepsi, 7UP, or water', '8 SAR', Icons.local_drink),
    _MenuItem('Milkshake', 'Vanilla, chocolate, or strawberry', '28 SAR', Icons.local_cafe),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFE65100),
                child: const Center(child: Icon(Icons.lunch_dining, size: 80, color: Colors.white30)),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.white)),
            ],
          ),
          SliverToBoxAdapter(child: _buildRestaurantInfo()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: _categories.map((c) => Tab(text: c)).toList(),
            )),
          ),
        ],
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _menuItems.length,
          itemBuilder: (_, i) => _MenuItemCard(
            item: _menuItems[i],
            onAdd: () => setState(() => _cartCount++),
          ),
        ),
      ),
      bottomNavigationBar: _cartCount > 0
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () => context.push(RouteNames.cart),
                  icon: Badge(label: Text('$_cartCount'), child: const Icon(Icons.shopping_cart)),
                  label: const Text('View Cart'),
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Burger District', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Burgers · American · Fast Food', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        Row(children: [
          _InfoChip(Icons.star, '4.8', Colors.amber),
          const SizedBox(width: 8),
          _InfoChip(Icons.access_time, '25–35 min', Colors.blue),
          const SizedBox(width: 8),
          _InfoChip(Icons.delivery_dining, '12 SAR', Colors.green),
        ]),
        const SizedBox(height: 12),
        const Text('Minimum order: 30 SAR', style: TextStyle(color: Colors.grey, fontSize: 13)),
      ]),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _MenuItemCard extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onAdd;
  const _MenuItemCard({required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(radius: 28, child: Icon(item.icon)),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
        ),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(item.price, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 4),
          SizedBox(
            height: 30,
            width: 30,
            child: FilledButton(
              onPressed: onAdd,
              style: FilledButton.styleFrom(padding: EdgeInsets.zero),
              child: const Icon(Icons.add, size: 18),
            ),
          ),
        ]),
      ),
    );
  }
}

class _MenuItem {
  final String name, description, price;
  final IconData icon;
  const _MenuItem(this.name, this.description, this.price, this.icon);
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).scaffoldBackgroundColor, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
