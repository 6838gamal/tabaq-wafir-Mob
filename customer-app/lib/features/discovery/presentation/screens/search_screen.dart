import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  static const _recent = ['Shawarma', 'Burger', 'Pizza', 'Sushi'];
  static const _trending = ['Keto bowl', 'Crispy chicken', 'Margherita', 'Kabsa'];

  static const _results = [
    ('Crispy Chicken Burger', 'Burger District', '32 SAR', Icons.lunch_dining),
    ('Classic Shawarma', 'Mina Kitchen', '18 SAR', Icons.restaurant),
    ('Acai Bowl', 'Green Bowl', '42 SAR', Icons.eco),
    ('Pepperoni Pizza', 'Pizza Palace', '55 SAR', Icons.local_pizza),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search restaurants or dishes',
            border: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(onPressed: () { _controller.clear(); setState(() => _query = ''); }, icon: const Icon(Icons.clear))
                : null,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        ],
      ),
      body: _query.isEmpty ? _buildSuggestions() : _buildResults(),
    );
  }

  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildChipSection('Recent Searches', _recent, Icons.history),
        const SizedBox(height: 20),
        _buildChipSection('Trending', _trending, Icons.trending_up),
      ],
    );
  }

  Widget _buildChipSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((s) => ActionChip(
            label: Text(s),
            onPressed: () { _controller.text = s; setState(() => _query = s); },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final filtered = _results.where((r) => r.$1.toLowerCase().contains(_query.toLowerCase()) || r.$2.toLowerCase().contains(_query.toLowerCase())).toList();
    if (filtered.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.search_off, size: 64, color: Colors.grey),
        const SizedBox(height: 12),
        Text('No results for "$_query"', style: const TextStyle(color: Colors.grey)),
      ]));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final r = filtered[i];
        return ListTile(
          leading: CircleAvatar(child: Icon(r.$4)),
          title: Text(r.$1),
          subtitle: Text(r.$2),
          trailing: Text(r.$3, style: const TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {},
        );
      },
    );
  }
}
