import '../entities/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getAllArticles();
  Future<Article> getArticleById(String id);
  Future<List<Article>> getArticlesByCategory(String category);
  Future<List<Article>> searchArticles(String query);
  Future<void> createArticle(Article article);
  Future<void> updateArticle(Article article);
  Future<void> deleteArticle(String id);
}
