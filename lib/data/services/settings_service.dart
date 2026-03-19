import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 设置服务 - 保存用户偏好
class SettingsService {
  static const String _key = 'app_settings';
  static SettingsService? _instance;
  static SharedPreferences? _prefs;

  SettingsService._();

  static Future<SettingsService> getInstance() async {
    _instance ??= SettingsService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// 获取设置
  Map<String, dynamic> getSettings() {
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) {
      return {'darkMode': false};
    }
    try {
      return json.decode(jsonStr);
    } catch (e) {
      return {'darkMode': false};
    }
  }

  /// 保存设置
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final jsonStr = json.encode(settings);
    await _prefs?.setString(_key, jsonStr);
  }

  /// 获取深色模式
  bool getDarkMode() {
    return getSettings()['darkMode'] ?? false;
  }

  /// 设置深色模式
  Future<void> setDarkMode(bool value) async {
    final settings = getSettings();
    settings['darkMode'] = value;
    await saveSettings(settings);
  }
}
