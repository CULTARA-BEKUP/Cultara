import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> getEventById(String id);
  Future<List<EventModel>> getEventsByCategory(String category);
  Future<List<EventModel>> searchEvents(String query);

  // Admin CRUD
  Future<String> createEvent(EventModel event);
  Future<void> updateEvent(String id, EventModel event);
  Future<void> deleteEvent(String id);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final FirebaseFirestore firestore;

  EventRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      final querySnapshot = await firestore
          .collection('events')
          .orderBy('date', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  @override
  Future<EventModel> getEventById(String id) async {
    try {
      final doc = await firestore.collection('events').doc(id).get();

      if (!doc.exists) {
        throw Exception('Event not found');
      }

      return EventModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch event: $e');
    }
  }

  @override
  Future<List<EventModel>> getEventsByCategory(String category) async {
    try {
      final querySnapshot = await firestore
          .collection('events')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch events by category: $e');
    }
  }

  @override
  Future<List<EventModel>> searchEvents(String query) async {
    try {
      final querySnapshot = await firestore
          .collection('events')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search events: $e');
    }
  }

  @override
  Future<String> createEvent(EventModel event) async {
    try {
      final docRef = await firestore
          .collection('events')
          .add(event.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  @override
  Future<void> updateEvent(String id, EventModel event) async {
    try {
      await firestore.collection('events').doc(id).update(event.toFirestore());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await firestore.collection('events').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
