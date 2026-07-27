// lib/core/constants/app_constants.dart
class AppConstants {
  AppConstants._();

  // Layout
  static const double sidebarWidth = 260.0;
  static const double sidebarCollapsedWidth = 72.0;
  static const double appBarHeight = 64.0;
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;

  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;

  // Animation
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'current_user';
  static const String themeKey = 'app_theme';

  // Status labels
  static const Map<String, String> restaurantStatuses = {
    'pending': 'Pending',
    'approved': 'Approved',
    'suspended': 'Suspended',
    'rejected': 'Rejected',
  };

  static const Map<String, String> driverStatuses = {
    'pending': 'Pending',
    'approved': 'Approved',
    'suspended': 'Suspended',
    'offline': 'Offline',
    'online': 'Online',
  };

  static const Map<String, String> subscriptionStatuses = {
    'active': 'Active',
    'cancelled': 'Cancelled',
    'expired': 'Expired',
    'trial': 'Trial',
  };
}
