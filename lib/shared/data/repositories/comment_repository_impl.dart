import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_datasource.dart';
import '../models/comment_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Comment>> getCommentsByContentId(
    String contentId,
    String contentType,
  ) async {
    try {
      final commentModels = await remoteDataSource.getCommentsByContentId(
        contentId,
        contentType,
      );
      return commentModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  @override
  Future<String> createComment(Comment comment) async {
    try {
      final commentModel = CommentModel(
        id: comment.id,
        contentId: comment.contentId,
        contentType: comment.contentType,
        userId: comment.userId,
        userName: comment.userName,
        userPhotoUrl: comment.userPhotoUrl,
        comment: comment.comment,
        createdAt: comment.createdAt,
        updatedAt: comment.updatedAt,
      );
      return await remoteDataSource.createComment(commentModel);
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  @override
  Future<void> updateComment(String id, String newComment) async {
    try {
      await remoteDataSource.updateComment(id, newComment);
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String id) async {
    try {
      await remoteDataSource.deleteComment(id);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}
