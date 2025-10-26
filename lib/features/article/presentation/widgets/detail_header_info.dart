import 'package:flutter/material.dart';

class DetailHeaderInfo extends StatelessWidget {
  final String title;
  final String brief;

  const DetailHeaderInfo({super.key, required this.title, this.brief = ''});

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
          if (brief.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              brief,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ],
      ),
    );
  }
}
