class AppConstants {
  // Android emulator usa 10.0.2.2, iOS simulator usa localhost
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String passwordResetRequestEndpoint = '/auth/password-reset/request';
  static const String passwordResetVerifyEndpoint = '/auth/password-reset/verify';
  static const String passwordResetChangeEndpoint = '/auth/password-reset/change';
  static const String profileEndpoint = '/auth/profile';

  static const String tokenKey = 'auth_token';
  static const String appName = 'Smart Market';
}