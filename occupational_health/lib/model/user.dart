import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  final String email;
  final String name;
  final String? occupation;
  final DateTime dateOfBirth;
  final Timestamp timestamp;

  MyUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.occupation,
    required this.dateOfBirth,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'occupation': occupation,
      'dateOfBirth': dateOfBirth,
      'timestamp': timestamp
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      occupation: map['occupation'],
      dateOfBirth: map['dateOfBirth'].toDate(),
      timestamp: map['timestamp'],
    );
  }

}