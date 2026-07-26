import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeModeProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          // Profile section
          _SectionHeader(l10n.settingsProfile),
          _ProfileCard(
            name: user?.name ?? '—',
            email: user?.email ?? '—',
            role: user?.role.displayName ?? '—',
            photoUrl: user?.photoUrl,
            onTap: () => context.push(AppRoutes.profile),
          ),

          // Restaurant
          _SectionHeader(l10n.settingsRestaurantInfo),
          _SettingsTile(
            icon: Icons.restaurant_outlined,
            title: l10n.settingsRestaurantInfo,
            subtitle: 'Configure your restaurant details',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.store_outlined,
            title: l10n.settingsBranches,
            onTap: () => context.push(AppRoutes.branches),
          ),

          // Appearance
          _SectionHeader(l10n.settingsTheme),
          _ThemeSelector(current: themeMode, ref: ref),

          // Language
          _SectionHeader(l10n.settingsLanguage),
          _LanguageSelector(current: locale.languageCode, ref: ref),

          // Notifications & Security
          _SectionHeader('${l10n.settingsNotifications} & ${l10n.settingsSecurity}'),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: l10n.settingsNotifications,
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
          ),
          _SettingsTile(
            icon: Icons.security_outlined,
            title: l10n.settingsSecurity,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.settingsPrivacy,
            onTap: () {},
          ),

          // Logs
          _SectionHeader('Logs'),
          _SettingsTile(
            icon: Icons.history_outlined,
            title: l10n.settingsActivityLog,
            onTap: () => context.push(AppRoutes.activityLog),
          ),
          _SettingsTile(
            icon: Icons.manage_search_outlined,
            title: l10n.settingsAuditLog,
            onTap: () => context.push(AppRoutes.auditLogs),
          ),

          // Support
          _SectionHeader(l10n.settingsSupport),
          _SettingsTile(
            icon: Icons.help_outline,
            title: l10n.settingsSupport,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: l10n.settingsAbout,
            subtitle: '${l10n.settingsVersion} ${AppConstants.appVersion}',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(l10n.settingsLogout,
                  style: const TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _confirmSignOut(context, ref, l10n),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsLogout),
        content: Text(l10n.settingsLogoutConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.commonCancel)),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(l10n.settingsLogout)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) context.go(AppRoutes.login);
    }
  }
}

// ─── Subwidgets ──────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String? photoUrl;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                ? NetworkImage(photoUrl!)
                : null,
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  )
                : null,
          ),
          title: Text(name,
              style:
                  theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(email, style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(role,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Icon(icon, size: 22, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(fontSize: 12))
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right, size: 18)
              : null),
      onTap: onTap,
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode current;
  final WidgetRef ref;
  const _ThemeSelector({required this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (ThemeMode.light,  l10n.settingsLightMode,  Icons.light_mode_outlined),
      (ThemeMode.dark,   l10n.settingsDarkMode,   Icons.dark_mode_outlined),
      (ThemeMode.system, l10n.settingsSystemMode,  Icons.brightness_auto_outlined),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: options.map((opt) {
          final (mode, label, icon) = opt;
          final isSelected = current == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(themeModeProvider.notifier).setTheme(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(icon,
                        size: 22,
                        color: isSelected ? Colors.white : AppColors.primary),
                    const SizedBox(height: 4),
                    Text(label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String current;
  final WidgetRef ref;
  const _LanguageSelector({required this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final langs = [
      ('en', l10n.settingsEnglish, '🇬🇧'),
      ('ar', l10n.settingsArabic,  '🇸🇦'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: langs.map((lang) {
          final (code, label, flag) = lang;
          final isSelected = current == code;
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(localeModeProvider.notifier).setLocale(code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(label,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isSelected ? Colors.white : AppColors.primary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
