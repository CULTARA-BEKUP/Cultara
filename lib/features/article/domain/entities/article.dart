import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String category;
  final String location;
  final String content;
  final String imagePath;
  final String author;
  final DateTime createdAt;
  final int views;
  final String brief; 
  final List<String> galleryImages; 

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.content,
    required this.imagePath,
    required this.author,
    required this.createdAt,
    required this.views,
    this.brief = '',
    this.galleryImages = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    location,
    content,
    imagePath,
    author,
    createdAt,
    views,
    brief,
    galleryImages,
  ];
}
