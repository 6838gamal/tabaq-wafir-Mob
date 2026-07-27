import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _Section('Notifications', [
            SwitchListTile(title: const Text('Push Notifications'), subtitle: const Text('Receive all app notifications'), value: _pushNotifications, onChanged: (v) => setState(() => _pushNotifications = v)),
            SwitchListTile(title: const Text('Order Updates'), subtitle: const Text('Status changes for your orders'), value: _orderUpdates, onChanged: (v) => setState(() => _orderUpdates = v)),
            SwitchListTile(title: const Text('Promotions & Offers'), subtitle: const Text('Deals, discounts and new restaurants'), value: _promotions, onChanged: (v) => setState(() => _promotions = v)),
          ]),
          _Section('Appearance', [
            SwitchListTile(title: const Text('Dark Mode'), value: _darkMode, onChanged: (v) => setState(() => _darkMode = v)),
            ListTile(
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: _language,
                underline: const SizedBox(),
                items: ['English', 'العربية'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setState(() => _language = v!),
              ),
            ),
          ]),
          _Section('Privacy', [
            ListTile(title: const Text('Location Access'), trailing: const Text('While using', style: TextStyle(color: Colors.grey)), onTap: () {}),
            ListTile(title: const Text('Delete Account'), trailing: const Icon(Icons.chevron_right), onTap: _confirmDelete),
          ]),
          _Section('About', [
            const ListTile(title: Text('App Version'), trailing: Text('1.0.0', style: TextStyle(color: Colors.grey))),
            ListTile(title: const Text('Privacy Policy'), trailing: const Icon(Icons.open_in_new, size: 16), onTap: () {}),
            ListTile(title: const Text('Terms of Service'), trailing: const Icon(Icons.open_in_new, size: 16), onTap: () {}),
          ]),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Account'),
      content: const Text('This action is permanent. All your data, orders, and saved addresses will be deleted.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context), style: FilledButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete')),
      ],
    ));
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.fromLTRB(16, 20, 16, 4), child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1))),
    Card(margin: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: children)),
  ]);
}
