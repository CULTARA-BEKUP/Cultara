import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating_model.dart';

abstract class RatingRemoteDataSource {
  Future<List<RatingModel>> getRatingsByContentId(
    String contentId,
    String contentType,
  );
  Future<RatingModel?> getUserRating(
    String contentId,
    String contentType,
    String userId,
  );
  Future<RatingModel?> getUserRatingForContent(
    String userId,
    String contentId,
    String contentType,
  );
  Future<double> getAverageRating(String contentId, String contentType);
  Future<String> createRating(RatingModel rating);
  Future<void> updateRating(String id, double rating, String? review);
  Future<void> deleteRating(String id);
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final FirebaseFirestore firestore;

  RatingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<RatingModel>> getRatingsByContentId(
    String contentId,
    String contentType,
  ) async {
    try {

      final querySnapshot = await firestore
          .collection('ratings')
          .where('contentId', isEqualTo: contentId)
          .where('contentType', isEqualTo: contentType)
          .get();


      final ratings = querySnapshot.docs.map((doc) {
        return RatingModel.fromFirestore(doc);
      }).toList();

      // Sort by createdAt in memory instead of in query
      ratings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return ratings;
    } catch (e) {
      throw Exception('Failed to fetch ratings: $e');
    }
  }

  @override
  Future<RatingModel?> getUserRating(
    String contentId,
    String contentType,
    String userId,
  ) async {
    try {
      final querySnapshot = await firestore
          .collection('ratings')
          .where('contentId', isEqualTo: contentId)
          .where('contentType', isEqualTo: contentType)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      return RatingModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to fetch user rating: $e');
    }
  }

  @override
  Future<RatingModel?> getUserRatingForContent(
    String userId,
    String contentId,
    String contentType,
  ) async {
    // Same as getUserRating but different parameter order
    return getUserRating(contentId, contentType, userId);
  }

  @override
  Future<double> getAverageRating(String contentId, String contentType) async {
    try {
      final querySnapshot = await firestore
          .collection('ratings')
          .where('contentId', isEqualTo: contentId)
          .where('contentType', isEqualTo: contentType)
          .get();

      if (querySnapshot.docs.isEmpty) return 0.0;

      final ratings = querySnapshot.docs
          .map((doc) => (doc.data()['rating'] as num).toDouble())
          .toList();

      final sum = ratings.reduce((a, b) => a + b);
      return sum / ratings.length;
    } catch (e) {
      throw Exception('Failed to calculate average rating: $e');
    }
  }

  @override
  Future<String> createRating(RatingModel rating) async {
    try {

      final docRef = await firestore
          .collection('ratings')
          .add(rating.toFirestore());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create rating: $e');
    }
  }

  @override
  Future<void> updateRating(String id, double rating, String? review) async {
    try {
      await firestore.collection('ratings').doc(id).update({
        'rating': rating,
        'review': review,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  @override
  Future<void> deleteRating(String id) async {
    try {
      await firestore.collection('ratings').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }
}
