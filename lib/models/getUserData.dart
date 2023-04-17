import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  UserData({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });
  
  factory UserData.fromFirebase(User? firebaseUser) {
    if (firebaseUser == null) {
      return UserData(uid: '');
    }
    return UserData(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  factory UserData.empty() {
    return UserData(
      uid: "",
      displayName: "",
      email: "",
      // photoUrl: "",
    );
  }

  bool get isSignedIn => uid.isNotEmpty;
}
