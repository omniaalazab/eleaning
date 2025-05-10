import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  String teacherName;
  String imagePath;
  String jobTitle;
  TeacherModel({
    required this.teacherName,
    required this.jobTitle,
    required this.imagePath,
  });
  factory TeacherModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeacherModel(
      imagePath:
          data['imagePath'] ??
          "https://www.freeiconspng.com/thumbs/teacher-png/teacher-png-picture-17.jpg",
      jobTitle: data['jobTitle'] ?? "",
      teacherName: data['teacherName'] ?? "",
    );
  }
  factory TeacherModel.fromMap(Map<dynamic, dynamic> map) {
    return TeacherModel(
      imagePath: map['imagePath'],
      jobTitle: map['jobTitle'],
      teacherName: map["teacherName"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'jobTitle': jobTitle,
      'teacherName': teacherName,
    };
  }
}
