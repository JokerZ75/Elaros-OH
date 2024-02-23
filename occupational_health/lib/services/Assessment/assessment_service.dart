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

  Stream<QuerySnapshot> getQuestionairesStream() {
    notifyListeners();
    try{
    return _firestore
        .collection('assessments')
        .doc(_auth.currentUser!.uid)
        .collection("completed_questionaires")
        .snapshots();
    } catch (e) {
      return Stream.empty();
    }
  } // getQuestionaires

  Future<QuerySnapshot> getQuestionaires() async {
    try {
      return await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .collection("completed_questionaires")
          .get();
    } catch (e) {
      throw Exception(e);
    }
  } // getQuestionaires

  // Get 3 most recent questionaires
  Future<(List<Questionaire>, List<String>)> getRecentQuestionaires() async {
    try {
      QuerySnapshot questionaires = await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .collection("completed_questionaires")
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();
      return questionaires.docs.isNotEmpty
          ? (questionaires.docs
              .map((doc) => Questionaire.fromMap(
                  doc.data() as Map<String, dynamic>))
              .toList(), questionaires.docs.map((doc) => doc.id).toList())
          : (List<Questionaire>.empty(), List<String>.empty());
    } catch (e) {
      throw Exception(e);
    }
  } // getRecentQuestionaires

  // Get single questionaire by id
  Future<Questionaire> getQuestionaireById(String id) async {
    try {
      DocumentSnapshot questionaire = await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .collection("completed_questionaires")
          .doc(id)
          .get();
      return questionaire.exists
          ? Questionaire.fromMap(questionaire.data() as Map<String, dynamic>)
          : throw Exception("Questionaire does not exist");
    } catch (e) {
      throw Exception(e);
    }
  } // getQuestionaireById

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