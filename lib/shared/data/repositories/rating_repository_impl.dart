import '../../domain/entities/rating.dart';
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating_remote_datasource.dart';
import '../models/rating_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;

  RatingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Rating>> getRatingsByContentId(
    String contentId,
    String contentType,
  ) async {
    try {
      final ratingModels = await remoteDataSource.getRatingsByContentId(
        contentId,
        contentType,
      );
      return ratingModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get ratings: $e');
    }
  }

  @override
  Future<Rating?> getUserRating(
    String contentId,
    String contentType,
    String userId,
  ) async {
    try {
      final ratingModel = await remoteDataSource.getUserRating(
        contentId,
        contentType,
        userId,
      );
      return ratingModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get user rating: $e');
    }
  }

  @override
  Future<double> getAverageRating(String contentId, String contentType) async {
    try {
      return await remoteDataSource.getAverageRating(contentId, contentType);
    } catch (e) {
      throw Exception('Failed to get average rating: $e');
    }
  }

  @override
  Future<Map<int, int>> getRatingDistribution(
    String contentId,
    String contentType,
  ) async {
    try {
      final ratings = await getRatingsByContentId(contentId, contentType);
      final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      for (var rating in ratings) {
        final stars = rating.rating.round();
        distribution[stars] = (distribution[stars] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      throw Exception('Failed to get rating distribution: $e');
    }
  }

  @override
  Future<String> createRating(Rating rating) async {
    try {
      final ratingModel = RatingModel(
        id: rating.id,
        contentId: rating.contentId,
        contentType: rating.contentType,
        userId: rating.userId,
        userName: rating.userName,
        userPhotoUrl: rating.userPhotoUrl,
        rating: rating.rating,
        review: rating.review,
        createdAt: rating.createdAt,
        updatedAt: rating.updatedAt,
      );
      return await remoteDataSource.createRating(ratingModel);
    } catch (e) {
      throw Exception('Failed to create rating: $e');
    }
  }

  @override
  Future<void> updateRating(String id, double rating, String? review) async {
    try {
      await remoteDataSource.updateRating(id, rating, review);
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  @override
  Future<void> deleteRating(String id) async {
    try {
      await remoteDataSource.deleteRating(id);
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }
}
