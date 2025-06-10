import 'package:eleaning/features/courses/data/models/course_model.dart';

class SearchCoursesState {}

class SearchCoursesInitial extends SearchCoursesState {}

class SearchCoursesLoading extends SearchCoursesState {}

class SearchCoursesSucesss extends SearchCoursesState {
  final List<CourseModel> courses;
  SearchCoursesSucesss({required this.courses});
}

class SearchCoursesFailure extends SearchCoursesState {
  final String error;
  SearchCoursesFailure({required this.error});
}
