import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/features/home/data/models/teacher_model.dart';

class TeacherRepository {
  Future<List<TeacherModel>> getTeacher() async {
    final querySnapShot =
        await FirebaseFirestore.instance.collection("teacher").get();
    log("Firestore query returned ${querySnapShot.docs.length} documents");

    if (querySnapShot.docs.isEmpty) {
      log("No teacher documents found");
      return [];
    }

    List<TeacherModel> teacher =
        querySnapShot.docs
            .map((doc) => TeacherModel.fromSnapshot(doc))
            .toList();
    return teacher;
  }
}
