import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:occupational_health/model/post.dart';
import 'package:occupational_health/model/comment.dart';

class ForumService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> savePostWithDefaults(Post post) async {
    try {
      await _firestore.collection('posts').doc().set(post.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot> getPostsStream() {
    try {
      return _firestore.collection('posts').snapshots();
    } catch (e) {
      return Stream.empty();
    }
  }

  // Toggle Like
  Future<void> toggleLike(String? postId, List<dynamic>? likes) async {
    if (likes!.contains(_auth.currentUser!.uid)) {
      likes.remove(_auth.currentUser!.uid);
    } else {
      likes.add(_auth.currentUser!.uid);
    }
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .set({"likes": likes}, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveComment(String postId, List<dynamic> updatedComments) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .set({"postComments": updatedComments}, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get most recent post
  Stream<QuerySnapshot> getMostRecent()  {
    try {
      final post =  _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots();
      return post;

    } catch (e) {
      throw Exception(e);
    }
  }
}
