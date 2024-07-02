import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Timestamp timestamp;

  User({
    this.id = '', // Provide a default empty string for id
    required this.name,
    required this.email,
    required this.phone,
    required this.timestamp,
  });

  // Convert User object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'timestamp': timestamp,
    };
  }

  // Create a User object from a Firestore document
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      phone: doc['phone'],
      timestamp: doc['timestamp'],
    );
  }
}
