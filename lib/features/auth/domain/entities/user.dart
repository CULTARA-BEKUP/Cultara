import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String role; 
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.role = 'user', 
  });

  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';

  @override
  List<Object?> get props => [id, email, name, photoUrl, role];
}
