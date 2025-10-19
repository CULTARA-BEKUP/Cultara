import 'package:flutter/material.dart';
import 'package:cultara/presentation/pages/detail/widgets/detail_image_header.dart';
import 'package:cultara/presentation/pages/detail/widgets/detail_header_info.dart';
import 'package:cultara/presentation/pages/detail/widgets/detail_custom_tab_bar.dart';
import 'package:cultara/presentation/pages/detail/widgets/detail_review_tab.dart'; 

class ArticleDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const ArticleDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        extendBodyBehindAppBar: true, 
        
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menggunakan Class Widget yang Diimpor
              DetailImageHeader(imageUrl: imageUrl),
              DetailHeaderInfo(title: title),
              const DetailCustomTabBar(),
              
              SizedBox(
                height: 600, 
                child: TabBarView(
                  children: [
                    _buildDescriptionContent(context),
                    _buildGalleryGrid(context),
                    const DetailReviewTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 16, 
            left: 16, 
            right: 16, 
            top: 16
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(vertical: 8), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
            ),
            child: const Text(
              "Simpan Sebagai Favorit",
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tentang Tari Saman", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid(BuildContext context) {
    final List<String> galleryImages = [
      'assets/images/tari_saman.jpg',
      'assets/images/lagu_daerah.jpg',
      'assets/images/tari_saman.jpg',
      'assets/images/lagu_daerah.jpg',
    ];

    return GridView.builder( 
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: galleryImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            galleryImages[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
          ),
        );
      },
    );
  }
}