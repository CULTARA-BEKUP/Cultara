import 'package:flutter/material.dart';

class EventContactInfo extends StatelessWidget {
  final String phone;
  final String website;

  const EventContactInfo({
    super.key,
    required this.phone,
    required this.website,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Info Pemesanan dan Lebih Lanjut',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.phone, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                phone,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.language, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                website,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
