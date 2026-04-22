import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/local_database.dart';
import '../../core/constants/app_messages.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'es';
  bool _isDarkMode = true;
  double _monthlyBudget = 1500000;

  String get language => _language;
  bool get isDarkMode => _isDarkMode;
  double get monthlyBudget => _monthlyBudget;

  SettingsProvider() {
    AppMessages.currentLanguage = _language;
    _loadSettings();
  }

  Future<String?> _getSetting(String key) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(key);
      }
      return LocalDatabase.instance.getSetting(key);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveSetting(String key, String value) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, value);
        return;
      }
      await LocalDatabase.instance.saveSetting(key, value);
    } catch (_) {}
  }

  Future<void> _loadSettings() async {
    final lang = await _getSetting('language');
    final dark = await _getSetting('dark_mode');
    final budget = await _getSetting('monthly_budget');

    if (lang != null) {
      _language = lang;
      AppMessages.currentLanguage = lang;
    } else {
      AppMessages.currentLanguage = _language;
    }
    if (dark != null) _isDarkMode = dark == 'true';
    if (budget != null) _monthlyBudget = double.tryParse(budget) ?? 1500000;

    notifyListeners();
  }

  Future<void> setMonthlyBudget(double value) async {
    _monthlyBudget = value;
    notifyListeners();
    await _saveSetting('monthly_budget', value.toString());
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    AppMessages.currentLanguage = lang;
    await _saveSetting('language', lang);
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    await _saveSetting('dark_mode', value.toString());
  }
}
