import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _offerNotifications = true;
  bool _paymentNotifications = true;
  bool _promotionNotifications = false;
  bool _locationSharing = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _Section('Notifications', [
            SwitchListTile(title: const Text('Delivery Offers'), subtitle: const Text('Get notified of new offers'), value: _offerNotifications, onChanged: (v) => setState(() => _offerNotifications = v)),
            SwitchListTile(title: const Text('Payments & Earnings'), value: _paymentNotifications, onChanged: (v) => setState(() => _paymentNotifications = v)),
            SwitchListTile(title: const Text('Promotions & Bonuses'), value: _promotionNotifications, onChanged: (v) => setState(() => _promotionNotifications = v)),
          ]),
          _Section('Privacy', [
            SwitchListTile(title: const Text('Location Sharing'), subtitle: const Text('Required during active delivery'), value: _locationSharing, onChanged: (v) => setState(() => _locationSharing = v)),
          ]),
          _Section('Preferences', [
            ListTile(
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: _language,
                underline: const SizedBox(),
                items: ['English', 'العربية'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setState(() => _language = v!),
              ),
            ),
            const ListTile(title: Text('App Version'), trailing: Text('1.0.0', style: TextStyle(color: Colors.grey))),
          ]),
          _Section('Account', [
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
              onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Delete Account'),
                content: const Text('This will permanently delete your driver account and all your data.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.pop(context), style: FilledButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete')),
                ],
              )),
            ),
          ]),
        ],
      ),
    );
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
