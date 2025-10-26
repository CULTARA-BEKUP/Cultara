import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String contentId; 
  final String contentType; 
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Comment({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.comment,
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
    comment,
    createdAt,
    updatedAt,
  ];
}
