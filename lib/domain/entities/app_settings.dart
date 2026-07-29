import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool smsFallbackEnabled;

  const AppSettings({
    required this.themeMode,
    required this.notificationsEnabled,
    required this.smsFallbackEnabled,
  });

  static const defaults = AppSettings(
    themeMode: ThemeMode.light,
    notificationsEnabled: true,
    smsFallbackEnabled: true,
  );

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? smsFallbackEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      smsFallbackEnabled: smsFallbackEnabled ?? this.smsFallbackEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, notificationsEnabled, smsFallbackEnabled];
}
