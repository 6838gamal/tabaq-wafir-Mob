import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/sidebar_layout.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});
  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  String _filter = 'All';
  String _search = '';

  static const _restaurants = [
    _Restaurant('r001', 'Burger District', 'Al Olaya, Riyadh', 'approved', '248 orders', '4.8'),
    _Restaurant('r002', 'Mina Kitchen', 'Al Hamra, Riyadh', 'approved', '192 orders', '4.7'),
    _Restaurant('r003', 'Green Bowl', 'Al Nakheel, Riyadh', 'approved', '156 orders', '4.9'),
    _Restaurant('r004', 'Pizza Palace', 'Al Wurud, Riyadh', 'pending', '0 orders', '—'),
    _Restaurant('r005', 'Sweet Tooth', 'Al Malqa, Riyadh', 'suspended', '12 orders', '3.2'),
    _Restaurant('r006', 'Sushi Corner', 'Al Aqiq, Riyadh', 'pending', '0 orders', '—'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _restaurants.where((r) =>
      (_filter == 'All' || r.status == _filter.toLowerCase()) &&
      (r.name.toLowerCase().contains(_search.toLowerCase()) || r.location.toLowerCase().contains(_search.toLowerCase()))
    ).toList();

    return AdminScaffold(
      title: 'Restaurants',
      currentRoute: '/restaurants',
      actions: [
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Restaurant'),
        ),
      ],
      body: Column(children: [
        // Search + filter bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            )),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _filter,
              underline: const SizedBox(),
              items: ['All', 'Approved', 'Pending', 'Suspended'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _filter = v!),
            ),
          ]),
        ),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _RestaurantRow(r: filtered[i]),
        )),
      ]),
    );
  }
}

class _RestaurantRow extends StatelessWidget {
  final _Restaurant r;
  const _RestaurantRow({required this.r});
  @override
  Widget build(BuildContext context) {
    final color = r.status == 'approved' ? AppColors.success : r.status == 'pending' ? AppColors.warning : AppColors.error;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(r.name[0])),
        title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${r.location} · ${r.orders}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (r.rating != '—') Row(children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 2),
            Text(r.rating, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(r.status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ]),
        onTap: () => context.go('/restaurants/${r.id}'),
      ),
    );
  }
}

class _Restaurant {
  final String id, name, location, status, orders, rating;
  const _Restaurant(this.id, this.name, this.location, this.status, this.orders, this.rating);
}
