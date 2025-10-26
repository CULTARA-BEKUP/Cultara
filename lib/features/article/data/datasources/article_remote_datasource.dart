import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article_model.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getAllArticles();
  Future<ArticleModel> getArticleById(String id);
  Future<List<ArticleModel>> getArticlesByCategory(String category);
  Future<List<ArticleModel>> searchArticles(String query);

  Future<String> createArticle(ArticleModel article);
  Future<void> updateArticle(String id, ArticleModel article);
  Future<void> deleteArticle(String id);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final FirebaseFirestore firestore;

  ArticleRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ArticleModel>> getAllArticles() async {
    try {
      final querySnapshot = await firestore
          .collection('articles')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  @override
  Future<ArticleModel> getArticleById(String id) async {
    try {
      final doc = await firestore.collection('articles').doc(id).get();

      if (!doc.exists) {
        throw Exception('Article not found');
      }

      return ArticleModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch article: $e');
    }
  }

  @override
  Future<List<ArticleModel>> getArticlesByCategory(String category) async {
    try {
      final querySnapshot = await firestore
          .collection('articles')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch articles by category: $e');
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles(String query) async {
    try {
      final querySnapshot = await firestore
          .collection('articles')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search articles: $e');
    }
  }

  @override
  Future<String> createArticle(ArticleModel article) async {
    try {
      final docRef = await firestore
          .collection('articles')
          .add(article.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create article: $e');
    }
  }

  @override
  Future<void> updateArticle(String id, ArticleModel article) async {
    try {
      await firestore
          .collection('articles')
          .doc(id)
          .update(article.toFirestore());
    } catch (e) {
      throw Exception('Failed to update article: $e');
    }
  }

  @override
  Future<void> deleteArticle(String id) async {
    try {
      await firestore.collection('articles').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }
}
