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
  /// **'Restaurant Copilot'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Operating Intelligence'**
  String get tagline;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navCopilot.
  ///
  /// In en, this message translates to:
  /// **'Copilot'**
  String get navCopilot;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navEmployees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get navEmployees;

  /// No description provided for @navAccounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get navAccounting;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get navCustomers;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get navAiAssistant;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @navBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get navBranches;

  /// No description provided for @navSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get navSuppliers;

  /// No description provided for @navPurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get navPurchases;

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

  /// No description provided for @navTodaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get navTodaysTasks;

  /// No description provided for @navAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get navAttendance;

  /// No description provided for @navPos.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get navPos;

  /// No description provided for @navRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get navRefunds;

  /// No description provided for @navTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get navTransfers;

  /// No description provided for @navExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get navExpiry;

  /// No description provided for @navExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navExpenses;

  /// No description provided for @navInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get navInvoices;

  /// No description provided for @navPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get navPayments;

  /// No description provided for @navProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get navProfit;

  /// No description provided for @navTables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get navTables;

  /// No description provided for @navKitchenOrders.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Orders'**
  String get navKitchenOrders;

  /// No description provided for @navReadyOrders.
  ///
  /// In en, this message translates to:
  /// **'Ready Orders'**
  String get navReadyOrders;

  /// No description provided for @navInventoryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Inventory Alerts'**
  String get navInventoryAlerts;

  /// No description provided for @navWaste.
  ///
  /// In en, this message translates to:
  /// **'Waste'**
  String get navWaste;

  /// No description provided for @navStockCount.
  ///
  /// In en, this message translates to:
  /// **'Stock Count'**
  String get navStockCount;

  /// No description provided for @navKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get navKitchen;

  /// No description provided for @navReservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get navReservations;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your restaurant'**
  String get authSignInSubtitle;

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

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authSignInWithGoogle;

  /// No description provided for @authContinueAsDemo.
  ///
  /// In en, this message translates to:
  /// **'Continue as Demo'**
  String get authContinueAsDemo;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get authSignOut;

  /// No description provided for @authSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get authSessionExpired;

  /// No description provided for @authSessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get authSessionExpiredTitle;

  /// No description provided for @authSessionExpiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again to continue.'**
  String get authSessionExpiredSubtitle;

  /// No description provided for @authSignInAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign In Again'**
  String get authSignInAgain;

  /// No description provided for @authUnauthorizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get authUnauthorizedTitle;

  /// No description provided for @authUnauthorizedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this page.'**
  String get authUnauthorizedSubtitle;

  /// No description provided for @authGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get authGoBack;

  /// No description provided for @authGoogleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed. Please try again.'**
  String get authGoogleSignInFailed;

  /// No description provided for @authDemoModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Demo Mode — Select Role'**
  String get authDemoModeLabel;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get dashboardGoodMorning;

  /// No description provided for @dashboardGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get dashboardGoodAfternoon;

  /// No description provided for @dashboardGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get dashboardGoodEvening;

  /// No description provided for @dashboardTodaySales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get dashboardTodaySales;

  /// No description provided for @dashboardTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get dashboardTotalOrders;

  /// No description provided for @dashboardAvgOrder.
  ///
  /// In en, this message translates to:
  /// **'Avg. Order Value'**
  String get dashboardAvgOrder;

  /// No description provided for @dashboardActiveTables.
  ///
  /// In en, this message translates to:
  /// **'Active Tables'**
  String get dashboardActiveTables;

  /// No description provided for @dashboardPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get dashboardPendingOrders;

  /// No description provided for @dashboardLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Items'**
  String get dashboardLowStock;

  /// No description provided for @dashboardStaffOnDuty.
  ///
  /// In en, this message translates to:
  /// **'Staff on Duty'**
  String get dashboardStaffOnDuty;

  /// No description provided for @dashboardRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashboardRevenue;

  /// No description provided for @dashboardExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get dashboardExpenses;

  /// No description provided for @dashboardProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get dashboardProfit;

  /// No description provided for @dashboardVsYesterday.
  ///
  /// In en, this message translates to:
  /// **'vs yesterday'**
  String get dashboardVsYesterday;

  /// No description provided for @dashboardVsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'vs last week'**
  String get dashboardVsLastWeek;

  /// No description provided for @dashboardSalesOverview.
  ///
  /// In en, this message translates to:
  /// **'Sales Overview'**
  String get dashboardSalesOverview;

  /// No description provided for @dashboardTopItems.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Items'**
  String get dashboardTopItems;

  /// No description provided for @dashboardRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get dashboardRecentOrders;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @copilotTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Copilot'**
  String get copilotTitle;

  /// No description provided for @copilotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered operations intelligence'**
  String get copilotSubtitle;

  /// No description provided for @copilotTopActions.
  ///
  /// In en, this message translates to:
  /// **'Top 10 Actions Today'**
  String get copilotTopActions;

  /// No description provided for @copilotKeyRisks.
  ///
  /// In en, this message translates to:
  /// **'Key Risks'**
  String get copilotKeyRisks;

  /// No description provided for @copilotLowStockItems.
  ///
  /// In en, this message translates to:
  /// **'Items Near Depletion'**
  String get copilotLowStockItems;

  /// No description provided for @copilotAiSuggestions.
  ///
  /// In en, this message translates to:
  /// **'AI Suggestions'**
  String get copilotAiSuggestions;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts Center'**
  String get alertsTitle;

  /// No description provided for @alertsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get alertsMarkAllRead;

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTitle;

  /// No description provided for @inventoryProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get inventoryProducts;

  /// No description provided for @inventoryStockCount.
  ///
  /// In en, this message translates to:
  /// **'Stock Count'**
  String get inventoryStockCount;

  /// No description provided for @inventoryWaste.
  ///
  /// In en, this message translates to:
  /// **'Waste Management'**
  String get inventoryWaste;

  /// No description provided for @inventoryPurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get inventoryPurchases;

  /// No description provided for @inventoryLogWaste.
  ///
  /// In en, this message translates to:
  /// **'Log Waste'**
  String get inventoryLogWaste;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @ordersNew.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get ordersNew;

  /// No description provided for @ordersKitchenScreen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Screen'**
  String get ordersKitchenScreen;

  /// No description provided for @kitchenTitle.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Display'**
  String get kitchenTitle;

  /// No description provided for @kitchenMarkReady.
  ///
  /// In en, this message translates to:
  /// **'Mark Ready'**
  String get kitchenMarkReady;

  /// No description provided for @kitchenStartCooking.
  ///
  /// In en, this message translates to:
  /// **'Start Cooking'**
  String get kitchenStartCooking;

  /// No description provided for @reservationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get reservationsTitle;

  /// No description provided for @reservationsAdd.
  ///
  /// In en, this message translates to:
  /// **'New Reservation'**
  String get reservationsAdd;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @employeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employeesTitle;

  /// No description provided for @accountingTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get accountingTitle;

  /// No description provided for @accountingTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get accountingTotalRevenue;

  /// No description provided for @accountingTotalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get accountingTotalExpenses;

  /// No description provided for @accountingNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get accountingNetProfit;

  /// No description provided for @accountingAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get accountingAddExpense;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get reportsTitle;

  /// No description provided for @reportsExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get reportsExportPdf;

  /// No description provided for @reportsExportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get reportsExportExcel;

  /// No description provided for @reportsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get reportsRevenue;

  /// No description provided for @reportsTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get reportsTotalOrders;

  /// No description provided for @reportsSalesReport.
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get reportsSalesReport;

  /// No description provided for @reportsTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top Products'**
  String get reportsTopProducts;

  /// No description provided for @reportsPeakHours.
  ///
  /// In en, this message translates to:
  /// **'Peak Hours'**
  String get reportsPeakHours;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistantTitle;

  /// No description provided for @aiAssistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything about your restaurant'**
  String get aiAssistantSubtitle;

  /// No description provided for @aiAssistantPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ask a question...'**
  String get aiAssistantPlaceholder;

  /// No description provided for @aiAssistantThinking.
  ///
  /// In en, this message translates to:
  /// **'Analyzing data...'**
  String get aiAssistantThinking;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfile;

  /// No description provided for @settingsRestaurantInfo.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Information'**
  String get settingsRestaurantInfo;

  /// No description provided for @settingsBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get settingsBranches;

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

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

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

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

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

  /// No description provided for @settingsActivityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get settingsActivityLog;

  /// No description provided for @settingsAuditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get settingsAuditLog;

  /// No description provided for @settingsCurrentRole.
  ///
  /// In en, this message translates to:
  /// **'Current Role'**
  String get settingsCurrentRole;

  /// No description provided for @settingsCurrentBranch.
  ///
  /// In en, this message translates to:
  /// **'Current Branch'**
  String get settingsCurrentBranch;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get settingsLogoutConfirm;

  /// No description provided for @rolesOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get rolesOwner;

  /// No description provided for @rolesGeneralManager.
  ///
  /// In en, this message translates to:
  /// **'General Manager'**
  String get rolesGeneralManager;

  /// No description provided for @rolesBranchManager.
  ///
  /// In en, this message translates to:
  /// **'Branch Manager'**
  String get rolesBranchManager;

  /// No description provided for @rolesSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get rolesSupervisor;

  /// No description provided for @rolesCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get rolesCashier;

  /// No description provided for @rolesKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get rolesKitchen;

  /// No description provided for @rolesWaiter.
  ///
  /// In en, this message translates to:
  /// **'Waiter'**
  String get rolesWaiter;

  /// No description provided for @rolesInventoryManager.
  ///
  /// In en, this message translates to:
  /// **'Inventory Manager'**
  String get rolesInventoryManager;

  /// No description provided for @rolesAccountant.
  ///
  /// In en, this message translates to:
  /// **'Accountant'**
  String get rolesAccountant;

  /// No description provided for @branchAllBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get branchAllBranches;

  /// No description provided for @branchSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get branchSelect;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @comingSoonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This feature is under development'**
  String get comingSoonSubtitle;

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

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

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

  /// No description provided for @commonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonSar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get commonSar;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get commonThisWeek;

  /// No description provided for @commonThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get commonThisMonth;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get commonInactive;

  /// No description provided for @commonRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get commonRequiredField;

  /// No description provided for @commonConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get commonConfirmDelete;

  /// No description provided for @errorsNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorsNetwork;

  /// No description provided for @errorsServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again'**
  String get errorsServer;

  /// No description provided for @errorsUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get errorsUnauthorized;

  /// No description provided for @errorsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errorsNotFound;

  /// No description provided for @errorsTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get errorsTimeout;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get profileRole;

  /// No description provided for @profileBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get profileBranches;

  /// No description provided for @profileLastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get profileLastLogin;

  /// No description provided for @profileStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get profileStatus;

  /// No description provided for @profilePermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get profilePermissions;
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
