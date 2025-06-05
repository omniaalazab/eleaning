import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String id;
  String title;
  String description;
  String category;
  String imagePath;
  List<Video> videos;
  int amount;
  bool isPaid;
  CourseModel({
    required this.title,
    required this.id,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.videos,
    required this.amount,
    required this.isPaid,
  });
  factory CourseModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: data['id'] ?? doc.id,
      category: data['category'] ?? "No category",
      title: data['title'] ?? "",
      description: data['description'] ?? "",
      amount: data['amount'] ?? 0,
      imagePath: data['imagePath'] ?? "",
      isPaid: data['isPaid'] ?? false,
      videos:
          (data['videos'] as List<dynamic>)
              .map((video) => Video.fromMap(video))
              .toList(),
    );
  }
  factory CourseModel.fromMap(Map<dynamic, dynamic> map) {
    return CourseModel(
      id: map['id'],
      category: map['category'],
      description: map['description'],
      title: map['title'],
      imagePath: map['imagePath'],
      amount: map['amount'] ?? 0,
      isPaid: map['isPaid'] ?? false,

      videos:
          (map['videos'] as List<dynamic>)
              .map((video) => Video.fromMap(video))
              .toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'title': title,
      'imagePath': imagePath,
      'amount': amount,
      'iaPaid': isPaid,
      'videos': videos.map((video) => video.toMap()).toList(),
    };
  }
}

class Video {
  final String title;
  final String youtubeUrl;

  Video({required this.title, required this.youtubeUrl});

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      title: map['title'] ?? '',
      youtubeUrl: map['youtubeUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'youtubeUrl': youtubeUrl};
  }
}
