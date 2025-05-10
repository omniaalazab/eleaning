import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String userName;
  String userMail;
  String userImagePath;
  String userPassword;
  String userFullName;

  Users({
    required this.userName,
    required this.userMail,
    required this.userPassword,
    required this.userFullName,
    this.userImagePath = "",
  });
  factory Users.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Users(
      userName: data['userName'] ?? "",
      userMail: data['userMail'] ?? "",
      userImagePath: data['userImagePath'] ?? "",
      userPassword: data['userPassword'] ?? "",
      userFullName: data['userFullName'] ?? "",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userMail': userMail,
      'userImagePath': userImagePath,
      'userPassword': userPassword,
      'userFullName': userFullName,
    };
  }

  factory Users.fromMap(Map<dynamic, dynamic> map) {
    return Users(
      userName: map['userName'],
      userMail: map['userMail'],
      userImagePath: map['userImagePath'],
      userPassword: map['userPassword'],
      userFullName: map['userFullName'],
    );
  }
}
