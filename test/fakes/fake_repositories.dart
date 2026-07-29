import 'package:smart_transit_kigali/domain/entities/app_settings.dart';
import 'package:smart_transit_kigali/domain/entities/app_user.dart';
import 'package:smart_transit_kigali/domain/repositories/auth_repository.dart';
import 'package:smart_transit_kigali/domain/repositories/settings_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final AppUser? initialUser;
  FakeAuthRepository({this.initialUser});

  @override
  Stream<AppUser?> get authStateChanges => Stream.value(initialUser);

  @override
  AppUser? get currentUser => initialUser;

  @override
  bool get isEmailVerified => initialUser?.emailVerified ?? false;

  @override
  Future<void> registerWithEmail({required String email, required String password}) async {}

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {}

  @override
  Future<bool> signInWithGoogle() async => false;

  @override
  Future<void> signOut() async {}

  @override
  String getErrorMessage(Object error) => 'error';
}

class FakeSettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> loadSettings() async => AppSettings.defaults;

  @override
  Future<void> setThemeMode(bool isDark) async {}

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {}

  @override
  Future<void> setSmsFallbackEnabled(bool enabled) async {}
}
