import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../l10n/app_l10n.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale    = ref.watch(localeModeProvider);
    final l10n      = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        children: [
          // ── Appearance ────────────────────────────────────────────────────
          _SectionHeader('Appearance'),
          _ThemeOption(
            label: 'Light',
            icon: Icons.light_mode_outlined,
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setTheme(v!),
          ),
          _ThemeOption(
            label: 'Dark',
            icon: Icons.dark_mode_outlined,
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setTheme(v!),
          ),
          _ThemeOption(
            label: 'System default',
            icon: Icons.brightness_auto_outlined,
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setTheme(v!),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Language ──────────────────────────────────────────────────────
          _SectionHeader('Language'),
          RadioListTile<String>(
            value: 'en',
            groupValue: locale.languageCode,
            onChanged: (v) =>
                ref.read(localeModeProvider.notifier).setLocale(v!),
            title: const Text('English'),
            secondary: const Text('🇬🇧', style: TextStyle(fontSize: 20)),
          ),
          RadioListTile<String>(
            value: 'ar',
            groupValue: locale.languageCode,
            onChanged: (v) =>
                ref.read(localeModeProvider.notifier).setLocale(v!),
            title: const Text('العربية'),
            secondary: const Text('🇸🇦', style: TextStyle(fontSize: 20)),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Notifications ─────────────────────────────────────────────────
          _SectionHeader('Notifications'),
          _SwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive all app notifications',
          ),
          _SwitchTile(
            icon: Icons.receipt_long_outlined,
            title: 'Order Updates',
            subtitle: 'Status changes for your orders',
          ),
          _SwitchTile(
            icon: Icons.local_offer_outlined,
            title: 'Promotions & Offers',
            subtitle: 'Deals, discounts and new restaurants',
            initialValue: false,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Privacy ───────────────────────────────────────────────────────
          _SectionHeader('Privacy'),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Location Access'),
            trailing: const Text('While using',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete Account',
                style: TextStyle(color: Colors.red)),
            onTap: () => _confirmDelete(context),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── About ─────────────────────────────────────────────────────────
          _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new, size: 16),
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'This is permanent. All your data, orders, and saved addresses will be deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Colors.grey,
          ),
        ),
      );
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode?> onChanged;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => RadioListTile<ThemeMode>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      );
}

class _SwitchTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool initialValue;

  const _SwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.initialValue = true,
  });

  @override
  State<_SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<_SwitchTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => SwitchListTile(
        secondary: Icon(widget.icon),
        title: Text(widget.title),
        subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
        value: _value,
        onChanged: (v) => setState(() => _value = v),
      );
}
