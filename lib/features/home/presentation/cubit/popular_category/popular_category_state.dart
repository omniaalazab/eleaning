import 'package:eleaning/features/home/data/models/popular_category_model.dart';

class PopularCategoryStatus {}

class PopularCategoryInitial extends PopularCategoryStatus {}

class PopularCategoryLoading extends PopularCategoryStatus {}

class PopularCategorySucess extends PopularCategoryStatus {
  final List<PopularCategoryModel> popularCategories;
  PopularCategorySucess({required this.popularCategories});
}

class PopularCategoryFailure extends PopularCategoryStatus {
  final String message;
  PopularCategoryFailure({required this.message});
}
