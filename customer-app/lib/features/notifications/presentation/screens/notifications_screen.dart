import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifs = [
    _Notif('Order on its way!', 'Your driver Faris picked up your order.', Icons.delivery_dining, AppColors.primary, '2 min ago', false),
    _Notif('Order accepted', 'Burger District accepted your order.', Icons.check_circle_outline, AppColors.success, '10 min ago', false),
    _Notif('Offer: Free delivery', 'Get free delivery on orders above 50 SAR today!', Icons.local_offer_outlined, Colors.orange, 'Yesterday', true),
    _Notif('Order delivered', 'Your order from Mina Kitchen was delivered.', Icons.task_alt, AppColors.success, '2 days ago', true),
    _Notif('Rate your order', 'How was your experience with Green Bowl?', Icons.star_border, Colors.amber, '3 days ago', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(onPressed: () => setState(() { for (final n in _notifs) n.read = true; }), child: const Text('Mark all read')),
        ],
      ),
      body: _notifs.isEmpty
          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.notifications_none, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text('No notifications yet', style: TextStyle(color: Colors.grey)),
            ]))
          : ListView.separated(
              itemCount: _notifs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => _NotifTile(
                notif: _notifs[i],
                onTap: () => setState(() => _notifs[i].read = true),
              ),
            ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final _Notif notif;
  final VoidCallback onTap;
  const _NotifTile({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notif.read ? null : AppColors.primary.withOpacity(0.04),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            backgroundColor: notif.color.withOpacity(0.12),
            child: Icon(notif.icon, color: notif.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(notif.title, style: TextStyle(fontWeight: notif.read ? FontWeight.normal : FontWeight.bold)),
            const SizedBox(height: 2),
            Text(notif.body, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 4),
            Text(notif.time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ])),
          if (!notif.read) Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
        ]),
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
