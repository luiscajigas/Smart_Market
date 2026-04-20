import 'package:flutter/material.dart';
import '../datasources/local_database.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'es';
  bool _isDarkMode = true;

  String get language => _language;
  bool get isDarkMode => _isDarkMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final lang = await LocalDatabase.instance.getSetting('language');
    final dark = await LocalDatabase.instance.getSetting('dark_mode');

    if (lang != null) _language = lang;
    if (dark != null) _isDarkMode = dark == 'true';
    
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await LocalDatabase.instance.saveSetting('language', lang);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await LocalDatabase.instance.saveSetting('dark_mode', value.toString());
    notifyListeners();
  }
}
