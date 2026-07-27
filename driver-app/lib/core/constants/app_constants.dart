// lib/core/constants/app_constants.dart
class AppConstants {
  AppConstants._();

  static const String appName = 'Driver App';

  // Shared Preferences keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyDriverId = 'driver_id';
  static const String keyOnboardingComplete = 'onboarding_complete';

  // Location update interval
  static const Duration locationUpdateInterval = Duration(seconds: 5);

  // Order acceptance window
  static const Duration orderAcceptanceTimeout = Duration(seconds: 30);

  // Supported document types
  static const List<String> documentTypes = [
    'driving_license',
    'vehicle_registration',
    'insurance',
    'profile_photo',
  ];

  // Order statuses
  static const String orderStatusPending = 'pending';
  static const String orderStatusAccepted = 'accepted';
  static const String orderStatusPickedUp = 'picked_up';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusRejected = 'rejected';
  static const String orderStatusCancelled = 'cancelled';

  // Driver statuses
  static const String driverStatusOnline = 'online';
  static const String driverStatusOffline = 'offline';
  static const String driverStatusBusy = 'busy';

  // Verification statuses
  static const String verificationPending = 'pending';
  static const String verificationApproved = 'approved';
  static const String verificationRejected = 'rejected';

  // Earning types
  static const String earningTypeDelivery = 'delivery';
  static const String earningTypeTip = 'tip';
  static const String earningTypeBonus = 'bonus';

  // Payment methods
  static const String paymentOnline = 'online';
  static const String paymentCod = 'cod';
}
