import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/entities/rating.dart';
import '../presentation/providers/rating_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class RatingDialog extends StatefulWidget {
  final String contentId;
  final String contentType;
  final Rating? existingRating;

  const RatingDialog({
    super.key,
    required this.contentId,
    required this.contentType,
    this.existingRating,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;
  final _reviewController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingRating != null) {
      _rating = widget.existingRating!.rating;
      _reviewController.text = widget.existingRating!.review ?? '';
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih rating terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final ratingProvider = context.read<RatingProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool success;

    if (widget.existingRating != null) {
      // Update existing rating
      success = await ratingProvider.updateRating(
        widget.existingRating!.id,
        _rating,
        _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
        widget.contentId,
        widget.contentType,
        user.id,
      );
    } else {
      // Create new rating
      final newRating = Rating(
        id: '',
        contentId: widget.contentId,
        contentType: widget.contentType,
        userId: user.id,
        userName: user.name,
        userPhotoUrl: user.photoUrl,
        rating: _rating,
        review: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
        createdAt: DateTime.now(),
      );
      success = await ratingProvider.addRating(newRating);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    // Save ScaffoldMessenger before closing dialog
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (success) {
      Navigator.pop(context, true);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.existingRating != null
                ? 'Rating berhasil diperbarui'
                : 'Rating berhasil ditambahkan',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            ratingProvider.errorMessage ?? 'Gagal menyimpan rating',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingRating != null
                      ? 'Edit Rating'
                      : 'Berikan Rating',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Star Rating
            const Text(
              'Rating',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 40,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            if (_rating > 0)
              Center(
                child: Text(
                  '${_rating.toStringAsFixed(0)} dari 5',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 24),

            // Review Text Field
            const Text(
              'Review (Opsional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis review Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.existingRating != null ? 'Update' : 'Kirim',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
