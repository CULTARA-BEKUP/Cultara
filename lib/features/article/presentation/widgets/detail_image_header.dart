import 'package:flutter/material.dart';

class DetailImageHeader extends StatelessWidget {
  final String imageUrl;
  final double? rating;
  final int? totalRatings;

  const DetailImageHeader({
    super.key,
    required this.imageUrl,
    this.rating,
    this.totalRatings,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 300,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            height: 300,
            color: Colors.grey[300],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'Gambar tidak dapat dimuat',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 300,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.white],
              stops: [0.8, 1.0],
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating != null && rating! > 0
                      ? rating!.toStringAsFixed(1)
                      : "0.0",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (totalRatings != null && totalRatings! > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    "($totalRatings)",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
