import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  AppUser? _toAppUser(fb.User? user) {
    if (user == null) return null;
    return AppUser(
        uid: user.uid, email: user.email, emailVerified: user.emailVerified);
  }

  @override
  Stream<AppUser?> get authStateChanges =>
      _remoteDataSource.authStateChanges.map(_toAppUser);

  @override
  AppUser? get currentUser => _toAppUser(_remoteDataSource.currentUser);

  @override
  bool get isEmailVerified => _remoteDataSource.isEmailVerified;

  @override
  Future<void> registerWithEmail(
      {required String email, required String password}) {
    return _remoteDataSource.registerWithEmail(
        email: email, password: password);
  }

  @override
  Future<void> signInWithEmail(
      {required String email, required String password}) {
    return _remoteDataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<bool> signInWithGoogle() async {
    final result = await _remoteDataSource.signInWithGoogle();
    return result != null;
  }

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _remoteDataSource.sendPasswordResetEmail(email);

  @override
  Future<void> sendEmailVerification() =>
      _remoteDataSource.sendEmailVerification();

  @override
  String getErrorMessage(Object error) {
    if (error is fb.FirebaseAuthException) {
      return _remoteDataSource.getErrorMessage(error);
    }
    return 'Something went wrong. Please try again.';
  }
}
