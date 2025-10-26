import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userModel = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userModel = await remoteDataSource.signUpWithEmailAndPassword(
        email,
        password,
        name,
      );
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return userModel?.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return remoteDataSource.authStateChanges.map(
      (userModel) => userModel?.toEntity(),
    );
  }

  @override
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      await remoteDataSource.updatePhotoURL(photoURL);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(String name, String? photoURL) async {
    try {
      await remoteDataSource.updateProfile(name, photoURL);
    } catch (e) {
      rethrow;
    }
  }
}
