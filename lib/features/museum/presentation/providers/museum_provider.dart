import 'package:flutter/material.dart';
import '../../domain/entities/museum.dart';
import '../../domain/repositories/museum_repository.dart';

class MuseumProvider with ChangeNotifier {
  Future<void> deleteMuseum(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await repository.deleteMuseum(id);
      await fetchAllMuseums();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  final MuseumRepository repository;

  MuseumProvider({required this.repository});

  List<Museum> _museums = [];
  Museum? _selectedMuseum;
  bool _isLoading = false;
  String? _errorMessage;

  List<Museum> get museums => _museums;
  Museum? get selectedMuseum => _selectedMuseum;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAllMuseums() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _museums = await repository.getAllMuseums();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMuseumById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedMuseum = await repository.getMuseumById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMuseums(String query) async {
    if (query.isEmpty) {
      await fetchAllMuseums();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _museums = await repository.searchMuseums(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
