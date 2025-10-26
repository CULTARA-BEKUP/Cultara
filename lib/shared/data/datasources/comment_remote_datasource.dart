import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getCommentsByContentId(
    String contentId,
    String contentType,
  );
  Future<String> createComment(CommentModel comment);
  Future<void> updateComment(String id, String newComment);
  Future<void> deleteComment(String id);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final FirebaseFirestore firestore;

  CommentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CommentModel>> getCommentsByContentId(
    String contentId,
    String contentType,
  ) async {
    try {
      final querySnapshot = await firestore
          .collection('comments')
          .where('contentId', isEqualTo: contentId)
          .where('contentType', isEqualTo: contentType)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CommentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  @override
  Future<String> createComment(CommentModel comment) async {
    try {
      final docRef = await firestore
          .collection('comments')
          .add(comment.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  @override
  Future<void> updateComment(String id, String newComment) async {
    try {
      await firestore.collection('comments').doc(id).update({
        'comment': newComment,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String id) async {
    try {
      await firestore.collection('comments').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}
