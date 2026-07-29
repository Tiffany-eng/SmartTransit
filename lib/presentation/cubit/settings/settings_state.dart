import 'package:equatable/equatable.dart';

import '../../../domain/entities/app_settings.dart';

class SettingsState extends Equatable {
  final AppSettings settings;
  final bool isLoading;

  const SettingsState({required this.settings, this.isLoading = false});

  factory SettingsState.initial() =>
      const SettingsState(settings: AppSettings.defaults, isLoading: true);

  SettingsState copyWith({AppSettings? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading];
}
