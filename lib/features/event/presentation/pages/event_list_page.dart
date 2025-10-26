import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cultara/features/event/presentation/pages/event_detail_page.dart';
import 'package:cultara/features/event/presentation/pages/event_form_page.dart';
import 'package:cultara/features/event/presentation/widgets/category_chip.dart';
import 'package:cultara/features/event/presentation/widgets/popular_event_card.dart';
import 'package:cultara/features/event/presentation/widgets/event_list_card.dart';
import 'package:cultara/features/event/presentation/providers/event_provider.dart';
import 'package:cultara/features/event/domain/entities/event.dart';
import 'package:cultara/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultara/features/auth/presentation/pages/edit_profile_page.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch events from Firebase when page loads
    Future.microtask(
      () => Provider.of<EventProvider>(context, listen: false).fetchAllEvents(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        final isLoading = eventProvider.isLoading;
        final filteredEvents = eventProvider.filteredEvents;
        final popularEvents = eventProvider.popularEvents;
        final selectedCategory = eventProvider.selectedCategory;

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
                    _buildSearchBar(eventProvider),
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
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomScrollView(
                            slivers: [
                              // Title "Festival Budaya Populer"
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 24),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
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
                                          Text(
                                            '🔥',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),

                              // Horizontal Popular Event Cards (by rating)
                              SliverToBoxAdapter(
                                child: popularEvents.isEmpty
                                    ? const SizedBox(
                                        height: 270,
                                        child: Center(
                                          child: Text(
                                            'Belum ada event populer',
                                          ),
                                        ),
                                      )
                                    : SizedBox(
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
                                            return _buildHorizontalEventCard(
                                              event,
                                            );
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
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
                                    _buildCategoryFilter(
                                      eventProvider,
                                      selectedCategory,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),

                              // Event List
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                sliver: filteredEvents.isEmpty
                                    ? SliverToBoxAdapter(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 32.0,
                                            bottom: 32.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.event_busy,
                                                size: 60,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                'Tidak ada event ditemukan',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Coba kata kunci lain atau hapus filter',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SliverList(
                                        delegate: SliverChildBuilderDelegate((
                                          context,
                                          index,
                                        ) {
                                          final event = filteredEvents[index];
                                          return _buildEventListCard(event);
                                        }, childCount: filteredEvents.length),
                                      ),
                              ),

                              // Bottom spacing
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 20),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: authProvider.currentUser?.isAdmin == true
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventFormPage(),
                      ),
                    ).then((_) {
                      // Refresh events after adding
                      eventProvider.fetchAllEvents();
                    });
                  },
                  backgroundColor: const Color(0xFFB71C1C),
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : null,
        );
      },
    );
  }


  Widget _buildHeader() {
    final authProvider = Provider.of<AuthProvider>(context);

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.teal[300],
              backgroundImage: authProvider.currentUser?.photoUrl != null
                  ? NetworkImage(authProvider.currentUser!.photoUrl!)
                  : null,
              child: authProvider.currentUser?.photoUrl == null
                  ? Text(
                      authProvider.currentUser?.name
                              .substring(0, 1)
                              .toUpperCase() ??
                          '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(EventProvider eventProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => eventProvider.searchEvents(value),
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
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  eventProvider.searchEvents('');
                  FocusScope.of(context).unfocus();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalEventCard(Event event) {
    // Convert Event entity to Map for widget compatibility
    final eventMap = {
      'id': event.id,
      'title': event.title,
      'location': event.location,
      'date': event.date,
      'time': event.time,
      'category': event.category,
      'imageCover': event.imageCover,
      'imageOther': event.imageOther,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'rating': event.rating,
      'description': event.description,
      'highlights': event.highlights,
      'phone': event.phone,
      'website': event.website,
    };

    return PopularEventCard(
      event: eventMap,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: eventMap),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(
    EventProvider eventProvider,
    String selectedCategory,
  ) {
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
              eventProvider.filterByCategory(category);
            },
          );
        },
      ),
    );
  }

  Widget _buildEventListCard(Event event) {
    // Convert Event entity to Map for widget compatibility
    final eventMap = {
      'id': event.id,
      'title': event.title,
      'location': event.location,
      'date': event.date,
      'time': event.time,
      'category': event.category,
      'imageCover': event.imageCover,
      'imageOther': event.imageOther,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'rating': event.rating,
      'description': event.description,
      'highlights': event.highlights,
      'phone': event.phone,
      'website': event.website,
    };

    return EventListCard(
      event: eventMap,
      eventEntity: event,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: eventMap),
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
      
      ],
    );
  }
}
