import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/entities/rating.dart';
import '../data/models/rating_model.dart';
import '../data/datasources/rating_remote_datasource.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingWidget extends StatefulWidget {
  final String contentId;
  final String contentType; // 'museum', 'event', 'article'

  const RatingWidget({
    super.key,
    required this.contentId,
    required this.contentType,
  });

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late RatingRemoteDataSource _ratingDataSource;
  bool _isLoading = false;
  double _averageRating = 0.0;
  int _totalRatings = 0;
  Rating? _userRating;
  double _selectedRating = 0.0;
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ratingDataSource = RatingRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
    _loadRatings();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadRatings() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final currentUser = authProvider.currentUser;

      // Get average rating
      final avg = await _ratingDataSource.getAverageRating(
        widget.contentId,
        widget.contentType,
      );

      // Get all ratings to count
      final allRatings = await _ratingDataSource.getRatingsByContentId(
        widget.contentId,
        widget.contentType,
      );

      // Get user's rating if logged in
      Rating? userRating;
      if (currentUser != null) {
        userRating = await _ratingDataSource.getUserRatingForContent(
          currentUser.id,
          widget.contentId,
          widget.contentType,
        );
      }

      setState(() {
        _averageRating = avg;
        _totalRatings = allRatings.length;
        _userRating = userRating;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading ratings: $e')));
      }
    }
  }

  Future<void> _submitRating() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih rating terlebih dahulu')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_userRating != null) {
        // Update existing rating
        await _ratingDataSource.updateRating(
          _userRating!.id,
          _selectedRating,
          _reviewController.text.trim().isEmpty
              ? null
              : _reviewController.text.trim(),
        );
      } else {
        // Create new rating
        final rating = RatingModel(
          id: '',
          contentId: widget.contentId,
          contentType: widget.contentType,
          userId: currentUser.id,
          userName: currentUser.name,
          rating: _selectedRating,
          review: _reviewController.text.trim().isEmpty
              ? null
              : _reviewController.text.trim(),
          createdAt: DateTime.now(),
        );
        await _ratingDataSource.createRating(rating);
      }

      _reviewController.clear();
      setState(() {
        _selectedRating = 0.0;
      });
      Navigator.pop(context);
      await _loadRatings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating berhasil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showRatingDialog() {
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _selectedRating = _userRating?.rating ?? 0.0;
      _reviewController.text = _userRating?.review ?? '';
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_userRating != null ? 'Edit Rating' : 'Beri Rating'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih rating:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth;
                    double minPadding = 8;
                    double starSize = (maxWidth - minPadding * 2) / 5;
              if (starSize > 24) starSize = 24;
              if (starSize < 14) starSize = 14;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: minPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starValue = index + 1;
                          return Flexible(
                            child: IconButton(
                              icon: Icon(
                                starValue <= _selectedRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: starSize,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setDialogState(() {
                                  _selectedRating = starValue.toDouble();
                                });
                                setState(() {
                                  _selectedRating = starValue.toDouble();
                                });
                              },
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Review (opsional):',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    hintText: 'Tulis review Anda...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 200,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedRating = 0.0;
                  _reviewController.clear();
                });
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _submitRating();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarDisplay(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return Icon(
          starValue <= rating.round()
              ? Icons.star
              : (starValue - 0.5 <= rating
                    ? Icons.star_half
                    : Icons.star_border),
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with average rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          ' / 5.0',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      '$_totalRatings rating',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const Spacer(),
                if (!_isLoading)
                  ElevatedButton.icon(
                    onPressed: _showRatingDialog,
                    icon: Icon(
                      _userRating != null ? Icons.edit : Icons.star_border,
                      size: 18,
                    ),
                    label: Text(_userRating != null ? 'Edit' : 'Beri Rating'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),

            // Star display
            if (_totalRatings > 0) ...[
              const SizedBox(height: 12),
              _buildStarDisplay(_averageRating, size: 24),
            ],

            // User's rating display
            if (_userRating != null) ...[
              const Divider(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 20,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Rating Anda',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        const Spacer(),
                        _buildStarDisplay(_userRating!.rating.toDouble()),
                      ],
                    ),
                    if (_userRating!.review != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _userRating!.review!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Empty state for not logged in users
            if (currentUser == null && _totalRatings == 0) ...[
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Login untuk memberikan rating',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
