import 'package:flutter/material.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

class EventProvider with ChangeNotifier {
  final EventRepository repository;

  EventProvider({required this.repository});

  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  Event? _selectedEvent;
  String _selectedCategory = 'Semua';
  bool _isLoading = false;
  String? _errorMessage;

  List<Event> get events => _events;
  List<Event> get filteredEvents => _filteredEvents;
  Event? get selectedEvent => _selectedEvent;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Event> get popularEvents {
    final sorted = List<Event>.from(_events);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }

  Future<void> fetchAllEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _events = await repository.getAllEvents();
      _filteredEvents = _events;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEventById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedEvent = await repository.getEventById(id);
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
      _filteredEvents = _events;
    } else {
      _filteredEvents = _events
          .where((event) => event.category == category)
          .toList();
    }
    notifyListeners();
  }

  void searchEvents(String query) {
    if (query.isEmpty) {
      _filteredEvents = _events;
    } else {
      _filteredEvents = _events
          .where(
            (event) =>
                event.title.toLowerCase().contains(query.toLowerCase()) ||
                event.location.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // CRUD Operations for Admin
  Future<void> createEvent(Event event) async {
    try {
      await repository.createEvent(event);
      await fetchAllEvents(); 
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await repository.updateEvent(event);
      await fetchAllEvents(); 
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await repository.deleteEvent(id);
      await fetchAllEvents(); 
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
