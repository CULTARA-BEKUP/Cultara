import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.contentId,
    required super.contentType,
    required super.userId,
    required super.userName,
    super.userPhotoUrl,
    required super.comment,
    required super.createdAt,
    super.updatedAt,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      contentId: data['contentId'] ?? '',
      contentType: data['contentType'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhotoUrl: data['userPhotoUrl'],
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'contentId': contentId,
      'contentType': contentType,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  Comment toEntity() {
    return Comment(
      id: id,
      contentId: contentId,
      contentType: contentType,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
