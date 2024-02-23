import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/model/user.dart';

class AuthService extends ChangeNotifier {
  // instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // instance for the firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // create a new document for the user with the uid
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'uid': userCredential.user!.uid,
      }, SetOptions(merge: true));

      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  } // signInWithEmailAndPassword

  // Update Info

  Future<void> updateAccount(String? email, String? password,
      DateTime? dateOfBirth, String? occupation, String? name) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'email': email,
        'name': name,
        'dateOfBirth': dateOfBirth,
        'occupation': occupation,
        'password': password,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  } // signOut

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email,
      String password,
      DateTime dateOfBirth,
      String? occupation,
      String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create a new document for the user with the uid
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'dateOfBirth': dateOfBirth,
        'occupation': occupation,
        'email': email,
        'uid': userCredential.user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  } // registerWithEmailAndPassword

  // Get User Info
  Future<MyUser> getUserData() async {
    DocumentSnapshot userData;
    try {
      userData = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
    } catch (e) {
      print(e);
      MyUser empty = MyUser(uid: "", email: "error", name: "error", occupation: "error", dateOfBirth: DateTime(2022), timestamp: Timestamp.now());
      return empty;
    }

    // Convert to map
    MyUser  user = MyUser.fromMap(userData.data() as Map<String, dynamic>);
    return user;
  }
}
