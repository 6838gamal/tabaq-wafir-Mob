import 'package:flutter/material.dart';

void main() => runApp(const CustomerApp());

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Customer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe85d04)),
        useMaterial3: true,
      ),
      home: const CustomerHomePage(),
    );
  }
}

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;
  bool _guestMode = true;

  static const _restaurants = [
    ('Burger District', 'Burgers · 25 min', '4.8', Icons.lunch_dining),
    ('Mina Kitchen', 'Arabic · 35 min', '4.7', Icons.restaurant),
    ('Green Bowl', 'Healthy · 20 min', '4.9', Icons.eco),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDiscover(context),
      const _SimplePage(title: 'Orders', icon: Icons.receipt_long, message: 'Track current and previous orders here.'),
      const _SimplePage(title: 'Favorites', icon: Icons.favorite_border, message: 'Your favorite restaurants will appear here.'),
      _buildProfile(context),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              child: Icon(_guestMode ? Icons.person_outline : Icons.person),
            ),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDiscover(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Good evening', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('What are you craving today?', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 18),
        SearchBar(
          hintText: 'Search restaurants or dishes',
          leading: const Icon(Icons.search),
          trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune))],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _CategoryChip(label: 'All', selected: true),
              _CategoryChip(label: 'Burgers'),
              _CategoryChip(label: 'Pizza'),
              _CategoryChip(label: 'Healthy'),
              _CategoryChip(label: 'Arabic'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListTile(
            leading: const Icon(Icons.local_offer_outlined, size: 32),
            title: const Text('Free delivery this week'),
            subtitle: const Text('Explore restaurants near you'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 24),
        Text('Popular near you', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (final restaurant in _restaurants)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(restaurant.$4),
              ),
              title: Text(restaurant.$1),
              subtitle: Text('${restaurant.$2}  ·  ★ ${restaurant.$3}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showMenu(context, restaurant.$1),
            ),
          ),
      ],
    );
  }

  Widget _buildProfile(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(radius: 36, child: Icon(Icons.person_outline, size: 36)),
        const SizedBox(height: 12),
        Center(child: Text(_guestMode ? 'Guest account' : 'Customer account', style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(height: 20),
        if (_guestMode)
          FilledButton.icon(
            onPressed: () => setState(() => _guestMode = false),
            icon: const Icon(Icons.login),
            label: const Text('Continue with Google'),
          ),
        const ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Saved addresses'), trailing: Icon(Icons.chevron_right)),
        const ListTile(leading: Icon(Icons.language), title: Text('Language'), trailing: Text('English')),
        const ListTile(leading: Icon(Icons.dark_mode_outlined), title: Text('Appearance'), trailing: Icon(Icons.chevron_right)),
      ],
    );
  }

  void _showMenu(BuildContext context, String restaurant) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            Text(restaurant, style: Theme.of(context).textTheme.headlineSmall),
            const ListTile(title: Text('Signature meal'), subtitle: Text('Add-ons and options available'), trailing: Text('24 SAR')),
            const ListTile(title: Text('Family combo'), subtitle: Text('Best seller'), trailing: Text('58 SAR')),
            FilledButton(onPressed: () => Navigator.pop(context), child: const Text('View cart')),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: FilterChip(label: Text(label), selected: selected, onSelected: (_) {}),
  );
}

class _SimplePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;
  const _SimplePage({required this.title, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
      const SizedBox(height: 16),
      Text(title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 8),
      Text(message),
    ]),
  );
}