import '../entities/rating.dart';

abstract class RatingRepository {
  Future<List<Rating>> getRatingsByContentId(
    String contentId,
    String contentType,
  );
  Future<Rating?> getUserRating(
    String contentId,
    String contentType,
    String userId,
  );
  Future<double> getAverageRating(String contentId, String contentType);
  Future<Map<int, int>> getRatingDistribution(
    String contentId,
    String contentType,
  );
  Future<String> createRating(Rating rating);
  Future<void> updateRating(String id, double rating, String? review);
  Future<void> deleteRating(String id);
}
