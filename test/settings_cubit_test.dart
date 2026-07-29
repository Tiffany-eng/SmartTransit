import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_transit_kigali/data/datasources/settings_local_data_source.dart';
import 'package:smart_transit_kigali/data/repositories/settings_repository_impl.dart';
import 'package:smart_transit_kigali/presentation/cubit/settings/settings_cubit.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('toggleSmsFallback flips state and persists across a fresh read', () async {
    final repository = SettingsRepositoryImpl(SettingsLocalDataSource());
    final cubit = SettingsCubit(repository);

    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.settings.smsFallbackEnabled, isTrue);

    await cubit.toggleSmsFallback();
    expect(cubit.state.settings.smsFallbackEnabled, isFalse);

    final freshRepository = SettingsRepositoryImpl(SettingsLocalDataSource());
    final restarted = await freshRepository.loadSettings();
    expect(restarted.smsFallbackEnabled, isFalse);

    await cubit.close();
  });

  test('toggleThemeMode persists dark mode across a fresh read', () async {
    final repository = SettingsRepositoryImpl(SettingsLocalDataSource());
    final cubit = SettingsCubit(repository);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.settings.themeMode, ThemeMode.light);
    await cubit.toggleThemeMode();
    expect(cubit.state.settings.themeMode, ThemeMode.dark);

    final freshRepository = SettingsRepositoryImpl(SettingsLocalDataSource());
    final restarted = await freshRepository.loadSettings();
    expect(restarted.themeMode, ThemeMode.dark);

    await cubit.close();
  });
}
