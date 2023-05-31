import 'package:cloud_firestore/cloud_firestore.dart';

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

  // static UserData? _currentUser;

  // static void setCurrentUser(UserData userData) {
  //   _currentUser = userData;
  // }

  // static UserData? getCurrentUser() {
  //   return _currentUser;
  // }

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
      docId: snapshot.id,
    );
  }

  static UserData empty() {
    return UserData(
        uid: '',
        username: '',
        firstName: '',
        lastName: '',
        email: '',
        avatarUrl: '',
        docId: '');
  }

  UserData copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? username,
    String? firstName,
    String? lastName,
    String? docId,
  }) =>
      UserData(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        username: username ?? this.username,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        docId: docId ?? this.docId,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        uid: json["uid"],
        email: json["email"],
        displayName: json["displayName"],
        avatarUrl: json["avatarUrl"],
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        docId: json["docId"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "displayName": displayName,
        "avatarUrl": avatarUrl,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "docId": docId,
      };
}
