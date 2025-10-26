import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class ArticleProvider with ChangeNotifier {
  final ArticleRepository repository;

  ArticleProvider({required this.repository});

  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  Article? _selectedArticle;
  String _selectedCategory = 'Semua';
  bool _isLoading = false;
  String? _errorMessage;

  List<Article> get articles => _articles;
  List<Article> get filteredArticles => _filteredArticles;
  Article? get selectedArticle => _selectedArticle;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAllArticles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _articles = await repository.getAllArticles();
      _filteredArticles = _articles;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchArticleById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedArticle = await repository.getArticleById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == 'Semua') {
      _filteredArticles = _articles;
    } else {
      _filteredArticles = _articles
          .where((article) => article.category == category)
          .toList();
    }
    notifyListeners();
  }

  void searchArticles(String query) {
    if (query.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles = _articles
          .where(
            (article) =>
                article.title.toLowerCase().contains(query.toLowerCase()) ||
                article.location.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> createArticle(Article article) async {
    try {
      await repository.createArticle(article);
      await fetchAllArticles(); // Refresh list
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateArticle(Article article) async {
    try {
      await repository.updateArticle(article);
      await fetchAllArticles();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      await repository.deleteArticle(id);
      await fetchAllArticles(); 
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
