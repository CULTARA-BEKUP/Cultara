import 'package:flutter/material.dart';

class ReviewBottomSheet extends StatelessWidget {
  final double rating;

  const ReviewBottomSheet({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Review',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildRatingOverview(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Berikan Nilai dan Review',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildUserReview(),
                  _buildUserReview(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingOverview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              rating.toString(),
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                if (index < rating.floor()) {
                  return const Icon(Icons.star, color: Colors.amber, size: 24);
                } else if (index < rating) {
                  return const Icon(
                    Icons.star_half,
                    color: Colors.amber,
                    size: 24,
                  );
                } else {
                  return Icon(
                    Icons.star_border,
                    color: Colors.grey[400],
                    size: 24,
                  );
                }
              }),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            children: [
              _buildRatingBar(1, 0.8),
              _buildRatingBar(2, 0.5),
              _buildRatingBar(3, 0.3),
              _buildRatingBar(4, 0.9),
              _buildRatingBar(5, 0.95),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int star, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$star', style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 5),
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
              minHeight: 8,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserReview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.teal[300],
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Nama User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '20 September 2025',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return const Icon(Icons.star, color: Colors.amber, size: 16);
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
        ],
      ),
    );
  }
}
