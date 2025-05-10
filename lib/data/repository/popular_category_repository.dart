import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/data/models/popular_category_model.dart';

class PopularCategoryRepository {
  Future<List<PopularCategoryModel>> getPopularCategory() async {
    final querySnapShot =
        await FirebaseFirestore.instance.collection("popular_category").get();

    List<PopularCategoryModel> popularCategory =
        querySnapShot.docs
            .map((doc) => PopularCategoryModel.fromSnapshot(doc))
            .toList();
    return popularCategory;
  }
}
