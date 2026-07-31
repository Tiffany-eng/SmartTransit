import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String? email;
  final bool emailVerified;

  const AppUser({
    required this.uid,
    required this.email,
    required this.emailVerified,
  });

  @override
  List<Object?> get props => [uid, email, emailVerified];
}
