import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/entities/comment.dart';
import '../data/models/comment_model.dart';
import '../data/datasources/comment_remote_datasource.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentSection extends StatefulWidget {
  final String contentId;
  final String contentType; // 'museum', 'event', 'article'

  const CommentSection({
    super.key,
    required this.contentId,
    required this.contentType,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late CommentRemoteDataSource _commentDataSource;
  final _commentController = TextEditingController();
  bool _isLoading = false;
  List<Comment> _comments = [];
  Comment? _editingComment;

  @override
  void initState() {
    super.initState();
    _commentDataSource = CommentRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
    _loadComments();

    // Setup Indonesian timeago messages
    timeago.setLocaleMessages('id', timeago.IdMessages());
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final currentUser = authProvider.currentUser;

      final comments = await _commentDataSource.getCommentsByContentId(
        widget.contentId,
        widget.contentType,
      );


      // Sort: Pin user's own comment at the top, then sort by newest
      if (currentUser != null) {

        comments.sort((a, b) {
          // User's own comments come first
          final aIsOwn = a.userId == currentUser.id;
          final bIsOwn = b.userId == currentUser.id;

          if (aIsOwn && !bIsOwn) {
            return -1;
          }
          if (!aIsOwn && bIsOwn) {
            return 1;
          }

          // If both are user's or both are not, sort by newest first
          return b.createdAt.compareTo(a.createdAt);
        });

      } else {
        // If no user logged in, just sort by newest
        comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading comments: $e')));
      }
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_editingComment != null) {
        // Update existing comment
        await _commentDataSource.updateComment(
          _editingComment!.id,
          _commentController.text.trim(),
        );
      } else {
        // Create new comment
        final comment = CommentModel(
          id: '',
          contentId: widget.contentId,
          contentType: widget.contentType,
          userId: currentUser.id,
          userName: currentUser.name,
          userPhotoUrl: currentUser.photoUrl,
          comment: _commentController.text.trim(),
          createdAt: DateTime.now(),
        );
        await _commentDataSource.createComment(comment);
      }

      _commentController.clear();
      setState(() => _editingComment = null);
      await _loadComments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Komentar?'),
        content: const Text('Yakin ingin menghapus komentar ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _commentDataSource.deleteComment(comment.id);
        await _loadComments();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startEditing(Comment comment) {
    setState(() {
      _editingComment = comment;
      _commentController.text = comment.comment;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingComment = null;
      _commentController.clear();
    });
  }

  // Generate color based on name
  Color _getColorFromName(String name) {
    final colors = [
      const Color(0xFFE57373), // Red
      const Color(0xFFBA68C8), // Purple
      const Color(0xFF64B5F6), // Blue
      const Color(0xFF4DB6AC), // Teal
      const Color(0xFF81C784), // Green
      const Color(0xFFFFD54F), // Amber
      const Color(0xFFFF8A65), // Deep Orange
      const Color(0xFF9575CD), // Deep Purple
      const Color(0xFF4FC3F7), // Light Blue
      const Color(0xFF4DD0E1), // Cyan
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.comment, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Komentar (${_comments.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Comment Input
        if (currentUser != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_editingComment != null)
                  Row(
                    children: [
                      const Icon(Icons.edit, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      const Text(
                        'Edit komentar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _cancelEditing,
                        child: const Text('Batal'),
                      ),
                    ],
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: currentUser.name.isNotEmpty
                          ? _getColorFromName(currentUser.name)
                          : Colors.red,
                      backgroundImage:
                          currentUser.photoUrl != null &&
                              currentUser.photoUrl!.isNotEmpty
                          ? NetworkImage(currentUser.photoUrl!)
                          : null,
                      child:
                          (currentUser.photoUrl == null ||
                              currentUser.photoUrl!.isEmpty)
                          ? Text(
                              currentUser.name.isNotEmpty
                                  ? currentUser.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(color: Colors.white),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Tulis komentar...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _submitComment(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _isLoading ? null : _submitComment,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // Comments List
        if (_isLoading && _comments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_comments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser == null
                        ? 'Login untuk memberikan komentar'
                        : 'Belum ada komentar',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _comments.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final comment = _comments[index];
              final isOwner = currentUser?.id == comment.userId;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: comment.userName.isNotEmpty
                      ? _getColorFromName(comment.userName)
                      : Colors.red,
                  backgroundImage:
                      comment.userPhotoUrl != null &&
                          comment.userPhotoUrl!.isNotEmpty
                      ? NetworkImage(comment.userPhotoUrl!)
                      : null,
                  child:
                      (comment.userPhotoUrl == null ||
                          comment.userPhotoUrl!.isEmpty)
                      ? Text(
                          comment.userName.isNotEmpty
                              ? comment.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(color: Colors.white),
                        )
                      : null,
                ),
                title: Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (isOwner) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Anda',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      timeago.format(comment.createdAt, locale: 'id'),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    if (comment.updatedAt != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(edited)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    comment.comment,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                trailing: isOwner
                    ? PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _startEditing(comment);
                          } else if (value == 'delete') {
                            _deleteComment(comment);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : null,
              );
            },
          ),
      ],
    );
  }
}
