// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PopularCategoryModel {
  String categoryTitle;
  String categoryImage;
  PopularCategoryModel({
    required this.categoryTitle,
    required this.categoryImage,
  });
  factory PopularCategoryModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PopularCategoryModel(
      categoryTitle: data['categoryTitle'] ?? "No title",
      categoryImage: data['categoryImage'] ?? "",
    );
  }
  factory PopularCategoryModel.fromMap(Map<dynamic, dynamic> map) {
    return PopularCategoryModel(
      categoryTitle: map['categoryTitle'],
      categoryImage: map['categoryImage'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'categoryTitle': categoryTitle, 'categoryImage': categoryImage};
  }
}
