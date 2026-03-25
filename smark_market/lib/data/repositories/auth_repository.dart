import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';

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
        // Opcionalmente, insertar en una tabla de perfiles pública
        try {
          await _client.from('profiles').upsert({
            'id': response.user!.id,
            'full_name': nombre,
            'email': email,
            'updated_at': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          // Si falla el perfil, igual el usuario se creó en Auth
          print('Error al crear perfil: $e');
        }

        return AuthResult(
          success: true,
          message: 'Registro exitoso.',
          data: {'user': response.user?.toJson()},
        );
      }
      return AuthResult(success: false, message: 'Error en el registro');
    } on AuthException catch (e) {
      if (e.message.contains('already registered') || e.message.contains('already exists')) {
        return AuthResult(success: false, message: 'Este correo ya está registrado. Intenta iniciar sesión.');
      }
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: 'Ocurrió un error inesperado');
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
          message: 'Inicio de sesión exitoso',
          data: {'user': response.user?.toJson()},
        );
      }
      return AuthResult(success: false, message: 'Error al iniciar sesión');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: 'Ocurrió un error inesperado');
    }
  }

  static Future<AuthResult> requestPasswordReset(
      {required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return AuthResult(
          success: true, message: 'Se envió un correo de recuperación');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: 'Ocurrió un error inesperado');
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
          message: 'Código verificado correctamente',
          data: {'session': response.session},
        );
      }
      return AuthResult(success: false, message: 'Código inválido o expirado');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: 'Ocurrió un error inesperado');
    }
  }

  static Future<AuthResult> updatePassword({
    required String nuevaContrasena,
  }) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: nuevaContrasena),
      );
      return AuthResult(success: true, message: 'Contraseña actualizada');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      return AuthResult(success: false, message: 'Ocurrió un error inesperado');
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
