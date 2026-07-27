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
    'app_name': 'Tabaq Wafir',
    'tagline': 'Order food you love',
    'nav.home': 'Discover',
    'nav.orders': 'Orders',
    'nav.favorites': 'Favorites',
    'nav.profile': 'Profile',
    'settings.logout': 'Sign Out',
    'common.cancel': 'Cancel',
  };

  static const Map<String, String> _ar = {
    'app_name': 'طابق وافر',
    'tagline': 'اطلب طعامك المفضل',
    'nav.home': 'اكتشف',
    'nav.orders': 'الطلبات',
    'nav.favorites': 'المفضلة',
    'nav.profile': 'ملفي',
    'settings.logout': 'تسجيل الخروج',
    'common.cancel': 'إلغاء',
  };
}
