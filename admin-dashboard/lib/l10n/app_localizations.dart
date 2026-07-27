import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Platform Admin'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Ecosystem Control'**
  String get tagline;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get navRestaurants;

  /// No description provided for @navUsers.
  ///
  /// In en, this message translates to:
  /// **'Users & Drivers'**
  String get navUsers;

  /// No description provided for @navPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// No description provided for @navComplaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get navComplaints;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get navAuditLogs;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get authSignOut;

  /// No description provided for @authSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authSignInWithGoogle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get authSessionExpired;

  /// No description provided for @authAdminOnly.
  ///
  /// In en, this message translates to:
  /// **'Admin access only'**
  String get authAdminOnly;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform Overview'**
  String get dashboardTitle;

  /// No description provided for @dashboardActiveRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Active Restaurants'**
  String get dashboardActiveRestaurants;

  /// No description provided for @dashboardMonthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get dashboardMonthlyRevenue;

  /// No description provided for @dashboardActiveDrivers.
  ///
  /// In en, this message translates to:
  /// **'Active Drivers'**
  String get dashboardActiveDrivers;

  /// No description provided for @dashboardOpenComplaints.
  ///
  /// In en, this message translates to:
  /// **'Open Complaints'**
  String get dashboardOpenComplaints;

  /// No description provided for @dashboardOrdersToday.
  ///
  /// In en, this message translates to:
  /// **'Orders Today'**
  String get dashboardOrdersToday;

  /// No description provided for @dashboardAiAlerts.
  ///
  /// In en, this message translates to:
  /// **'AI Alerts'**
  String get dashboardAiAlerts;

  /// No description provided for @restaurantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurantsTitle;

  /// No description provided for @restaurantsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get restaurantsPending;

  /// No description provided for @restaurantsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get restaurantsActive;

  /// No description provided for @restaurantsSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get restaurantsSuspended;

  /// No description provided for @restaurantsApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get restaurantsApprove;

  /// No description provided for @restaurantsReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get restaurantsReject;

  /// No description provided for @restaurantsSuspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get restaurantsSuspend;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users & Drivers'**
  String get usersTitle;

  /// No description provided for @usersDrivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get usersDrivers;

  /// No description provided for @usersCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get usersCustomers;

  /// No description provided for @usersAdmins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get usersAdmins;

  /// No description provided for @paymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsTitle;

  /// No description provided for @paymentsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentsPending;

  /// No description provided for @paymentsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get paymentsCompleted;

  /// No description provided for @paymentsRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get paymentsRefunds;

  /// No description provided for @complaintsTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaintsTitle;

  /// No description provided for @complaintsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get complaintsOpen;

  /// No description provided for @complaintsResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get complaintsResolved;

  /// No description provided for @complaintsEscalated.
  ///
  /// In en, this message translates to:
  /// **'Escalated'**
  String get complaintsEscalated;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsRevenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get analyticsRevenueTrend;

  /// No description provided for @analyticsTopRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Top Restaurants'**
  String get analyticsTopRestaurants;

  /// No description provided for @analyticsOrderVolume.
  ///
  /// In en, this message translates to:
  /// **'Order Volume'**
  String get analyticsOrderVolume;

  /// No description provided for @auditLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get auditLogsTitle;

  /// No description provided for @auditLogsFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter Logs'**
  String get auditLogsFilter;

  /// No description provided for @auditLogsExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get auditLogsExport;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsLightMode;

  /// No description provided for @settingsSystemMode.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsSystemMode;

  /// No description provided for @settingsArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get settingsArabic;

  /// No description provided for @settingsEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsChooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get settingsChooseTheme;

  /// No description provided for @settingsChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get settingsChooseLanguage;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get commonFilter;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get commonNoData;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @commonSar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get commonSar;

  /// No description provided for @commonApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get commonApprove;

  /// No description provided for @commonReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get commonReject;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
