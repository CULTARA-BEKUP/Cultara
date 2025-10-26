import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String date;
  final String time;
  final String price;
  final double rating;
  final String imageCover;
  final List<String> imageOther;
  final List<String> highlights;
  final String phone;
  final String website;
  final double latitude;
  final double longitude;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.rating,
    required this.imageCover,
    required this.imageOther,
    required this.highlights,
    required this.phone,
    required this.website,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    location,
    date,
    time,
    price,
    rating,
    imageCover,
    imageOther,
    highlights,
    phone,
    website,
    latitude,
    longitude,
  ];
}
