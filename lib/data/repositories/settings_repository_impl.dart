import 'package:flutter/material.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<AppSettings> loadSettings() async {
    final isDark = await _localDataSource.isDarkMode();
    final notificationsEnabled = await _localDataSource.isNotificationsEnabled();
    final smsFallbackEnabled = await _localDataSource.isSmsFallbackEnabled();
    return AppSettings(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      notificationsEnabled: notificationsEnabled,
      smsFallbackEnabled: smsFallbackEnabled,
    );
  }

  @override
  Future<void> setThemeMode(bool isDark) => _localDataSource.setDarkMode(isDark);

  @override
  Future<void> setNotificationsEnabled(bool enabled) =>
      _localDataSource.setNotificationsEnabled(enabled);

  @override
  Future<void> setSmsFallbackEnabled(bool enabled) =>
      _localDataSource.setSmsFallbackEnabled(enabled);
}
