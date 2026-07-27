import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_customer_app/core/router/route_names.dart';
import 'package:restaurant_customer_app/core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + name
          Center(child: Column(children: [
            Stack(children: [
              const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
              Positioned(right: 0, bottom: 0, child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
              )),
            ]),
            const SizedBox(height: 12),
            const Text('Ahmed Al-Rashidi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 4),
            const Text('ahmed@example.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: () => context.push(RouteNames.editProfile), child: const Text('Edit Profile')),
          ])),
          const SizedBox(height: 24),

          // Stats
          Row(children: [
            _StatCard('Total Orders', '24'),
            const SizedBox(width: 10),
            _StatCard('Saved Addresses', '2'),
            const SizedBox(width: 10),
            _StatCard('Wallet', '85 SAR'),
          ]),
          const SizedBox(height: 20),

          // Menu items
          Card(child: Column(children: [
            _MenuItem(Icons.receipt_long_outlined, 'Order History', () => context.push(RouteNames.orders)),
            _Divider(),
            _MenuItem(Icons.favorite_border, 'Favorites', () {}),
            _Divider(),
            _MenuItem(Icons.location_on_outlined, 'Saved Addresses', () => context.push(RouteNames.addresses)),
            _Divider(),
            _MenuItem(Icons.notifications_outlined, 'Notifications', () => context.push(RouteNames.notifications)),
            _Divider(),
            _MenuItem(Icons.settings_outlined, 'Settings', () => context.push(RouteNames.settings)),
          ])),
          const SizedBox(height: 12),
          Card(child: Column(children: [
            _MenuItem(Icons.support_agent_outlined, 'Help & Support', () {}),
            _Divider(),
            _MenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
            _Divider(),
            _MenuItem(Icons.description_outlined, 'Terms of Service', () {}),
          ])),
          const SizedBox(height: 12),
          Card(child: _MenuItem(Icons.logout, 'Sign Out', () {}, color: Colors.red)),
          const SizedBox(height: 20),
          const Center(child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  const _StatCard(this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center),
      ]),
    )),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _MenuItem(this.icon, this.label, this.onTap, {this.color});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: color ?? AppColors.textSecondary),
    title: Text(label, style: TextStyle(color: color)),
    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    onTap: onTap,
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(height: 1, indent: 56);
}
