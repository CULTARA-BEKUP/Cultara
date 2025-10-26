import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Event>> getAllEvents() async {
    try {
      final eventModels = await remoteDataSource.getAllEvents();
      return eventModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get all events - $e');
    }
  }

  @override
  Future<Event> getEventById(String id) async {
    try {
      final eventModel = await remoteDataSource.getEventById(id);
      return eventModel.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get event by id - $e');
    }
  }

  @override
  Future<List<Event>> getEventsByCategory(String category) async {
    try {
      final eventModels = await remoteDataSource.getEventsByCategory(category);
      return eventModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get events by category - $e');
    }
  }

  @override
  Future<List<Event>> searchEvents(String query) async {
    try {
      final eventModels = await remoteDataSource.searchEvents(query);
      return eventModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to search events - $e');
    }
  }

  @override
  Future<void> createEvent(Event event) async {
    try {
      final eventModel = EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        category: event.category,
        location: event.location,
        date: event.date,
        time: event.time,
        price: event.price,
        rating: event.rating,
        imageCover: event.imageCover,
        imageOther: event.imageOther,
        highlights: event.highlights,
        phone: event.phone,
        website: event.website,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      await remoteDataSource.createEvent(eventModel);
    } catch (e) {
      throw Exception('Repository: Failed to create event - $e');
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    try {
      final eventModel = EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        category: event.category,
        location: event.location,
        date: event.date,
        time: event.time,
        price: event.price,
        rating: event.rating,
        imageCover: event.imageCover,
        imageOther: event.imageOther,
        highlights: event.highlights,
        phone: event.phone,
        website: event.website,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      await remoteDataSource.updateEvent(event.id, eventModel);
    } catch (e) {
      throw Exception('Repository: Failed to update event - $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await remoteDataSource.deleteEvent(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete event - $e');
    }
  }
}
