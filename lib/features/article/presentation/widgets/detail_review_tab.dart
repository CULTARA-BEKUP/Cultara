import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/presentation/providers/rating_provider.dart';
import '../../../../shared/presentation/providers/comment_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/rating_dialog.dart';

class DetailReviewTab extends StatefulWidget {
  final String contentId;
  final String contentType;
  final ScrollController? scrollController;
  final VoidCallback? onRatingUpdated;

  const DetailReviewTab({
    super.key,
    required this.contentId,
    required this.contentType,
    this.scrollController,
    this.onRatingUpdated,
  });

  @override
  State<DetailReviewTab> createState() => _DetailReviewTabState();
}

class _DetailReviewTabState extends State<DetailReviewTab> {
  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  void _loadRatings() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.currentUser?.id;


      context.read<RatingProvider>().fetchRatings(
        widget.contentId,
        widget.contentType,
        userId: userId,
      );
      context.read<CommentProvider>().fetchComments(
        widget.contentId,
        widget.contentType,
        userId: userId,
      );
    });
  }

  void _showRatingDialog() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login untuk memberikan rating'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ratingProvider = context.read<RatingProvider>();
    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        contentId: widget.contentId,
        contentType: widget.contentType,
        existingRating: ratingProvider.userRating,
      ),
    ).then((result) {
      if (result == true) {
        // Refresh ratings after dialog closed
        final userId = authProvider.currentUser?.id;
        context.read<RatingProvider>().fetchRatings(
          widget.contentId,
          widget.contentType,
          userId: userId,
        );
        if (widget.onRatingUpdated != null) {
          widget.onRatingUpdated!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingProvider>(
      builder: (context, ratingProvider, _) {
        if (ratingProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            final authProvider = context.read<AuthProvider>();
            final userId = authProvider.currentUser?.id;
            await context.read<RatingProvider>().fetchRatings(
              widget.contentId,
              widget.contentType,
              userId: userId,
            );
          },
          child: SingleChildScrollView(
            controller:
                widget.scrollController, // Use the provided scrollController
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating Summary
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ratingProvider.averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildStarDisplay(ratingProvider.averageRating),
                        const SizedBox(height: 4),
                        Text(
                          '${ratingProvider.totalRatings} rating',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),

                    // Rating Distribution Bars
                    Expanded(
                      child: Column(
                        children: [
                          _buildRatingBar(
                            5,
                            ratingProvider.getRatingPercentage(5),
                            ratingProvider,
                          ),
                          _buildRatingBar(
                            4,
                            ratingProvider.getRatingPercentage(4),
                            ratingProvider,
                          ),
                          _buildRatingBar(
                            3,
                            ratingProvider.getRatingPercentage(3),
                            ratingProvider,
                          ),
                          _buildRatingBar(
                            2,
                            ratingProvider.getRatingPercentage(2),
                            ratingProvider,
                          ),
                          _buildRatingBar(
                            1,
                            ratingProvider.getRatingPercentage(1),
                            ratingProvider,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Add/Edit Rating Button
                ElevatedButton.icon(
                  onPressed: _showRatingDialog,
                  icon: Icon(
                    ratingProvider.userRating != null ? Icons.edit : Icons.add,
                    color: Colors.black,
                  ),
                  label: Text(
                    ratingProvider.userRating != null
                        ? "Edit Rating & Review Anda"
                        : "Berikan Nilai dan Review",
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                const SizedBox(height: 24),

                // Reviews List
                if (ratingProvider.ratings.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada review',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...ratingProvider.ratings.map((rating) {
                    return _buildUserReviewCard(context, rating);
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStarDisplay(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 24);
        } else if (index < rating) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 24);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 24);
        }
      }),
    );
  }

  Widget _buildRatingBar(int star, double percentage, ratingProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$star',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              '${(percentage * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserReviewCard(BuildContext context, rating) {
    final authProvider = context.read<AuthProvider>();
    final ratingProvider = context.read<RatingProvider>();
    final currentUser = authProvider.currentUser;
    final isOwnReview = currentUser?.id == rating.userId;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: rating.userName.isNotEmpty
                      ? _getColorFromName(rating.userName)
                      : Colors.grey,
                  backgroundImage:
                      rating.userPhotoUrl != null &&
                          rating.userPhotoUrl.isNotEmpty
                      ? NetworkImage(rating.userPhotoUrl)
                      : null,
                  child:
                      (rating.userPhotoUrl == null ||
                          rating.userPhotoUrl.isEmpty)
                      ? Text(
                          rating.userName.isNotEmpty
                              ? rating.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            rating.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (isOwnReview) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Anda',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _formatDate(rating.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            if (rating.review != null && rating.review!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                rating.review!,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 14),
              ),
            ],
            if (isOwnReview) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => RatingDialog(
                          contentId: widget.contentId,
                          contentType: widget.contentType,
                          existingRating: rating,
                        ),
                      ).then((result) {
                        if (result == true) {
                          ratingProvider.fetchRatings(
                            widget.contentId,
                            widget.contentType,
                            userId: currentUser?.id,
                          );
                        }
                      });
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      _showDeleteConfirmation(rating);
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Hapus'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(rating) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Rating'),
        content: const Text('Apakah Anda yakin ingin menghapus rating ini?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              final scaffoldMessenger = ScaffoldMessenger.of(context);

              final authProvider = context.read<AuthProvider>();
              final ratingProvider = context.read<RatingProvider>();
              final userId = authProvider.currentUser?.id;

              final success = await ratingProvider.deleteRating(
                rating.id,
                widget.contentId,
                widget.contentType,
                userId ?? '',
              );

              if (success) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Rating berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      ratingProvider.errorMessage ?? 'Gagal menghapus rating',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Color _getColorFromName(String name) {
    final colors = [
      const Color(0xFFE57373), // Red
      const Color(0xFFBA68C8), // Purple
      const Color(0xFF64B5F6), // Blue
      const Color(0xFF4DB6AC), // Teal
      const Color(0xFF81C784), // Green
      const Color(0xFFFFD54F), // Amber
      const Color(0xFFFF8A65), // Deep Orange
      const Color(0xFF9575CD), // Deep Purple
      const Color(0xFF4FC3F7), // Light Blue
      const Color(0xFF4DD0E1), // Cyan
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Baru saja';
        }
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }
}
