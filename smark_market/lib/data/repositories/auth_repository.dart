import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/api_service.dart';
import '../../core/constants/app_constants.dart';

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  AuthResult({required this.success, required this.message, this.data});
}

class AuthRepository {
  static const _storage = FlutterSecureStorage();

  static Future<AuthResult> register({
    required String nombre,
    required String email,
    required String contrasena,
  }) async {
    final response = await ApiService.post(
      endpoint: AppConstants.registerEndpoint,
      body: {'nombre': nombre, 'email': email, 'contrasena': contrasena},
    );
    if (response.success && response.data != null) {
      final token = response.data!['token'] as String?;
      if (token != null) {
        await _storage.write(key: AppConstants.tokenKey, value: token);
      }
    }
    return AuthResult(
      success: response.success,
      message: response.message,
      data: response.data,
    );
  }

  static Future<AuthResult> login({
    required String email,
    required String contrasena,
  }) async {
    final response = await ApiService.post(
      endpoint: AppConstants.loginEndpoint,
      body: {'email': email, 'contrasena': contrasena},
    );
    if (response.success && response.data != null) {
      final token = response.data!['token'] as String?;
      if (token != null) {
        await _storage.write(key: AppConstants.tokenKey, value: token);
      }
    }
    return AuthResult(
      success: response.success,
      message: response.message,
      data: response.data,
    );
  }

  static Future<AuthResult> requestPasswordReset({required String email}) async {
    final response = await ApiService.post(
      endpoint: AppConstants.passwordResetRequestEndpoint,
      body: {'email': email},
    );
    return AuthResult(success: response.success, message: response.message);
  }

  static Future<AuthResult> verifyResetCode({
    required String email,
    required String codigo,
  }) async {
    final response = await ApiService.post(
      endpoint: AppConstants.passwordResetVerifyEndpoint,
      body: {'email': email, 'codigo': codigo},
    );
    return AuthResult(
      success: response.success,
      message: response.message,
      data: response.data,
    );
  }

  static Future<AuthResult> changePassword({
    required String nuevaContrasena,
    required String resetToken,
  }) async {
    final response = await ApiService.post(
      endpoint: AppConstants.passwordResetChangeEndpoint,
      body: {'nuevaContrasena': nuevaContrasena, 'resetToken': resetToken},
    );
    return AuthResult(success: response.success, message: response.message);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  static Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}