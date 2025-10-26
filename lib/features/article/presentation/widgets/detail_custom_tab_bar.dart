import 'package:flutter/material.dart';

class DetailCustomTabBar extends StatelessWidget {
  const DetailCustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicatorColor: Colors.black,
      indicatorWeight: 3.0,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      tabs: [
        Tab(text: "Deskripsi"),
        Tab(text: "Galeri"),
        Tab(text: "Review"),
      ],
    );
  }
}