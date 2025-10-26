import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Preset empty states
class EmptyMuseumState extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const EmptyMuseumState({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.museum_outlined,
      title: 'Belum Ada Museum',
      message: 'Belum ada koleksi artifacts budaya yang ditambahkan.',
      actionLabel: onAddPressed != null ? 'Tambah Museum' : null,
      onActionPressed: onAddPressed,
    );
  }
}

class EmptyEventState extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const EmptyEventState({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.event_outlined,
      title: 'Belum Ada Event',
      message: 'Belum ada event budaya yang tersedia.',
      actionLabel: onAddPressed != null ? 'Tambah Event' : null,
      onActionPressed: onAddPressed,
    );
  }
}

class EmptyArticleState extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const EmptyArticleState({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.article_outlined,
      title: 'Belum Ada Artikel',
      message: 'Belum ada artikel yang dipublikasikan.',
      actionLabel: onAddPressed != null ? 'Tambah Artikel' : null,
      onActionPressed: onAddPressed,
    );
  }
}

class EmptyCommentState extends StatelessWidget {
  const EmptyCommentState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.comment_outlined,
      title: 'Belum Ada Komentar',
      message: 'Jadilah yang pertama memberikan komentar!',
    );
  }
}

class EmptyRatingState extends StatelessWidget {
  const EmptyRatingState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.star_outline,
      title: 'Belum Ada Rating',
      message: 'Jadilah yang pertama memberikan rating!',
    );
  }
}

class EmptySearchState extends StatelessWidget {
  final String query;

  const EmptySearchState({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'Tidak Ditemukan',
      message: 'Tidak ada hasil untuk "$query"',
    );
  }
}
