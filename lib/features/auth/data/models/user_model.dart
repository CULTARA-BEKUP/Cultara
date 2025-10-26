import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.photoUrl,
    super.role,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'User',
      photoUrl: firebaseUser.photoURL,
      role: 'user', 
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? 'User',
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'email': email, 'name': name, 'photoUrl': photoUrl, 'role': role};
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      role: role,
    );
  }
}
