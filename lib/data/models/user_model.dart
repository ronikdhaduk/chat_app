import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isOnline;
  final Timestamp lastSeen;
  final Timestamp createdAt;
  final String? fcmToken;
  final List<String> blockedUser;

  UserModel(
      {required this.uid,
      required this.userName,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      this.isOnline = false,
      Timestamp? lastSeen,
      Timestamp? createdAt,
      this.fcmToken,
      this.blockedUser = const []})
      : lastSeen = lastSeen ?? Timestamp.now(),
        createdAt = createdAt ?? Timestamp.now();

  UserModel copyWith(
      {String? uid,
      String? userName,
      String? fullName,
      String? email,
      String? phoneNumber,
      bool? isOnline,
      Timestamp? lastSeen,
      Timestamp? createdAt,
      String? fcmToken,
      List<String>? blockedUser}) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: this.userName,
      fullName: this.fullName,
      email: this.email,
      phoneNumber: this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      fcmToken: this.fcmToken,
      blockedUser: blockedUser ?? this.blockedUser,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
        uid: doc.id,
        userName: data["userName"] ?? "",
        fullName: data["fullName"] ?? "",
        email: data["email"] ?? "",
        phoneNumber: data["phoneNumber"] ?? "",
        isOnline: data["isOnline"] ?? false,
        lastSeen: data["lastSeen"] ?? Timestamp.now(),
        createdAt: data["createdAt"] ?? Timestamp.now(),
        blockedUser: List<String>.from(data["blockedUser"]),
        fcmToken: data["fcmToken"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "email": email,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "isOnline": isOnline,
      "lastSeen": lastSeen,
      "createdAt": createdAt,
      "blockedUser": blockedUser,
      "fcmToken": fcmToken,
    };
  }
}
