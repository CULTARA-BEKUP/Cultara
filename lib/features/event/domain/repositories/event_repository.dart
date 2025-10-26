import '../entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getAllEvents();
  Future<Event> getEventById(String id);
  Future<List<Event>> getEventsByCategory(String category);
  Future<List<Event>> searchEvents(String query);
  Future<void> createEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);
}
