import 'package:flutter/material.dart';
import '../../domain/entities/rating.dart';
import '../../domain/repositories/rating_repository.dart';

class RatingProvider with ChangeNotifier {
  final RatingRepository repository;

  RatingProvider({required this.repository});

  List<Rating> _ratings = [];
  Rating? _userRating;
  double _averageRating = 0.0;
  Map<int, int> _ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  bool _isLoading = false;
  String? _errorMessage;

  List<Rating> get ratings => _ratings;
  Rating? get userRating => _userRating;
  double get averageRating => _averageRating;
  Map<int, int> get ratingDistribution => _ratingDistribution;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalRatings => _ratings.length;

  Future<void> fetchRatings(
    String contentId,
    String contentType, {
    String? userId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {

      _ratings = await repository.getRatingsByContentId(contentId, contentType);

      _averageRating = await repository.getAverageRating(
        contentId,
        contentType,
      );

      _ratingDistribution = await repository.getRatingDistribution(
        contentId,
        contentType,
      );

      if (userId != null) {
        _userRating = await repository.getUserRating(
          contentId,
          contentType,
          userId,
        );

        _ratings.sort((a, b) {
          final aIsOwn = a.userId == userId;
          final bIsOwn = b.userId == userId;

          if (aIsOwn && !bIsOwn) {
            return -1;
          }
          if (!aIsOwn && bIsOwn) {
            return 1;
          }

          return b.createdAt.compareTo(a.createdAt);
        });

      } else {
        _ratings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _ratings = [];
      _averageRating = 0.0;
      _ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      _userRating = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addRating(Rating rating) async {
    try {
      _errorMessage = null;
      await repository.createRating(rating);

      await fetchRatings(
        rating.contentId,
        rating.contentType,
        userId: rating.userId,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateRating(
    String id,
    double rating,
    String? review,
    String contentId,
    String contentType,
    String userId,
  ) async {
    try {
      _errorMessage = null;
      await repository.updateRating(id, rating, review);

      // Refresh ratings after updating
      await fetchRatings(contentId, contentType, userId: userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteRating(
    String id,
    String contentId,
    String contentType,
    String userId,
  ) async {
    try {
      _errorMessage = null;
      await repository.deleteRating(id);

      await fetchRatings(contentId, contentType, userId: userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  double getRatingPercentage(int stars) {
    if (totalRatings == 0) return 0.0;
    final count = _ratingDistribution[stars] ?? 0;
    return count / totalRatings;
  }
}
