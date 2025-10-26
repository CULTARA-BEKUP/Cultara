import '../entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getCommentsByContentId(
    String contentId,
    String contentType,
  );
  Future<String> createComment(Comment comment);
  Future<void> updateComment(String id, String newComment);
  Future<void> deleteComment(String id);
}
