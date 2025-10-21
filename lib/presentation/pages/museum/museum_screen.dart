import 'package:cultara/data/dummy/museum_dummy.dart';
import 'package:cultara/presentation/pages/museum/widgets/framed_painting_widget.dart';
import 'package:cultara/presentation/pages/museum/widgets/museum_detail_dialog.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          PageView.builder(
            controller: _pageController,
            itemCount: museumsData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final museum = museumsData[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  GestureDetector(
                    onTap: () => showMuseumDetailDialog(context, museum),
                    child: FramedPainting(museum: museum),
                  ),
                  const Spacer(flex: 3),
                ],
              );
            },
          ),

          _buildUIOverlay(),
        ],
      ),
    );
  }

  Widget _buildUIOverlay() {
    final currentMuseum = museumsData[_currentIndex];

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
