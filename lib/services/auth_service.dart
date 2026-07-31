import 'package:firebase_auth/firebase_auth.dart';
import 'transit_repository.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, TransitRepository? repository})
      : _auth = auth ?? FirebaseAuth.instance,
        _repository = repository ?? TransitRepository();
  final FirebaseAuth _auth;
  final TransitRepository _repository;

  Future<void> signIn(String email, String password) async => _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  Future<void> signUp({required String name, required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    await credential.user!.updateDisplayName(name.trim());
    await _repository.createProfile(displayName: name.trim(), email: email.trim());
  }
  Future<void> signOut() => _auth.signOut();
}
