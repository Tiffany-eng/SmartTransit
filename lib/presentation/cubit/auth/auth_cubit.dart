import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_user.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _authSubscription;

  AuthCubit(this._repository) : super(const AuthInitial()) {
    _authSubscription = _repository.authStateChanges.listen((user) {
      emit(user != null ? Authenticated(user) : const Unauthenticated());
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _repository.signInWithEmail(email: email, password: password);
    } catch (e) {
      emit(AuthError(_repository.getErrorMessage(e)));
    }
  }

  Future<void> register({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _repository.registerWithEmail(email: email, password: password);
      await _repository.sendEmailVerification();
    } catch (e) {
      emit(AuthError(_repository.getErrorMessage(e)));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());
    try {
      final signedIn = await _repository.signInWithGoogle();
      if (!signedIn) {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(_repository.getErrorMessage(e)));
    }
  }

  Future<void> signOut() => _repository.signOut();

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
      return null;
    } catch (e) {
      return _repository.getErrorMessage(e);
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
