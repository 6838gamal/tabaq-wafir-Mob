import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          _buildProfileCard(context, isDark),
          const SizedBox(height: 20),

          _sectionLabel('Preferences', isDark),
          _settingTile(context, Icons.language_outlined, 'settings.language'.tr(), _langSub(context), AppColors.kpiBlue, isDark, onTap: () => _showLanguageSheet(context, ref)),
          _settingTile(context, Icons.palette_outlined, 'settings.theme'.tr(), _themeSub(themeMode), AppColors.kpiPurple, isDark, onTap: () => _showThemeSheet(context, ref, themeMode)),
          _settingTile(context, Icons.notifications_outlined, 'settings.notifications'.tr(), 'Push, Local, In-App', AppColors.kpiOrange, isDark, onTap: () {}),

          const SizedBox(height: 16),
          _sectionLabel('Security', isDark),
          _settingTile(context, Icons.fingerprint, 'settings.biometric'.tr(), 'Enabled', AppColors.success, isDark, onTap: () {}),
          _settingTile(context, Icons.lock_outline, 'settings.change_password'.tr(), null, AppColors.kpiBlue, isDark, onTap: () {}),
          _settingTile(context, Icons.timer_outlined, 'settings.session_timeout'.tr(), '30 minutes', AppColors.warning, isDark, onTap: () {}),

          const SizedBox(height: 16),
          _sectionLabel('Business', isDark),
          _settingTile(context, Icons.store_outlined, 'settings.branches'.tr(), '2 branches', AppColors.kpiGreen, isDark, onTap: () {}),
          _settingTile(context, Icons.person_outline, 'settings.profile'.tr(), null, AppColors.kpiBlue, isDark, onTap: () => context.go(AppRoutes.profile)),

          const SizedBox(height: 16),
          _sectionLabel('Logs & Support', isDark),
          _settingTile(context, Icons.history, 'settings.activity_log'.tr(), null, AppColors.kpiTeal, isDark, onTap: () => context.go(AppRoutes.activityLog)),
          _settingTile(context, Icons.manage_search_outlined, 'settings.audit_log'.tr(), null, AppColors.kpiPurple, isDark, onTap: () {}),
          _settingTile(context, Icons.help_outline, 'settings.help'.tr(), null, AppColors.info, isDark, onTap: () {}),
          _settingTile(context, Icons.chat_outlined, 'settings.whatsapp'.tr(), 'Chat support', AppColors.success, isDark, onTap: () {}),

          const SizedBox(height: 16),
          _sectionLabel('App', isDark),
          _settingTile(context, Icons.info_outline, 'settings.about'.tr(), 'Version 1.0.0', AppColors.textSecondaryLight, isDark, onTap: () {}),

          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.login),
            icon: const Icon(Icons.logout, size: 18, color: AppColors.error),
            label: Text('settings.logout'.tr(), style: const TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          alignment: Alignment.center,
          child: const Text('A', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Ahmed Al-Rashidi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('roles.owner', style: TextStyle(color: Colors.white70, fontSize: 13)).tr(),
          const SizedBox(height: 2),
          const Text('admin@restaurant.com', style: TextStyle(color: Colors.white60, fontSize: 12)),
        ])),
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white70),
          onPressed: () => context.go(AppRoutes.profile),
        ),
      ]),
    );
  }

  Widget _sectionLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(label.toUpperCase(), style: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      )),
    );
  }

  Widget _settingTile(BuildContext context, IconData icon, String title, String? subtitle, Color iconColor, bool isDark, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: Icon(Icons.chevron_right, size: 18, color: isDark ? AppColors.iconDark : AppColors.iconLight),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      ),
    );
  }

  String _langSub(BuildContext context) => context.locale.languageCode == 'ar' ? 'العربية' : 'English';

  String _themeSub(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark: return 'Dark';
      case ThemeMode.light: return 'Light';
      default: return 'System';
    }
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(context: context, builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('settings.language'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
        const SizedBox(height: 16),
        ListTile(title: const Text('English'), leading: const Icon(Icons.language), onTap: () { context.setLocale(const Locale('en')); Navigator.pop(ctx); }),
        ListTile(title: const Text('العربية'), leading: const Icon(Icons.language), onTap: () { context.setLocale(const Locale('ar')); Navigator.pop(ctx); }),
      ]),
    ));
  }

  void _showThemeSheet(BuildContext context, WidgetRef ref, ThemeMode current) {
    showModalBottomSheet(context: context, builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('settings.theme'.tr(), style: Theme.of(ctx).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...ThemeMode.values.map((m) => ListTile(
          title: Text(m.name[0].toUpperCase() + m.name.substring(1)),
          leading: Icon(m == ThemeMode.dark ? Icons.dark_mode_outlined : m == ThemeMode.light ? Icons.light_mode_outlined : Icons.brightness_auto_outlined),
          trailing: m == current ? const Icon(Icons.check, color: AppColors.primary) : null,
          onTap: () { ref.read(themeModeProvider.notifier).setTheme(m); Navigator.pop(ctx); },
        )),
      ]),
    ));
  }
}
