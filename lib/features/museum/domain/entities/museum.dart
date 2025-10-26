import 'package:equatable/equatable.dart';

class Museum extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;

  const Museum({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    image,
  ];
}
