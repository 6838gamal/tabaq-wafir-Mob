import 'package:flutter/material.dart';

void main() => runApp(const DriverApp());

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1565c0)),
        useMaterial3: true,
      ),
      home: const DriverHomePage(),
    );
  }
}

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool _online = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [_buildHome(context), const _DriverPage(title: 'Earnings', icon: Icons.account_balance_wallet_outlined, text: 'Today: 184 SAR · This week: 1,260 SAR'), const _DriverPage(title: 'History', icon: Icons.history, text: 'Completed deliveries appear here.'), const _DriverPage(title: 'Support', icon: Icons.support_agent, text: 'Chat with delivery support.')];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Hub'),
        actions: [
          Switch(value: _online, onChanged: (value) => setState(() => _online = value)),
          const Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.circle, size: 12, color: Colors.green)),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.delivery_dining), label: 'Deliveries'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Earnings'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.support_agent), label: 'Support'),
        ],
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(children: [
              CircleAvatar(radius: 28, child: Icon(_online ? Icons.wifi : Icons.wifi_off)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_online ? 'You are online' : 'You are offline', style: Theme.of(context).textTheme.titleMedium),
                Text(_online ? 'Waiting for delivery offers' : 'Go online to receive orders'),
              ])),
              if (!_online) FilledButton(onPressed: () => setState(() => _online = true), child: const Text('Go online')),
            ]),
          ),
        ),
        const SizedBox(height: 22),
        Text('Delivery offer', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.store_outlined), SizedBox(width: 8), Text('Mina Kitchen → Al Olaya')]),
              const SizedBox(height: 12),
              const Text('Pickup in 8 min · 4.2 km · 32 SAR', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Decline'))),
                const SizedBox(width: 10),
                Expanded(child: FilledButton(onPressed: _online ? () => _accept(context) : null, child: const Text('Accept'))),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        const ListTile(leading: Icon(Icons.map_outlined), title: Text('Live map'), subtitle: Text('Location sharing is enabled during active delivery'), trailing: Icon(Icons.chevron_right)),
        const ListTile(leading: Icon(Icons.verified_user_outlined), title: Text('Identity status'), subtitle: Text('Verified driver'), trailing: Icon(Icons.check_circle, color: Colors.green)),
      ],
    );
  }

  void _accept(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery accepted. Navigation is ready.')));
  }
}

class _DriverPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;
  const _DriverPage({required this.title, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 16), Text(title, style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8), Text(text)]));
}