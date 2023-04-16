import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl
  });

  factory User.fromFirebase(User firebaseUser) {
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoUrl ?? '',
    );
  }

  factory User.empty() {
    return User(
      uid: "",
      displayName: "",
      email: "",
      photoUrl: "",
    );
  }

  bool get isSignedIn => uid.isNotEmpty;
}
