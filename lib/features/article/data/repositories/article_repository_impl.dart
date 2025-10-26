import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_remote_datasource.dart';
import '../models/article_model.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;

  ArticleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Article>> getAllArticles() async {
    try {
      final articleModels = await remoteDataSource.getAllArticles();
      return articleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get all articles - $e');
    }
  }

  @override
  Future<Article> getArticleById(String id) async {
    try {
      final articleModel = await remoteDataSource.getArticleById(id);
      return articleModel.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get article by id - $e');
    }
  }

  @override
  Future<List<Article>> getArticlesByCategory(String category) async {
    try {
      final articleModels = await remoteDataSource.getArticlesByCategory(
        category,
      );
      return articleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get articles by category - $e');
    }
  }

  @override
  Future<List<Article>> searchArticles(String query) async {
    try {
      final articleModels = await remoteDataSource.searchArticles(query);
      return articleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to search articles - $e');
    }
  }

  @override
  Future<void> createArticle(Article article) async {
    try {
      final articleModel = ArticleModel(
        id: article.id,
        title: article.title,
        category: article.category,
        location: article.location,
        content: article.content,
        imagePath: article.imagePath,
        author: article.author,
        createdAt: article.createdAt,
        views: article.views,
        brief: article.brief,
        galleryImages: article.galleryImages,
      );
      await remoteDataSource.createArticle(articleModel);
    } catch (e) {
      throw Exception('Repository: Failed to create article - $e');
    }
  }

  @override
  Future<void> updateArticle(Article article) async {
    try {
      final articleModel = ArticleModel(
        id: article.id,
        title: article.title,
        category: article.category,
        location: article.location,
        content: article.content,
        imagePath: article.imagePath,
        author: article.author,
        createdAt: article.createdAt,
        views: article.views,
        brief: article.brief,
        galleryImages: article.galleryImages,
      );
      await remoteDataSource.updateArticle(article.id, articleModel);
    } catch (e) {
      throw Exception('Repository: Failed to update article - $e');
    }
  }

  @override
  Future<void> deleteArticle(String id) async {
    try {
      await remoteDataSource.deleteArticle(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete article - $e');
    }
  }
}
