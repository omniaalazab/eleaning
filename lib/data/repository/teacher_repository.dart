import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/data/models/teacher_model.dart';

class TeacherRepository {
  Future<List<TeacherModel>> getTeacher() async {
    final querySnapShot =
        await FirebaseFirestore.instance.collection("teacher").get();
    print("Firestore query returned ${querySnapShot.docs.length} documents");

    if (querySnapShot.docs.isEmpty) {
      print("No teacher documents found");
      return [];
    }

    List<TeacherModel> teacher =
        querySnapShot.docs
            .map((doc) => TeacherModel.fromSnapshot(doc))
            .toList();
    return teacher;
  }
}
