import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';
import '../../../core/constants/app_messages.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _currentUser = Supabase.instance.client.auth.currentUser;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    final result = await AuthRepository.login(email: email, contrasena: password);
    
    _setLoading(false);
    if (result.success) {
      _currentUser = Supabase.instance.client.auth.currentUser;
      return true;
    } else {
      _setError(result.message);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);

    final result = await AuthRepository.register(
      nombre: name,
      email: email,
      contrasena: password,
    );

    _setLoading(false);
    if (result.success) {
      _currentUser = Supabase.instance.client.auth.currentUser;
      return true;
    } else {
      _setError(result.message);
      return false;
    }
  }

  Future<void> logout() async {
    await AuthRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    final result = await AuthRepository.requestPasswordReset(email: email);
    _setLoading(false);
    if (!result.success) _setError(result.message);
    return result.success;
  }
}
