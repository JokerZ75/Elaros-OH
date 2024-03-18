import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class RehabilitationService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getRehabilitationStream() {
    try {
      return _firestore.collection('rehabilitation').snapshots();
    } catch (e) {
      return const Stream.empty();
    }
  } // getRehabilitationStream

  // Fetch Rehabilitation Content
  Future<List<QueryDocumentSnapshot>> getRehabilitationContent() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('rehabilitation').get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception(e);
    }
  } // getRehabilitationContent



  Future<void> addLastViewedLocalStorage(String name, String url) async {
    try {
      LocalStorage storage = LocalStorage('rehabilitation');
      await storage.ready;
      List<dynamic> data = storage.getItem('lastViewed') ?? [];
      // if item already exists, do nothing
      for (var item in data) {
        if (item['Name'] == name) {
          return;
        }
      }
      // Make sure data only has 2 items
      if (data.length == 2) {
        data.removeAt(0);
      }
      data.add({'Name': name, 'URL': url});
      storage.setItem('lastViewed', data);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  } // LastViewedLocalStorage

  Future<List<dynamic>> getLastViewedLocalStorage() async {
    try {
      LocalStorage storage = LocalStorage('rehabilitation');
      await storage.ready;
      List<dynamic> data = storage.getItem('lastViewed') ?? [];
      return data;
    } catch (e) {
      throw Exception(e);
    }
  } // getLastViewedLocalStorage
}
