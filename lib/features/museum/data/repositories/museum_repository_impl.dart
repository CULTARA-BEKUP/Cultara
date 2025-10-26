import '../../domain/entities/museum.dart';
import '../../domain/repositories/museum_repository.dart';
import '../datasources/museum_remote_datasource.dart';
import '../models/museum_model.dart';

class MuseumRepositoryImpl implements MuseumRepository {
  final MuseumRemoteDataSource remoteDataSource;

  MuseumRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Museum>> getAllMuseums() async {
    try {
      final museumModels = await remoteDataSource.getAllMuseums();
      return museumModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get all museums - $e');
    }
  }

  @override
  Future<Museum> getMuseumById(String id) async {
    try {
      final museumModel = await remoteDataSource.getMuseumById(id);
      return museumModel.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get museum by id - $e');
    }
  }

  @override
  Future<List<Museum>> searchMuseums(String query) async {
    try {
      final museumModels = await remoteDataSource.searchMuseums(query);
      return museumModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to search museums - $e');
    }
  }

  @override
  Future<String> createMuseum(Museum museum) async {
    try {
      final museumModel = MuseumModel(
        id: '',
        name: museum.name,
        description: museum.description,
        image: museum.image,
      );
      return await remoteDataSource.createMuseum(museumModel);
    } catch (e) {
      throw Exception('Repository: Failed to create museum - $e');
    }
  }

  @override
  Future<void> updateMuseum(String id, Museum museum) async {
    try {
      final museumModel = MuseumModel(
        id: id,
        name: museum.name,
        description: museum.description,
        image: museum.image,
      );
      await remoteDataSource.updateMuseum(id, museumModel);
    } catch (e) {
      throw Exception('Repository: Failed to update museum - $e');
    }
  }

  @override
  Future<void> deleteMuseum(String id) async {
    try {
      await remoteDataSource.deleteMuseum(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete museum - $e');
    }
  }
}
