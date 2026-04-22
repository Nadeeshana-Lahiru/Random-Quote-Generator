import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_preference';
  static const String _langKey = 'language_preference';
  static const String _fontFamilyKey = 'font_family_preference';
  static const String _fontSizeKey = 'font_size_preference';
  
  bool _isDarkMode = false;
  String _languageCode = 'en';
  String _fontFamily = 'Outfit';
  double _fontSize = 24.0; // Base size for quote text
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;
  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    _languageCode = prefs.getString(_langKey) ?? 'en';
    _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Outfit';
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 24.0;
    
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

  void setFontFamily(String family) async {
    if (_fontFamily != family) {
      _fontFamily = family;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fontFamilyKey, _fontFamily);
    }
  }

  void setFontSize(double size) async {
    if (_fontSize != size) {
      _fontSize = size;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, _fontSize);
    }
  }
}
