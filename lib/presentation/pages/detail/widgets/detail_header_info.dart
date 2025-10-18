import 'package:flutter/material.dart';

class DetailHeaderInfo extends StatelessWidget {
  final String title;

  const DetailHeaderInfo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 4),
          const Text(
            "Mengenal lebih dalam tentang Tari Saman, tarian tradisional Aceh yang telah diakui UNESCO sebagai Warisan Budaya Takbenda.",
            style: TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}