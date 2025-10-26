import 'package:flutter/material.dart';

class EventInfoSection extends StatelessWidget {
  final String date;
  final String time;
  final VoidCallback onReviewTap;

  const EventInfoSection({
    super.key,
    required this.date,
    required this.time,
    required this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ),
              TextButton(
                onPressed: onReviewTap,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Lihat Review',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
