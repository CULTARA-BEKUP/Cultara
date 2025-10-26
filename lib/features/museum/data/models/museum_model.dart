import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/museum.dart';

class MuseumModel extends Museum {
  const MuseumModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
  });

  factory MuseumModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MuseumModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'image': image,
    };
  }

  Museum toEntity() {
    return Museum(
      id: id,
      name: name,
      description: description,
      image: image
    );
  }
}
