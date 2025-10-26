import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository repository;

  AuthProvider({required this.repository}) {
    _listenToAuthStateChanges();
  }

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void _listenToAuthStateChanges() {
    repository.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await repository.signInWithEmailAndPassword(
        email,
        password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await repository.signUpWithEmailAndPassword(
        email,
        password,
        name,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.signOut();
      _currentUser = null;
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

  Future<bool> updateProfilePhoto(String photoURL) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.updatePhotoURL(photoURL);
      _currentUser = await repository.getCurrentUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String name, String? photoURL) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.updateProfile(name, photoURL);
      _currentUser = await repository.getCurrentUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
