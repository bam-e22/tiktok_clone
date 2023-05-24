import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  PlaybackConfigRepository(this._preferences);

  static const String _autoplay = "autoplay";
  static const String _muted = "muted";
  static const String _looping = "looping";

  final SharedPreferences _preferences;

  Future<void> setMuted(bool value) async {
    await _preferences.setBool(_muted, value);
  }

  Future<void> setLooping(bool value) async {
    await _preferences.setBool(_looping, value);
  }

  Future<void> setAutoplay(bool value) async {
    await _preferences.setBool(_autoplay, value);
  }

  bool isMuted() {
    return _preferences.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    return _preferences.getBool(_autoplay) ?? true;
  }

  bool isLooping() {
    return _preferences.getBool(_looping) ?? false;
  }
}
