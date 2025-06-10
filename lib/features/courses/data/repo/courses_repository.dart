import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/features/courses/data/models/course_model.dart';

class CoursesRepository {
  Future<List<CourseModel>> getCourses() async {
    final querySnapShot =
        await FirebaseFirestore.instance.collection("courses").get();

    List<CourseModel> mostWatched =
        querySnapShot.docs.map((doc) => CourseModel.fromSnapshot(doc)).toList();
    return mostWatched;
  }

  Future<List<CourseModel>> getCoursesByTitle() async {
    final data =
        await FirebaseFirestore.instance
            .collection('courses')
            .orderBy('title')
            .get();
    return data.docs.map((doc) => CourseModel.fromSnapshot(doc)).toList();
  }
}
