class ApiConstants {
  ApiConstants._();

  // Auth
  static const String signIn = '/auth/sign-in';
  static const String signInGuest = '/auth/guest';
  static const String signOut = '/auth/sign-out';

  // Home
  static const String banners = '/home/banners';
  static const String categories = '/home/categories';
  static const String bestSellers = '/home/best-sellers';
  static const String offers = '/home/offers';

  // Discovery
  static const String restaurants = '/restaurants';
  static const String nearbyRestaurants = '/restaurants/nearby';
  static const String searchRestaurants = '/restaurants/search';

  // Restaurant
  static const String restaurantMenu = '/restaurants/{id}/menu';

  // Cart / Orders
  static const String placeOrder = '/orders';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/{id}';
  static const String trackOrder = '/orders/{id}/track';
  static const String reorder = '/orders/{id}/reorder';
  static const String applyCoupon = '/coupons/apply';

  // Maps / Addresses
  static const String addresses = '/addresses';
  static const String reverseGeocode = '/maps/reverse-geocode';
  static const String searchAddress = '/maps/search';

  // Chat
  static const String chatMessages = '/chats/{id}/messages';
  static const String sendMessage = '/chats/{id}/messages';

  // Favorites
  static const String favorites = '/favorites';

  // Reviews
  static const String submitReview = '/reviews';

  // Notifications
  static const String notifications = '/notifications';

  // Profile
  static const String profile = '/profile';
}
