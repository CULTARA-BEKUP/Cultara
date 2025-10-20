import 'package:flutter/material.dart';
import 'package:cultara/presentation/pages/event/widgets/event_image_header.dart';
import 'package:cultara/presentation/pages/event/widgets/event_title_section.dart';
import 'package:cultara/presentation/pages/event/widgets/event_info_section.dart';
import 'package:cultara/presentation/pages/event/widgets/event_highlights.dart';
import 'package:cultara/presentation/pages/event/widgets/event_contact_info.dart';
import 'package:cultara/presentation/pages/event/widgets/event_map_section.dart';
import 'package:cultara/presentation/pages/event/widgets/review_bottom_sheet.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  int currentImageIndex = 0;
  late PageController _pageController;
  late List<String> allImages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    allImages = [
      widget.event['imageCover'],
      ...List<String>.from(widget.event['imageOther'] ?? []),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E3F),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventImageHeader(
                  images: allImages,
                  pageController: _pageController,
                  currentIndex: currentImageIndex,
                  onPageChanged: (index) {
                    setState(() {
                      currentImageIndex = index;
                    });
                  },
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventTitleSection(
                        title: widget.event['title'],
                        location: widget.event['location'],
                        rating: widget.event['rating'] ?? 4.0,
                      ),
                      const SizedBox(height: 11),
                      EventInfoSection(
                        date: widget.event['date'],
                        time: widget.event['time'],
                        onReviewTap: _showReviewBottomSheet,
                      ),
                      const SizedBox(height: 24),
                      EventHighlights(
                        highlights: widget.event['highlights'] as List,
                      ),
                      const SizedBox(height: 24),
                      EventContactInfo(
                        phone: widget.event['phone'],
                        website: widget.event['website'],
                      ),
                      const SizedBox(height: 24),
                      EventMapSection(
                        latitude: widget.event['latitude'] ?? 0.0,
                        longitude: widget.event['longitude'] ?? 0.0,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ReviewBottomSheet(rating: widget.event['rating'] ?? 4.0),
    );
  }
}
