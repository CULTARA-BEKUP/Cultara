import 'package:flutter/material.dart';
import 'package:cultara/presentation/pages/event/event_detail_page.dart';
import 'package:cultara/presentation/pages/event/widgets/category_chip.dart';
import 'package:cultara/presentation/pages/event/widgets/popular_event_card.dart';
import 'package:cultara/presentation/pages/event/widgets/event_list_card.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  String selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allEvents = [
    {
      'id': '1',
      'title': 'Ramayana Ballet Prambanan',
      'location': 'Yogyakarta',
      'date': 'Selasa, Kamis, Sabtu',
      'time': '19:00 - 20:30',
      'category': 'Tarian',
      'imageCover': 'assets/images/ramayana1.png',
      'imageOther': ['assets/images/ramayana2.png'],
      'latitude': -7.752020,
      'longitude': 110.491490,
      'rating': 4.0,
      'description':
          'Saksikan pertunjukan Sendratari Ramayana yang ikonik di Candi Prambanan!',
      'highlights': [
        'Saksikan pertunjukan Sendratari Ramayana yang ikonik di Candi Prambanan!',
        'Nikmati perpaduan tari, musik, dan kostum tradisional Jawa yang memukau',
        'Rasakan ketegangan saat adegan perang dipentaskan dengan musik gamelan',
        'Saksikan perjalanan emosional Rama dan Shinta dalam empat babak yang penuh magis',
      ],
      'phone': '+6289178935678',
      'website': 'www.lorumipsum.com',
    },
    {
      'id': '2',
      'title': 'Festival Wayang Kulit Jawa',
      'location': 'Solo',
      'date': 'Jumat, 25 Oktober 2025',
      'time': '20:00 - 23:00',
      'category': 'Tarian',
      'imageCover': 'assets/images/wayang1.png',
      'imageOther': ['assets/images/wayang2.png'],
      'latitude': -7.575489,
      'longitude': 110.824326,
      'rating': 4.5,
      'description':
          'Festival wayang kulit terbesar di Jawa Tengah dengan dalang terkenal',
      'highlights': [
        'Pertunjukan wayang kulit dengan dalang Ki Manteb Soedharsono',
        'Pameran wayang kulit dari berbagai daerah di Indonesia',
        'Workshop membuat wayang kulit untuk pemula',
        'Live gamelan orchestra sepanjang acara',
      ],
      'phone': '+6289178935679',
      'website': 'www.wayangfest.com',
    },
    {
      'id': '3',
      'title': 'Konser Musik Gamelan Modern',
      'location': 'Bandung',
      'date': 'Sabtu, 2 November 2025',
      'time': '18:00 - 22:00',
      'category': 'Lagu Daerah',
      'imageCover': 'assets/images/gamelan1.png',
      'imageOther': [],
      'latitude': -6.914744,
      'longitude': 107.609810,
      'rating': 4.8,
      'description':
          'Kolaborasi musik gamelan tradisional dengan musik kontemporer',
      'highlights': [
        'Kolaborasi gamelan dengan musik jazz dan elektronik',
        'Penampilan dari musisi lokal dan internasional',
        'Food court dengan kuliner tradisional',
        'Meet and greet dengan para musisi',
      ],
      'phone': '+6289178935680',
      'website': 'www.gamelanmodern.com',
    },
    {
      'id': '4',
      'title': 'Workshop Batik Tulis Tradisional',
      'location': 'Pekalongan',
      'date': 'Minggu, 10 November 2025',
      'time': '09:00 - 15:00',
      'category': 'Lagu Daerah',
      'imageCover': 'assets/images/batik1.png',
      'imageOther': [],
      'latitude': -6.888631,
      'longitude': 109.675552,
      'rating': 4.2,
      'description':
          'Belajar membuat batik tulis langsung dari pengrajin senior',
      'highlights': [
        'Belajar teknik batik tulis dari master batik',
        'Membuat karya batik sendiri yang bisa dibawa pulang',
        'Mengenal filosofi motif batik tradisional',
        'Sertifikat workshop dari Dekranasda',
      ],
      'phone': '+6289178935681',
      'website': 'www.batikworkshop.com',
    },
    {
      'id': '5',
      'title': 'Festival Angklung Internasional',
      'location': 'Bandung',
      'date': 'Sabtu, 16 November 2025',
      'time': '14:00 - 18:00',
      'category': 'Lagu Daerah',
      'imageCover': 'assets/images/angklung1.png',
      'imageOther': [],
      'latitude': -6.900389,
      'longitude': 107.618683,
      'rating': 4.9,
      'description':
          'Festival angklung terbesar dengan peserta dari berbagai negara',
      'highlights': [
        'Pertunjukan angklung dari berbagai negara',
        'Workshop bermain angklung untuk pemula',
        'Pameran alat musik tradisional Nusantara',
        'Lomba orkestra angklung tingkat internasional',
      ],
      'phone': '+6289178935682',
      'website': 'www.angklungfest.com',
    },
  ];

  List<Map<String, dynamic>> get filteredEvents {
    return allEvents.where((event) {
      final matchesCategory =
          selectedCategory == 'Semua' || event['category'] == selectedCategory;
      final searchLower = _searchController.text.toLowerCase();
      final matchesSearch =
          event['title'].toString().toLowerCase().contains(searchLower) ||
          event['location'].toString().toLowerCase().contains(searchLower);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Map<String, dynamic>> get popularEvents {
    // Sort by rating (highest first)
    final sorted = List<Map<String, dynamic>>.from(allEvents);
    sorted.sort(
      (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
    );
    return sorted.take(5).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      body: Column(
        children: [
          // Fixed Header Section
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Scrollable Content Section
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: Colors.white,
                child: CustomScrollView(
                  slivers: [
                    // Title "Festival Budaya Populer"
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Text(
                                  'Festival Budaya Populer ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text('🔥', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // Horizontal Popular Event Cards (by rating)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          itemCount: popularEvents.length,
                          itemBuilder: (context, index) {
                            final event = popularEvents[index];
                            return _buildHorizontalEventCard(event);
                          },
                        ),
                      ),
                    ),

                    // Category Filter Section
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Kategori Festival Budaya',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildCategoryFilter(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // Event List
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final event = filteredEvents[index];
                          return _buildEventListCard(event);
                        }, childCount: filteredEvents.length),
                      ),
                    ),

                    // Bottom spacing
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset('assets/logo/logo.png', width: 50, height: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi, Cultuvers!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Temukan festival budaya terbaik anda',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.teal[300],
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() {}),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Cari festival, kota, atau waktu...',
            hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.white, size: 24),
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalEventCard(Map<String, dynamic> event) {
    return PopularEventCard(
      event: event,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['Semua', 'Lagu Daerah', 'Tarian'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return CategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildEventListCard(Map<String, dynamic> event) {
    return EventListCard(
      event: event,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: Colors.red[700],
      unselectedItemColor: Colors.grey,
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Kegiatan'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Komunitas'),
      ],
    );
  }
}
