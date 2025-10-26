import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rating.dart';

class RatingModel extends Rating {
  const RatingModel({
    required super.id,
    required super.contentId,
    required super.contentType,
    required super.userId,
    required super.userName,
    super.userPhotoUrl,
    required super.rating,
    super.review,
    required super.createdAt,
    super.updatedAt,
  });

  factory RatingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RatingModel(
      id: doc.id,
      contentId: data['contentId'] ?? '',
      contentType: data['contentType'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhotoUrl: data['userPhotoUrl'],
      rating: (data['rating'] ?? 0).toDouble(),
      review: data['review'],
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
      'rating': rating,
      'review': review,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  Rating toEntity() {
    return Rating(
      id: id,
      contentId: contentId,
      contentType: contentType,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      rating: rating,
      review: review,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
