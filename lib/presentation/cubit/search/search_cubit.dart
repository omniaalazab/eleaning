import 'package:eleaning/data/models/course_model.dart';
import 'package:eleaning/data/repository/courses_repository.dart';
import 'package:eleaning/presentation/cubit/search/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchCoursesState> {
  final CoursesRepository coursesRepository;
  SearchCubit(this.coursesRepository) : super(SearchCoursesInitial());
  List<CourseModel> foundedProduct = [];
  List<CourseModel> resultProductList = [];

  Future<void> getFirestoreDocuments() async {
    emit(SearchCoursesLoading());
    try {
      foundedProduct = await coursesRepository.getCoursesByTitle();
      emit(SearchCoursesSucesss(courses: foundedProduct));
    } catch (e) {
      emit(SearchCoursesFailure(error: e.toString()));
    }
  }

  void clearSearch() {
    resultProductList = List.from(foundedProduct);
    emit(SearchCoursesSucesss(courses: resultProductList));
  }

  void searchResultList(String query) {
    if (query.isEmpty) {
      resultProductList = List.from(foundedProduct);
    } else {
      resultProductList =
          foundedProduct
              .where(
                (courses) =>
                    courses.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    if (resultProductList.isNotEmpty) {
      emit(SearchCoursesSucesss(courses: resultProductList));
    } else {
      emit(SearchCoursesFailure(error: 'No courses found'));
    }
  }
}
