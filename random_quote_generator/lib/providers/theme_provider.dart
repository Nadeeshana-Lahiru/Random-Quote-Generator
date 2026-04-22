import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_preference';
  static const String _langKey = 'language_preference';
  
  bool _isDarkMode = false;
  String _languageCode = 'en';
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    _languageCode = prefs.getString(_langKey) ?? 'en';
    
    _isInitialized = true;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }

  void setLanguage(String code) async {
    if (_languageCode != code) {
      _languageCode = code;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_langKey, _languageCode);
    }
  }
}
