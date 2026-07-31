import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const _themeModeKey = 'theme_mode_is_dark';
  static const _notificationsKey = 'notifications_enabled';
  static const _smsFallbackKey = 'sms_fallback_enabled';

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDark);
  }

  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<bool> isSmsFallbackEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_smsFallbackKey) ?? true;
  }

  Future<void> setSmsFallbackEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smsFallbackKey, enabled);
  }
}
