import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String id;
  final String contentId; 
  final String contentType;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final double rating; 
  final String? review;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Rating({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.rating,
    this.review,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    contentId,
    contentType,
    userId,
    userName,
    userPhotoUrl,
    rating,
    review,
    createdAt,
    updatedAt,
  ];
}
