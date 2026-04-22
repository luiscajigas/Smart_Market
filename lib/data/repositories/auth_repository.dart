import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_messages.dart';

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  AuthResult({required this.success, required this.message, this.data});
}

class AuthRepository {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<AuthResult> register({
    required String nombre,
    required String email,
    required String contrasena,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: contrasena,
        data: {'full_name': nombre},
      );

      if (response.user != null) {
        // Optionally insert into public profiles table
        try {
          await _client.from('profiles').upsert({
            'id': response.user!.id,
            'full_name': nombre,
            'email': email,
            'updated_at': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          // If profile fails, user was still created in Auth
        }

        return AuthResult(
          success: true,
          message: AppMessages.registerSuccess,
          data: {'user': response.user?.toJson()},
        );
      }
      return AuthResult(success: false, message: AppMessages.registerError);
    } on AuthException catch (e) {
      if (e.message.contains('already registered') || e.message.contains('already exists')) {
        return AuthResult(success: false, message: AppMessages.emailAlreadyRegistered);
      }
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: AppMessages.unexpectedError);
    }
  }

  static Future<AuthResult> login({
    required String email,
    required String contrasena,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: contrasena,
      );

      if (response.user != null) {
        return AuthResult(
          success: true,
          message: AppMessages.loginSuccess,
          data: {'user': response.user?.toJson()},
        );
      }
      return AuthResult(success: false, message: AppMessages.loginError);
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: AppMessages.unexpectedError);
    }
  }

  static Future<AuthResult> requestPasswordReset(
      {required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return AuthResult(
          success: true, message: AppMessages.passwordResetSent);
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: AppMessages.unexpectedError);
    }
  }

  static Future<AuthResult> verifyResetCode({
    required String email,
    required String codigo,
  }) async {
    try {
      final response = await _client.auth.verifyOTP(
        email: email,
        token: codigo,
        type: OtpType.recovery,
      );

      if (response.session != null) {
        return AuthResult(
          success: true,
          message: AppMessages.codeVerified,
          data: {'session': response.session},
        );
      }
      return AuthResult(success: false, message: AppMessages.invalidCode);
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: AppMessages.unexpectedError);
    }
  }

  static Future<AuthResult> updatePassword({
    required String nuevaContrasena,
  }) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: nuevaContrasena),
      );
      return AuthResult(success: true, message: AppMessages.passwordUpdated);
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: AppMessages.unexpectedError);
    }
  }

  static Future<bool> isLoggedIn() async {
    return _client.auth.currentSession != null;
  }

  static Future<void> logout() async {
    await _client.auth.signOut();
  }

  static Future<String?> getToken() async {
    return _client.auth.currentSession?.accessToken;
  }
}
