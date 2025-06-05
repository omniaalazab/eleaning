import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String title;
  String description;
  String category;
  String imagePath;
  List<Video> videos;
  int amount;
  CourseModel({
    required this.title,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.videos,
    required this.amount,
  });
  factory CourseModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      category: data['category'] ?? "No category",
      title: data['title'] ?? "",
      description: data['description'] ?? "",
      amount: data['amount'] ?? 0,
      imagePath: data['imagePath'] ?? "",
      videos:
          (data['videos'] as List<dynamic>)
              .map((video) => Video.fromMap(video))
              .toList(),
    );
  }
  factory CourseModel.fromMap(Map<dynamic, dynamic> map) {
    return CourseModel(
      category: map['category'],
      description: map['description'],
      title: map['title'],
      imagePath: map['imagePath'],
      amount: map['amount'] ?? 0,

      videos:
          (map['videos'] as List<dynamic>)
              .map((video) => Video.fromMap(video))
              .toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'title': title,
      'imagePath': imagePath,
      'amount': amount,
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
