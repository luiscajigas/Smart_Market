import 'package:flutter/material.dart';
import '../datasources/local_database.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'es';
  bool _isDarkMode = true;
  double _monthlyBudget = 1500000; // Presupuesto mensual por defecto (ej. 1.5M COP)

  String get language => _language;
  bool get isDarkMode => _isDarkMode;
  double get monthlyBudget => _monthlyBudget;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final lang = await LocalDatabase.instance.getSetting('language');
    final dark = await LocalDatabase.instance.getSetting('dark_mode');
    final budget = await LocalDatabase.instance.getSetting('monthly_budget');

    if (lang != null) _language = lang;
    if (dark != null) _isDarkMode = dark == 'true';
    if (budget != null) _monthlyBudget = double.tryParse(budget) ?? 1500000;
    
    notifyListeners();
  }

  Future<void> setMonthlyBudget(double value) async {
    _monthlyBudget = value;
    await LocalDatabase.instance.saveSetting('monthly_budget', value.toString());
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
