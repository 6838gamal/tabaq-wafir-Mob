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
    Locale('ar'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Driver Hub'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Deliver with confidence'**
  String get tagline;

  /// No description provided for @navDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Deliveries'**
  String get navDeliveries;

  /// No description provided for @navEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get navEarnings;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get navSupport;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

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

  /// No description provided for @authVerifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify Identity'**
  String get authVerifyIdentity;

  /// No description provided for @authUploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get authUploadDocuments;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver Hub'**
  String get homeTitle;

  /// No description provided for @homeOnline.
  ///
  /// In en, this message translates to:
  /// **'You are online'**
  String get homeOnline;

  /// No description provided for @homeOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get homeOffline;

  /// No description provided for @homeWaitingOffers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for delivery offers'**
  String get homeWaitingOffers;

  /// No description provided for @homeGoOnline.
  ///
  /// In en, this message translates to:
  /// **'Go Online'**
  String get homeGoOnline;

  /// No description provided for @homeGoOffline.
  ///
  /// In en, this message translates to:
  /// **'Go Offline'**
  String get homeGoOffline;

  /// No description provided for @homeDeliveryOffer.
  ///
  /// In en, this message translates to:
  /// **'Delivery Offer'**
  String get homeDeliveryOffer;

  /// No description provided for @homeAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get homeAccept;

  /// No description provided for @homeDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get homeDecline;

  /// No description provided for @homePickupIn.
  ///
  /// In en, this message translates to:
  /// **'Pickup in'**
  String get homePickupIn;

  /// No description provided for @homeLiveMap.
  ///
  /// In en, this message translates to:
  /// **'Live Map'**
  String get homeLiveMap;

  /// No description provided for @homeIdentityStatus.
  ///
  /// In en, this message translates to:
  /// **'Identity Status'**
  String get homeIdentityStatus;

  /// No description provided for @homeVerifiedDriver.
  ///
  /// In en, this message translates to:
  /// **'Verified Driver'**
  String get homeVerifiedDriver;

  /// No description provided for @earningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earningsTitle;

  /// No description provided for @earningsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get earningsToday;

  /// No description provided for @earningsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get earningsThisWeek;

  /// No description provided for @earningsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get earningsThisMonth;

  /// No description provided for @earningsTotalDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Total Deliveries'**
  String get earningsTotalDeliveries;

  /// No description provided for @earningsAvgPerDelivery.
  ///
  /// In en, this message translates to:
  /// **'Avg. per Delivery'**
  String get earningsAvgPerDelivery;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No deliveries yet'**
  String get historyEmpty;

  /// No description provided for @historyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get historyCompleted;

  /// No description provided for @historyCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get historyCancelled;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @supportContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get supportContactUs;

  /// No description provided for @supportFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get supportFaq;

  /// No description provided for @supportOpenTicket.
  ///
  /// In en, this message translates to:
  /// **'Open a Ticket'**
  String get supportOpenTicket;

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

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

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

  /// No description provided for @commonSar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get commonSar;

  /// No description provided for @commonKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get commonKm;

  /// No description provided for @commonMin.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get commonMin;
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
    'that was used.',
  );
}
