import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider extends ChangeNotifier {
  static const String _ambienceKey = 'ambience_enabled_preference';
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAmbienceEnabled = false;
  bool _isPlaying = false;

  bool get isAmbienceEnabled => _isAmbienceEnabled;
  bool get isPlaying => _isPlaying;

  AudioProvider() {
    _initAudio();
  }

  Future<void> _initAudio() async {
    final prefs = await SharedPreferences.getInstance();
    _isAmbienceEnabled = prefs.getBool(_ambienceKey) ?? false;
    
    // Set to endless loop natively via AudioPlayer engine
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // Lower volume safely for ambient background mixing
    await _audioPlayer.setVolume(0.3);

    if (_isAmbienceEnabled) {
      _startAmbience();
    }
  }

  Future<void> _startAmbience() async {
    try {
      // Reliable Google Actions open sound library: Rain falling
      await _audioPlayer.play(UrlSource('https://actions.google.com/sounds/v1/water/rain_on_roof.ogg'));
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint("Ambience Loading Error: $e");
    }
  }

  Future<void> _stopAmbience() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> toggleAmbience(bool value) async {
    if (_isAmbienceEnabled != value) {
      _isAmbienceEnabled = value;
      notifyListeners();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_ambienceKey, value);

      if (_isAmbienceEnabled) {
        _startAmbience();
      } else {
        _stopAmbience();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
