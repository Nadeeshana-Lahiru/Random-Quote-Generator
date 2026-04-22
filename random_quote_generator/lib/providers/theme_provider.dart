import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode_preference';
  static const String _langKey = 'language_preference';
  static const String _fontFamilyKey = 'font_family_preference';
  static const String _fontSizeKey = 'font_size_preference';
  static const String _ttsGenderKey = 'tts_gender_preference';
  static const String _onboardingKey = 'has_seen_onboarding';
  static const String _userNameKey = 'user_name_preference';
  
  String _themeMode = 'system'; // 'light', 'dark', 'system'
  String _languageCode = 'en';
  String _fontFamily = 'Outfit';
  double _fontSize = 24.0;
  String _ttsGender = 'female'; // 'female', 'male'
  bool _hasSeenOnboarding = false;
  String _userName = "Friend";
  bool _isInitialized = false;

  String get themeMode => _themeMode;
  String get languageCode => _languageCode;
  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;
  String get ttsGender => _ttsGender;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  String get userName => _userName;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Support migrating from old boolean if it exists
    final oldThemeBool = prefs.getBool('theme_preference');
    if (oldThemeBool != null && prefs.getString(_themeModeKey) == null) {
        _themeMode = oldThemeBool ? 'dark' : 'light';
        await prefs.remove('theme_preference'); // clean up ancient key
    } else {
        _themeMode = prefs.getString(_themeModeKey) ?? 'system';
    }

    _languageCode = prefs.getString(_langKey) ?? 'en';
    _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Outfit';
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 24.0;
    _ttsGender = prefs.getString(_ttsGenderKey) ?? 'female';
    
    _hasSeenOnboarding = prefs.getBool(_onboardingKey) ?? false;
    _userName = prefs.getString(_userNameKey) ?? "Friend";
    
    _isInitialized = true;
    notifyListeners();
  }

  void setThemeMode(String mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, _themeMode);
    }
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

  void setTtsGender(String gender) async {
    if (_ttsGender != gender) {
      _ttsGender = gender;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_ttsGenderKey, _ttsGender);
    }
  }

  void setHasSeenOnboarding(bool value) async {
    _hasSeenOnboarding = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, value);
  }

  void setUserName(String name) async {
    _userName = name;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }
}
