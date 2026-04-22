// Application state constants
class AppStates {
  // Loading states
  static const String loading = 'loading';
  static const String idle = 'idle';
  static const String loaded = 'loaded';

  // Error states
  static const String error = 'error';
  static const String errorUserNotFound = 'User not authenticated';
  static const String errorLoadingHistory = 'Error loading history';
  static const String errorRegisteringPurchase = 'Error recording purchase';
  static const String errorLoadingFavorites = 'Error loading favorites';

  // Success states
  static const String purchaseRecorded = 'Purchase recorded successfully';
  static const String favoriteToggled = 'Favorite toggled';

  // Empty states
  static const String noHistoryFound = 'No recent searches';
  static const String noFavoritesFound = 'No favorite products';
  static const String noResultsFound = 'No results found';

  // Source types
  static const String sourceSearch = 'search';
  static const String sourcePurchase = 'purchase';
}
