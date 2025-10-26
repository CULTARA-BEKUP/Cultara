import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.category,
    required super.location,
    required super.content,
    required super.imagePath,
    required super.author,
    required super.createdAt,
    required super.views,
    super.brief,
    super.galleryImages,
  });

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      content: data['content'] ?? '',
      imagePath: data['imagePath'] ?? '',
      author: data['author'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      views: data['views'] ?? 0,
      brief: data['brief'] ?? '',
      galleryImages: data['galleryImages'] != null
          ? List<String>.from(data['galleryImages'])
          : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'location': location,
      'content': content,
      'imagePath': imagePath,
      'author': author,
      'createdAt': Timestamp.fromDate(createdAt),
      'views': views,
      'brief': brief,
      'galleryImages': galleryImages,
    };
  }

  Article toEntity() {
    return Article(
      id: id,
      title: title,
      category: category,
      location: location,
      content: content,
      imagePath: imagePath,
      author: author,
      createdAt: createdAt,
      views: views,
      brief: brief,
      galleryImages: galleryImages,
    );
  }
}
