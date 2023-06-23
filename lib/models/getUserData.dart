import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  String uid;
  String? email;
  String? displayName;
  String? avatarUrl;
  String? username;
  String? firstName;
  String? lastName;
  String? docId;

  UserData({
    required this.uid,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.username,
    this.firstName,
    this.lastName,
    this.docId,
  });

  static UserData? _currentUser;

  static void setCurrentUser(UserData userData) {
    _currentUser = userData;
  }

  static UserData? getCurrentUser() {
    return _currentUser;
  }

   static Future<UserData?> getCurrentUserFromFireBase(UserData _currentUser) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    _currentUser.avatarUrl = user.photoURL;
  _currentUser.displayName = user.displayName;
_currentUser.email = user.email;


    // Đã đăng nhập, trả về thông tin người dùng hiện tại
    return _currentUser;
  } else {
    // Chưa đăng nhập
    return null;
  }
}

  factory UserData.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return UserData(
        uid: data['uid'],
        displayName: data['displayName'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        username: data['username'],
        email: data['email'],
        avatarUrl: data['avatarUrl'],
        docId: snapshot.id);
  }

  static empty() {
    
    var _currentUser = UserData(
        uid: '',
        username: null,
        firstName: null,
        lastName: null,
        email: null,
        avatarUrl: null,
        docId: null);
      return setCurrentUser(_currentUser);
  }
}
