import 'package:cultara/features/museum/presentation/widgets/framed_painting_widget.dart';
import 'package:cultara/features/museum/presentation/widgets/museum_detail_dialog.dart';
import 'package:cultara/features/museum/presentation/pages/museum_form_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cultara/features/museum/presentation/providers/museum_provider.dart';
import 'package:cultara/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultara/features/museum/domain/entities/museum.dart';


class MuseumScreen extends StatefulWidget {
  const MuseumScreen({super.key});

  @override
  State<MuseumScreen> createState() => _MuseumScreenState();
}

class _MuseumScreenState extends State<MuseumScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.microtask(
      () =>
          Provider.of<MuseumProvider>(context, listen: false).fetchAllMuseums(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.currentUser?.isAdmin ?? false;

    return Consumer<MuseumProvider>(
      builder: (context, museumProvider, child) {
        final isLoading = museumProvider.isLoading;
        final museums = museumProvider.museums;

        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background_museum.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (museums.isEmpty)
                _buildEmptyState()
              else
                PageView.builder(
                  controller: _pageController,
                  itemCount: museums.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final museum = museums[index];
                    final museumOld = Museum(
                      id: museum.id,
                      name: museum.name,
                      image: museum.image,
                      description: museum.description,
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        GestureDetector(
                          onTap: () =>
                              showMuseumDetailDialog(context, museumOld),
                          child: FramedPainting(museum: museumOld),
                        ),
                        const Spacer(flex: 3),
                      ],
                    );
                  },
                ),

              if (!isLoading && museums.isNotEmpty) _buildUIOverlay(museums),
            ],
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MuseumFormPage(),
                      ),
                    ).then((_) {
                      museumProvider.fetchAllMuseums();
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.museum_outlined,
            size: 100,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada koleksi museum',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: const [Shadow(color: Colors.black87, blurRadius: 6)],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Koleksi museum akan muncul di sini',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              shadows: const [Shadow(color: Colors.black87, blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUIOverlay(List museums) {
    final currentMuseum = museums[_currentIndex];

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 12.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              currentMuseum.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black87, blurRadius: 6)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
