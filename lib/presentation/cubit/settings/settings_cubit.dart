import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(SettingsState.initial()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.loadSettings();
    emit(state.copyWith(settings: settings, isLoading: false));
  }

  Future<void> toggleThemeMode() async {
    final isDark = state.settings.themeMode != ThemeMode.dark;
    await _repository.setThemeMode(isDark);
    emit(state.copyWith(
      settings: state.settings.copyWith(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      ),
    ));
  }

  Future<void> toggleNotifications() async {
    final enabled = !state.settings.notificationsEnabled;
    await _repository.setNotificationsEnabled(enabled);
    emit(state.copyWith(
      settings: state.settings.copyWith(notificationsEnabled: enabled),
    ));
  }

  Future<void> toggleSmsFallback() async {
    final enabled = !state.settings.smsFallbackEnabled;
    await _repository.setSmsFallbackEnabled(enabled);
    emit(state.copyWith(
      settings: state.settings.copyWith(smsFallbackEnabled: enabled),
    ));
  }
}
