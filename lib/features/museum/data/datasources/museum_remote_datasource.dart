import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/museum_model.dart';

abstract class MuseumRemoteDataSource {
  Future<List<MuseumModel>> getAllMuseums();
  Future<MuseumModel> getMuseumById(String id);
  Future<List<MuseumModel>> searchMuseums(String query);

  // Admin CRUD
  Future<String> createMuseum(MuseumModel museum);
  Future<void> updateMuseum(String id, MuseumModel museum);
  Future<void> deleteMuseum(String id);
}

class MuseumRemoteDataSourceImpl implements MuseumRemoteDataSource {
  final FirebaseFirestore firestore;

  MuseumRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<MuseumModel>> getAllMuseums() async {
    try {
      final querySnapshot = await firestore.collection('museums').get();

      return querySnapshot.docs
          .map((doc) => MuseumModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch museums: $e');
    }
  }

  @override
  Future<MuseumModel> getMuseumById(String id) async {
    try {
      final doc = await firestore.collection('museums').doc(id).get();

      if (!doc.exists) {
        throw Exception('Museum not found');
      }

      return MuseumModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch museum: $e');
    }
  }

  @override
  Future<List<MuseumModel>> searchMuseums(String query) async {
    try {
      final querySnapshot = await firestore
          .collection('museums')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => MuseumModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search museums: $e');
    }
  }

  @override
  Future<String> createMuseum(MuseumModel museum) async {
    try {
      final docRef = await firestore
          .collection('museums')
          .add(museum.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create museum: $e');
    }
  }

  @override
  Future<void> updateMuseum(String id, MuseumModel museum) async {
    try {
      await firestore
          .collection('museums')
          .doc(id)
          .update(museum.toFirestore());
    } catch (e) {
      throw Exception('Failed to update museum: $e');
    }
  }

  @override
  Future<void> deleteMuseum(String id) async {
    try {
      await firestore.collection('museums').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete museum: $e');
    }
  }
}
