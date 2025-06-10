import 'package:cloud_firestore/cloud_firestore.dart';

class MostWatchedModel {
  String imagePath;
  String courseTitle;
  String teacherName;
  int watchedNumber;
  double rate;

  MostWatchedModel({
    required this.imagePath,
    required this.courseTitle,
    required this.teacherName,
    required this.watchedNumber,
    required this.rate,
  });
  factory MostWatchedModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MostWatchedModel(
      imagePath: data['imagePath'] ?? "No title",
      courseTitle: data['courseTitle'] ?? "",
      teacherName: data['teacherName'] ?? "",
      watchedNumber: data['watchedNumber'] ?? "",
      rate: (data['rate'] ?? 0).toDouble(),
    );
  }
  factory MostWatchedModel.fromMap(Map<dynamic, dynamic> map) {
    return MostWatchedModel(
      imagePath: map['imagePath'],
      courseTitle: map['courseTitle'],
      teacherName: map["teacherName"],
      watchedNumber: map['watchedNumber'],
      rate: (map['rate'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'courseTitle': courseTitle,
      'teacherName': teacherName,
      'watchedNumber': watchedNumber,
      'rate': rate,
    };
  }
}
