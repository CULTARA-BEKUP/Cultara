import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.location,
    required super.date,
    required super.time,
    required super.price,
    required super.rating,
    required super.imageCover,
    required super.imageOther,
    required super.highlights,
    required super.phone,
    required super.website,
    required super.latitude,
    required super.longitude,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      price: data['price'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      imageCover: data['imageCover'] ?? '',
      imageOther: List<String>.from(data['imageOther'] ?? []),
      highlights: List<String>.from(data['highlights'] ?? []),
      phone: data['phone'] ?? '',
      website: data['website'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'date': date,
      'time': time,
      'price': price,
      'rating': rating,
      'imageCover': imageCover,
      'imageOther': imageOther,
      'highlights': highlights,
      'phone': phone,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      category: category,
      location: location,
      date: date,
      time: time,
      price: price,
      rating: rating,
      imageCover: imageCover,
      imageOther: imageOther,
      highlights: highlights,
      phone: phone,
      website: website,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
