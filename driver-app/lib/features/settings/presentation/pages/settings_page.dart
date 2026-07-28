import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../l10n/app_l10n.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

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
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

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
