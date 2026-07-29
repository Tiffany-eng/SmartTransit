/// Build-time settings that keep the UI usable before a Firebase project has
/// been connected to this source tree.
class AppRuntime {
  const AppRuntime._();

  /// Enable only after adding the platform Firebase configuration files.
  ///
  /// Example: `flutter run --dart-define=ENABLE_FIREBASE=true`
  static const firebaseEnabled = bool.fromEnvironment(
    'ENABLE_FIREBASE',
    defaultValue: false,
  );

  static bool firebaseAvailable = false;
}
