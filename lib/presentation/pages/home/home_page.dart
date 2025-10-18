import 'package:flutter/material.dart';
import 'package:cultara/presentation/pages/detail/article_detail_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSearchBar(context),
            const SizedBox(height: 16),
            _buildDigitalMuseumCard(context),
            const SizedBox(height: 16),
            _buildStatBoxes(context),
            const SizedBox(height: 16),
            const Text(
              'Informasi Budaya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoArticleCard(
              context, 
              category: 'Tarian', 
              location: 'Aceh',
              title: 'Tari Saman: Warisan UNESCO dari Tanah Gayo', 
              imagePath: 'assets/images/tari_saman.jpg' 
            ),
            _buildInfoArticleCard(
              context, 
              category: 'Lagu Daerah', 
              location: 'Kalimantan Selatan',
              title: 'Lagu Daerah Populer: Ampar-Ampar Pisang', 
              imagePath: 'assets/images/lagu_daerah.jpg' 
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false, 
      title: const Text('Hi, Cultivers!', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(Icons.person, color: Colors.white), 
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoArticleCard(
    BuildContext context, 
    {required String category, 
    required String location, 
    required String title, 
    required String imagePath}
  ) {
    return Card(
      clipBehavior: Clip.antiAlias, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Gambar tidak ditemukan")),
                  );
                },
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(location, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.share, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tari Saman termasuk dalam daftar Warisan Budaya Takbenda UNESCO. Tarian tradisional Aceh...',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(
                            title: title, 
                            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                            imageUrl: imagePath,
                          ),
                        ),
                      );
                    },
                    child: const Text('Baca Selengkapnya'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.red[700], 
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari tarian, lagu daerah, atau provinsi...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDigitalMuseumCard(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/museum_digital_bg.jpg'), 
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: null,
    );
  }

  Widget _buildStatBoxes(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), 
      crossAxisCount: 2,
      childAspectRatio: 2.5, 
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: const <Widget>[
        _StatBox(count: '100', label: 'Total Artikel'),
        _StatBox(count: '38', label: 'Provinsi'),
        _StatBox(count: '200', label: 'Tarian Daerah'),
        _StatBox(count: '135', label: 'Lagu Daerah'),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Kegiatan'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Komunitas'),
      ],
      currentIndex: 0, 
      selectedItemColor: Colors.red[700], 
    );
  }
}

class _StatBox extends StatelessWidget {
  final String count;
  final String label;

  const _StatBox({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary, 
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}