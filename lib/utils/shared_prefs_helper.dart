/*
------------------------------------------------------------
Course Code: MAD201-01
Project: Smart Budget Tracker Lite
Student Name: Ishmeet Singh
Student ID: A00202436
Description: Helper for SharedPreferences to save/load
simple user settings like theme and currency.
------------------------------------------------------------
*/

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  static const String _keyIsDark = 'is_dark_theme';
  static const String _keyCurrency = 'selected_currency';

  /// Initialize SharedPreferences. Call this once before runApp
  static Future<void> initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get theme preference. Default to false (light theme)
  static bool getTheme() {
    return _prefs?.getBool(_keyIsDark) ?? false;
  }

  /// Save theme preference
  static Future<void> setTheme(bool value) async {
    await _prefs?.setBool(_keyIsDark, value);
  }

  /// Get selected currency. Default to CAD
  static String getCurrency() {
    return _prefs?.getString(_keyCurrency) ?? 'CAD';
  }

  /// Save selected currency
  static Future<void> setCurrency(String code) async {
    await _prefs?.setString(_keyCurrency, code);
  }
}
