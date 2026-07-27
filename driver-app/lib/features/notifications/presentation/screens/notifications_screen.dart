import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifs = [
    _Notif('New delivery offer!', 'Burger District → Al Malqa · 32 SAR · 4.2 km', Icons.delivery_dining, AppColors.primary, '2 min ago', false),
    _Notif('Payment received', '184 SAR added to your wallet.', Icons.account_balance_wallet_outlined, AppColors.success, '1 hour ago', false),
    _Notif('New review', 'Ahmed rated you 5 stars: "Very fast!"', Icons.star_outline, Colors.amber, 'Yesterday', true),
    _Notif('Bonus earned!', 'Weekend peak bonus: 50 SAR added.', Icons.celebration_outlined, Colors.purple, 'Yesterday', true),
    _Notif('Account verified', 'Your documents have been approved.', Icons.verified_outlined, AppColors.success, '3 days ago', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => setState(() { for (final n in _notifs) n.read = true; }),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _notifs.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => InkWell(
          onTap: () => setState(() => _notifs[i].read = true),
          child: Container(
            color: _notifs[i].read ? null : AppColors.primary.withOpacity(0.04),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                backgroundColor: _notifs[i].color.withOpacity(0.12),
                child: Icon(_notifs[i].icon, color: _notifs[i].color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_notifs[i].title, style: TextStyle(fontWeight: _notifs[i].read ? FontWeight.normal : FontWeight.bold)),
                const SizedBox(height: 2),
                Text(_notifs[i].body, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(_notifs[i].time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ])),
              if (!_notifs[i].read) Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6), decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Notif {
  final String title, body, time;
  final IconData icon;
  final Color color;
  bool read;
  _Notif(this.title, this.body, this.icon, this.color, this.time, this.read);
}
