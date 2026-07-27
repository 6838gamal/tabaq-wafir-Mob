import 'package:flutter/material.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// BuildContext extension — use `context.l10n.key` in widgets.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

// ─────────────────────────────────────────────────────────────────────────────
// Static shim for code that cannot access BuildContext (e.g. providers).
// Updated by [LocaleNotifier] whenever the user changes language.
// ─────────────────────────────────────────────────────────────────────────────
class AppTranslations {
  AppTranslations._();

  static String _locale = 'en';

  static void setLocale(String languageCode) {
    _locale = languageCode;
  }

  static String tr(String key) {
    final map = _locale == 'ar' ? _ar : _en;
    return map[key] ?? key;
  }

  static const Map<String, String> _en = {
    'app_name': 'Platform Admin',
    'tagline': 'Restaurant Ecosystem Control',
    'nav.overview': 'Overview',
    'nav.restaurants': 'Restaurants',
    'nav.users': 'Users & Drivers',
    'nav.payments': 'Payments',
    'nav.complaints': 'Complaints',
    'nav.analytics': 'Analytics',
    'nav.audit_logs': 'Audit Logs',
    'settings.logout': 'Sign Out',
    'common.cancel': 'Cancel',
  };

  static const Map<String, String> _ar = {
    'app_name': 'لوحة تحكم المنصة',
    'tagline': 'إدارة منظومة المطاعم',
    'nav.overview': 'نظرة عامة',
    'nav.restaurants': 'المطاعم',
    'nav.users': 'المستخدمون والسائقون',
    'nav.payments': 'المدفوعات',
    'nav.complaints': 'الشكاوى',
    'nav.analytics': 'التحليلات',
    'nav.audit_logs': 'سجل المراجعة',
    'settings.logout': 'تسجيل الخروج',
    'common.cancel': 'إلغاء',
  };
}
