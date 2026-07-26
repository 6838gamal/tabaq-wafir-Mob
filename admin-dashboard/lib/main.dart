import 'package:flutter/material.dart';

void main() => runApp(const AdminDashboard());

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff263238)),
        useMaterial3: true,
      ),
      home: const AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selected = 0;
  final _items = const [
    ('Overview', Icons.dashboard_outlined),
    ('Restaurants', Icons.store_outlined),
    ('Users & drivers', Icons.people_outline),
    ('Payments', Icons.payments_outlined),
    ('Complaints', Icons.support_outlined),
    ('Analytics', Icons.analytics_outlined),
    ('Audit logs', Icons.history),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _items[_selected];
    return Scaffold(
      appBar: AppBar(
        title: Text(selected.$1),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: CircleAvatar(child: Text('PO'))),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _selected,
        onDestinationSelected: (index) {
          setState(() => _selected = index);
          Navigator.pop(context);
        },
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(28, 24, 20, 16), child: Text('Platform Control', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.fromLTRB(28, 0, 20, 16), child: Text('Owner workspace', style: TextStyle(color: Colors.grey))),
          for (final item in _items) NavigationDrawerDestination(icon: Icon(item.$2), label: Text(item.$1)),
        ],
      ),
      body: _buildContent(context, selected.$1),
    );
  }

  Widget _buildContent(BuildContext context, String title) {
    if (title != 'Overview') {
      return _AdminListPage(title: title, icon: _items[_selected].$2);
    }
    return LayoutBuilder(
      builder: (context, constraints) => GridView.count(
        padding: const EdgeInsets.all(28),
        crossAxisCount: constraints.maxWidth > 1000 ? 4 : constraints.maxWidth > 620 ? 2 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.7,
        children: const [
          _MetricCard(label: 'Active restaurants', value: '248', trend: '+12 this month', icon: Icons.store_outlined),
          _MetricCard(label: 'Monthly revenue', value: '184,620 SAR', trend: '+8.4%', icon: Icons.trending_up),
          _MetricCard(label: 'Active drivers', value: '1,426', trend: '+5.1%', icon: Icons.delivery_dining),
          _MetricCard(label: 'Open complaints', value: '18', trend: '-12.5%', icon: Icons.support_outlined),
          _MetricCard(label: 'Orders today', value: '12,840', trend: '+14.2%', icon: Icons.receipt_long_outlined),
          _MetricCard(label: 'AI alerts', value: '7', trend: 'Needs review', icon: Icons.auto_awesome_outlined),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  const _MetricCard({required this.label, required this.value, required this.trend, required this.icon});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Icon(icon, color: Theme.of(context).colorScheme.primary)]),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(trend, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ]),
    ),
  );
}

class _AdminListPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const _AdminListPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(28),
    children: [
      Row(children: [Icon(icon, size: 30), const SizedBox(width: 12), Text(title, style: Theme.of(context).textTheme.headlineSmall)]),
      const SizedBox(height: 22),
      SearchBar(hintText: 'Search $title', leading: const Icon(Icons.search), trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune))]),
      const SizedBox(height: 16),
      for (final name in ['North Region', 'Central Region', 'West Region'])
        Card(child: ListTile(title: Text('$title · $name'), subtitle: const Text('Updated a few minutes ago'), trailing: const Icon(Icons.chevron_right))),
    ],
  );
}