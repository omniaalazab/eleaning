import 'package:eleaning/data/models/course_model.dart';

class CoursesState {}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesSucesss extends CoursesState {
  final List<CourseModel> courses;
  CoursesSucesss({required this.courses});
}

class CoursesFailure extends CoursesState {
  final String error;
  CoursesFailure({required this.error});
}
