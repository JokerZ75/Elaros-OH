import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String text;
  final String user;
  final Timestamp timestamp;

  Comment({
    required this.text,
    required this.user,
    required this.timestamp,
  });


  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'user': user,
      // 'replies': replies,
      // 'likes': likes,
      // 'names': names,
      'timestamp': timestamp
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      text: map['text'] ?? '',
      user: map['user'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}
