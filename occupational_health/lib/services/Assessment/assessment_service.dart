import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:occupational_health/model/questionaire.dart';

class AssessmentService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveQuestionaire(
      Map<String, Map<String, int>> questionaire) async {
    Questionaire newQuestionaire = Questionaire(
      questionaire: questionaire,
      timestamp: Timestamp.now(),
    );
    try {
      await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .collection("completed_questionaires")
          .add(newQuestionaire.toMap());
    } catch (e) {
      throw Exception(e);
    }
  } // saveQuestionaire

  Stream<QuerySnapshot> getQuestionaires() {
    return _firestore
        .collection('assessments')
        .doc(_auth.currentUser!.uid)
        .collection("completed_questionaires")
        .snapshots();
  } // getQuestionaires



} // AssessmentService