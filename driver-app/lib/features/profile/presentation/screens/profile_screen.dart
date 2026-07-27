import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';

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
              const CircleAvatar(radius: 52, child: Icon(Icons.person, size: 52)),
              Positioned(right: 0, bottom: 0, child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              )),
            ]),
            const SizedBox(height: 12),
            const Text('Faris Al-Otaibi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 4),
            const Text('+966 50 987 6543', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.verified, color: AppColors.success, size: 16),
                SizedBox(width: 4),
                Text('Verified Driver', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: const [
              Icon(Icons.star, color: Colors.amber, size: 16),
              SizedBox(width: 4),
              Text('4.9 rating · 192 deliveries', style: TextStyle(color: Colors.grey)),
            ]),
          ])),
          const SizedBox(height: 24),

          // Vehicle info
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              const _InfoRow(Icons.directions_car_outlined, 'Vehicle', 'Honda Civic 2022'),
              const _InfoRow(Icons.pin_outlined, 'License Plate', 'RUH-4521'),
              const _InfoRow(Icons.color_lens_outlined, 'Color', 'White'),
            ]),
          )),
          const SizedBox(height: 12),

          // Documents
          Card(child: Column(children: [
            const ListTile(
              leading: Icon(Icons.badge_outlined),
              title: Text('Identity Documents'),
              trailing: Icon(Icons.check_circle, color: AppColors.success),
              subtitle: Text('All documents verified'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.settings),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: const Text('Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.support),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () => context.go(RouteNames.login),
            ),
          ])),
          const SizedBox(height: 20),
          const Center(child: Text('Version 1.0.0 · Driver App', style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Icon(icon, size: 20, color: AppColors.textSecondary),
      const SizedBox(width: 10),
      Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]),
  );
}
