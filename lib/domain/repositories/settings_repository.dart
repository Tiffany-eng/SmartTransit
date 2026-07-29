import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> loadSettings();

  Future<void> setThemeMode(bool isDark);

  Future<void> setNotificationsEnabled(bool enabled);

  Future<void> setSmsFallbackEnabled(bool enabled);
}
