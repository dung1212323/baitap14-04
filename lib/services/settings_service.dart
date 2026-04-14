import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/setting_snapshot.dart';

class SettingsService {
  static const String _soundKey = 'sound_enabled';
  static const String _autoSaveKey = 'auto_save_enabled';
  static const String _volumeKey = 'volume_level';
  static const String _highScoreKey = 'high_score';
  static const String _historyKey = 'settings_history';
  static const int _maxHistorySize = 10;

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      // Kiểm tra xem đã lưu dữ liệu gì trước đó chưa
      final savedScore = _prefs.getInt(_highScoreKey);
      print('[SettingsService] Initialized - Saved high score: $savedScore');
    } catch (e) {
      print('[SettingsService] Error initializing: $e');
      _initialized = false;
    }
  }

  bool isInitialized() => _initialized;

  // Getter
  bool getSoundEnabled() {
    try {
      return _prefs.getBool(_soundKey) ?? true;
    } catch (e) {
      print('[SettingsService] Error getting sound: $e');
      return true;
    }
  }

  bool getAutoSaveEnabled() {
    try {
      return _prefs.getBool(_autoSaveKey) ?? false;
    } catch (e) {
      print('[SettingsService] Error getting autoSave: $e');
      return false;
    }
  }

  double getVolume() {
    try {
      return _prefs.getDouble(_volumeKey) ?? 50;
    } catch (e) {
      print('[SettingsService] Error getting volume: $e');
      return 50;
    }
  }

  int getHighScore() {
    try {
      return _prefs.getInt(_highScoreKey) ?? 3500;
    } catch (e) {
      print('[SettingsService] Error getting high score: $e');
      return 3500;
    }
  }

  List<SettingSnapshot> getHistory() {
    try {
      final historyJson = _prefs.getStringList(_historyKey) ?? [];
      return historyJson
          .map((json) => SettingSnapshot.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('[SettingsService] Error getting history: $e');
      return [];
    }
  }

  // Setter với await để chắc chắn lưu thành công
  Future<void> setSoundEnabled(bool value) async {
    try {
      await _prefs.setBool(_soundKey, value);
      print('[SettingsService] Sound saved: $value');
    } catch (e) {
      print('[SettingsService] Error saving sound: $e');
    }
  }

  Future<void> setAutoSaveEnabled(bool value) async {
    try {
      await _prefs.setBool(_autoSaveKey, value);
      print('[SettingsService] Auto save saved: $value');
    } catch (e) {
      print('[SettingsService] Error saving autoSave: $e');
    }
  }

  Future<void> setVolume(double value) async {
    try {
      await _prefs.setDouble(_volumeKey, value);
      print('[SettingsService] Volume saved: $value');
    } catch (e) {
      print('[SettingsService] Error saving volume: $e');
    }
  }

  Future<void> setHighScore(int value) async {
    try {
      await _prefs.setInt(_highScoreKey, value);
      print('[SettingsService] High score saved: $value');
    } catch (e) {
      print('[SettingsService] Error saving high score: $e');
    }
  }

  Future<void> addSnapshot(SettingSnapshot snapshot) async {
    try {
      final currentHistory = _prefs.getStringList(_historyKey) ?? [];

      if (currentHistory.length >= _maxHistorySize) {
        currentHistory.removeAt(0);
      }

      currentHistory.add(jsonEncode(snapshot.toJson()));
      await _prefs.setStringList(_historyKey, currentHistory);
      print('[SettingsService] Snapshot added. Total: ${currentHistory.length}');
    } catch (e) {
      print('[SettingsService] Error adding snapshot: $e');
    }
  }

  Future<void> restoreSnapshot(SettingSnapshot snapshot) async {
    try {
      await setSoundEnabled(snapshot.soundEnabled);
      await setAutoSaveEnabled(snapshot.autoSaveEnabled);
      await setVolume(snapshot.volume);
      await setHighScore(snapshot.highScore);
      print('[SettingsService] Restored snapshot from ${snapshot.timestamp}');
    } catch (e) {
      print('[SettingsService] Error restoring snapshot: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      await _prefs.clear();
      print('[SettingsService] All data cleared');
    } catch (e) {
      print('[SettingsService] Error clearing data: $e');
    }
  }
}
