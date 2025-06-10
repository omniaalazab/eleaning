import 'package:eleaning/features/courses/data/repo/courses_repository.dart';
import 'package:eleaning/features/courses/presentation/cubit/courses/courses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CoursesRepository coursesRepository;
  CoursesCubit(this.coursesRepository) : super(CoursesInitial());
  void getCourses() async {
    emit(CoursesLoading());
    try {
      final courses = await coursesRepository.getCourses();
      emit(CoursesSucesss(courses: courses));
    } catch (e) {
      emit(CoursesFailure(error: e.toString()));
    }
  }
}
