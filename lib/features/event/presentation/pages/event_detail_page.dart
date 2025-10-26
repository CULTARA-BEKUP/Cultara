import 'package:flutter/material.dart';
import 'package:cultara/features/event/presentation/widgets/event_image_header.dart';
import 'package:cultara/features/event/presentation/widgets/event_title_section.dart';
import 'package:cultara/features/event/presentation/widgets/event_info_section.dart';
import 'package:cultara/features/event/presentation/widgets/event_highlights.dart';
import 'package:cultara/features/event/presentation/widgets/event_contact_info.dart';
import 'package:cultara/features/event/presentation/widgets/event_map_section.dart';
import 'package:cultara/features/article/presentation/widgets/detail_review_tab.dart';
import 'package:cultara/shared/presentation/providers/comment_provider.dart';
import 'package:cultara/shared/presentation/providers/rating_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cultara/shared/data/datasources/comment_remote_datasource.dart';
import 'package:cultara/shared/data/repositories/comment_repository_impl.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentProvider>().fetchComments(
        widget.event['id'],
        'event',
      );
      context.read<RatingProvider>().fetchRatings(widget.event['id'], 'event');
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommentProvider, RatingProvider>(
      builder: (context, commentProvider, ratingProvider, _) {
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
                            rating: ratingProvider.averageRating,
                          ),
                          const SizedBox(height: 11),
                          EventInfoSection(
                            date: widget.event['date'],
                            time: widget.event['time'],
                            onReviewTap: () => _showCommentSection(context),
                          ),
                          const SizedBox(height: 24),
                          EventHighlights(
                            highlights:
                                widget.event['highlights'] as List<dynamic>,
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
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCommentSection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 6),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ChangeNotifierProvider(
                      create: (_) => CommentProvider(
                        repository: CommentRepositoryImpl(
                          remoteDataSource: CommentRemoteDataSourceImpl(
                            firestore: FirebaseFirestore.instance,
                          ),
                        ),
                      ),
                      child: DetailReviewTab(
                        contentId: widget.event['id'],
                        contentType: 'event',
                        scrollController: scrollController,
                        onRatingUpdated: () {
                          context.read<RatingProvider>().fetchRatings(
                            widget.event['id'],
                            'event',
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
