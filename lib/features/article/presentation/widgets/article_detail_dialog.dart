import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/article.dart';
import '../providers/article_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../pages/article_form_page.dart';
import '../../../../shared/widgets/comment_section.dart';
import '../../../../shared/widgets/rating_widget.dart';
import 'package:intl/intl.dart';

void showArticleDetailDialog(BuildContext context, Article article) {
  final isAdmin = context.read<AuthProvider>().currentUser?.isAdmin ?? false;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  article.imagePath,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 64,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          article.author,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd MMM yyyy').format(article.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.visibility,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.views} views',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          article.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      article.content,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                  ],
                ),
              ),

              // Rating Widget
              RatingWidget(contentId: article.id, contentType: 'article'),

              // Comment Section
              CommentSection(contentId: article.id, contentType: 'article'),
            ],
          ),
        ),
        actions: [
          // Admin Actions
          if (isAdmin) ...[
            TextButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: dialogContext,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Artikel?'),
                    content: const Text('Yakin ingin menghapus artikel ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await context.read<ArticleProvider>().deleteArticle(
                    article.id,
                  );
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                }
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleFormPage(article: article),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
          ],

          // Close button
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      );
    },
  );
}
