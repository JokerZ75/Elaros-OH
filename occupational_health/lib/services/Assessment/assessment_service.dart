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
    notifyListeners();
    return _firestore
        .collection('assessments')
        .doc(_auth.currentUser!.uid)
        .collection("completed_questionaires")
        .snapshots();
  } // getQuestionaires

  // Get Questionaire Averages
  Future<Map<int, Map<String, double>>> getQuestionaireAverages() async {
    DateTime accountCreated = _auth.currentUser!.metadata.creationTime!;
    Map<int, Map<String, double>> sectionAverages = {};
    try {
      QuerySnapshot questionaires = await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .collection("completed_questionaires")
          .get();
      for (var doc in questionaires.docs) {
        var questionaire = doc['questionaire'] as Map<String, dynamic>;

        // Check how many months have passed since account created and questionaire was taken
        Timestamp questionaireDate = doc['timestamp'];
        int monthsPassed =
            questionaireDate.toDate().difference(accountCreated).inDays ~/ 30;

        // Round down to nearest multiple of 2 including 0
        monthsPassed = monthsPassed - (monthsPassed % 2);

        for (var section in questionaire.keys) {
          if (sectionAverages[monthsPassed] == null) {
            sectionAverages[monthsPassed] = {};
          }

          var questions = questionaire[section] as Map<String, dynamic>;
          double sectionTotal = 0;
          // Calculate the average for each section having 3 be the max value
          for (var question in questions.keys) {
            sectionTotal += questions[question].toDouble();
          }
          if (sectionTotal == 0) {
            sectionTotal = -1;
          }
          // if key does not exist, create it
          if (sectionAverages[monthsPassed]![section] == null) {
            sectionAverages[monthsPassed]![section] =
                sectionTotal / questions.length;
          } else {
            sectionAverages[monthsPassed]![section] =
                (sectionAverages[monthsPassed]![section]! +
                        sectionTotal / questions.length) /
                    2;
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return sectionAverages;
  } // getQuestionaireAverages
} // AssessmentService