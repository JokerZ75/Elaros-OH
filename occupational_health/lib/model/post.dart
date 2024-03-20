import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:occupational_health/model/comment.dart';

class Post {
  // Attributes
  String? uid;
  final String user;
  final String postTitle;
  final String postContent;

  final List<dynamic> postComments;
  final Timestamp timestamp;

  final List<dynamic>? likes;

  Post({
    this.uid,
    required this.postTitle,
    required this.postContent,
    required this.postComments,
    required this.user,
    required this.timestamp,
    this.likes,
  });

  // Set Uid
  void setUid(String uid) {
    this.uid = uid;
  }

  Map<String, dynamic> toMap() {
    return {
      'postTitle': postTitle,
      'postContent': postContent,
      'postComments': postComments,
      'timestamp': timestamp,
      'likes': likes,
      'user': user,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
        uid: map["uid"],
        postTitle: map['postTitle'],
        postContent: map['postContent'],
        postComments: map["postComments"],
        timestamp: map['timestamp'],
        likes: map['likes'],
        user: map['user']);
  }
}
