import 'package:flutter/material.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';

class CommentProvider with ChangeNotifier {
  final CommentRepository repository;

  CommentProvider({required this.repository});

  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchComments(
    String contentId,
    String contentType, {
    String? userId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _comments = await repository.getCommentsByContentId(
        contentId,
        contentType,
      );


      if (userId != null && userId.isNotEmpty) {

        _comments.sort((a, b) {
          final aIsOwn = a.userId == userId;
          final bIsOwn = b.userId == userId;

          if (aIsOwn && !bIsOwn) {
            return -1;
          }
          if (!aIsOwn && bIsOwn) {
            return 1;
          }

          return b.createdAt.compareTo(a.createdAt);
        });

      } else {
        _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _comments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addComment(Comment comment, {String? userId}) async {
    try {
      _errorMessage = null;
      await repository.createComment(comment);

      await fetchComments(
        comment.contentId,
        comment.contentType,
        userId: userId,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateComment(
    String id,
    String newComment,
    String contentId,
    String contentType, {
    String? userId,
  }) async {
    try {
      _errorMessage = null;
      await repository.updateComment(id, newComment);

      await fetchComments(contentId, contentType, userId: userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteComment(
    String id,
    String contentId,
    String contentType, {
    String? userId,
  }) async {
    try {
      _errorMessage = null;
      await repository.deleteComment(id);

      await fetchComments(contentId, contentType, userId: userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
