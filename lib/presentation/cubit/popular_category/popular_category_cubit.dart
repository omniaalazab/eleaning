import 'package:eleaning/data/repository/popular_category_repository.dart';
import 'package:eleaning/presentation/cubit/popular_category/popular_category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularCategoryCubit extends Cubit<PopularCategoryStatus> {
  final PopularCategoryRepository _popularCategoryRepository;
  PopularCategoryCubit(this._popularCategoryRepository)
    : super(PopularCategoryInitial());
  void getPopularCategory() async {
    emit(PopularCategoryLoading());
    try {
      final categories = await _popularCategoryRepository.getPopularCategory();
      emit(PopularCategorySucess(popularCategories: categories));
    } catch (e) {
      emit(PopularCategoryFailure(message: e.toString()));
    }
  }
}
