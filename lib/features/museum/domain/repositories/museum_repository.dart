import '../entities/museum.dart';

abstract class MuseumRepository {
  Future<List<Museum>> getAllMuseums();
  Future<Museum> getMuseumById(String id);
  Future<List<Museum>> searchMuseums(String query);

  // Admin CRUD
  Future<String> createMuseum(Museum museum);
  Future<void> updateMuseum(String id, Museum museum);
  Future<void> deleteMuseum(String id);
}
