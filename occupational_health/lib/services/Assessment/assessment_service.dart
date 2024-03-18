import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:occupational_health/model/questionaire.dart';
import 'package:occupational_health/model/questionaire_averages.dart';

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
      // Make a Averages document
      calculateAndUpdateAverages();
    } catch (e) {
      throw Exception(e);
    }
  } // saveQuestionaire

  Stream<QuerySnapshot> getQuestionairesStream() {
    notifyListeners();
    try {
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
          ? (
              questionaires.docs
                  .map((doc) =>
                      Questionaire.fromMap(doc.data() as Map<String, dynamic>))
                  .toList(),
              questionaires.docs.map((doc) => doc.id).toList()
            )
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
  Future<QuestionaireAverages> getQuestionaireAverages() async {
    try {
      DocumentSnapshot averages = await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .get();
      if (!averages.exists) {
        return QuestionaireAverages(
          monthlySectionAverages: {},
          overallAverages: {},
        );
      }
      

      QuestionaireAverages questionaireAverages =
          QuestionaireAverages.fromMap(averages.data() as Map<String, dynamic>);
        
      // Remove numberOfQuestionaires from monthlySectionAverages
      for (var month in questionaireAverages.monthlySectionAverages.keys) {
        questionaireAverages.monthlySectionAverages[month]!
            .remove("numberOfQuestionaires");
      }

      return questionaireAverages;
    } catch (e) {
      throw Exception(e);
    }
  } // getQuestionaireAverages

  // Private function to calculate Averages of each section.
  void calculateAndUpdateAverages() async {
    QuestionaireAverages averages = QuestionaireAverages(
      monthlySectionAverages: {},
      overallAverages: {},
    );

    // Get time of account creation for reference on months passed
    DateTime accountCreated = _auth.currentUser!.metadata.creationTime!;

    // Get all questionaires
    QuerySnapshot questionairesDocs = await _firestore
        .collection('assessments')
        .doc(_auth.currentUser!.uid)
        .collection("completed_questionaires")
        .get();

    // Convert questionaires to Questionaire objects for readability
    List<Questionaire> questionaires = questionairesDocs.docs
        .map((doc) => Questionaire.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    // Get total number of questionaires for later use
    int totalQuestionaires = questionaires.length;

    // Loop through each questionaire
    for (var currentQuestionaireDocument in questionaires) {
      // Check how many months have passed since account created and questionaire was taken
      Timestamp questionaireDate = currentQuestionaireDocument.timestamp;
      int monthsPassed =
          questionaireDate.toDate().difference(accountCreated).inDays ~/ 30;

      // Round down to nearest multiple of 2 including 0
      monthsPassed = monthsPassed - (monthsPassed % 2);

      String monthsPassedString = monthsPassed.toString();

      // If the month key does not exist, create it
      if (averages.monthlySectionAverages[monthsPassedString] == null) {
        averages.monthlySectionAverages[monthsPassedString] = {};
      }

      // Increment number of questionaires
      averages.monthlySectionAverages[monthsPassedString]!["numberOfQuestionaires"] =
          (averages.monthlySectionAverages[monthsPassedString]![
                      "numberOfQuestionaires"] ??
                  0) +
              1;

      // Loop through each section in the questionaire
      for (var section in currentQuestionaireDocument.questionaire.keys) {
        // Get the questions and answers for the section
        var questions = currentQuestionaireDocument.questionaire[section]
            as Map<String, dynamic>;

        // Calculate the average for each section having 3 be the max value
        double sectionTotal = 0;
        for (var question in questions.keys) {
          sectionTotal += questions[question].toDouble();
        }

        // If a key for that section does not exist, create it
        if (averages.monthlySectionAverages[monthsPassedString]![section] == null) {
          averages.monthlySectionAverages[monthsPassedString]![section] =
              sectionTotal / questions.length; // Average of month section
          averages.overallAverages[section] =
              sectionTotal / questions.length; // Overall average of section
        }
        // If a key for that section does exist, update it
        else {
          averages.monthlySectionAverages[monthsPassedString]![section] =
              (averages.monthlySectionAverages[monthsPassedString]![section]! +
                  sectionTotal /
                      questions.length); // Update average of month section
          averages.overallAverages[section] =
              (averages.overallAverages[section]! +
                  sectionTotal /
                      questions.length); // Update overall average of section
        }
      }
    }

    // Divide the averages by the number of questionaires to get the actual average and round to nearest whole number
    for (var month in averages.monthlySectionAverages.keys) {
      for (var section in averages.monthlySectionAverages[month]!.keys) {
        if (section != "numberOfQuestionaires") {
          averages.monthlySectionAverages[month]![section] = (averages
                      .monthlySectionAverages[month]![section]! /
                  averages
                      .monthlySectionAverages[month]!["numberOfQuestionaires"]!)
              .roundToDouble();
        }
      }
    }

    for (var section in averages.overallAverages.keys) {
      averages.overallAverages[section] =
          (averages.overallAverages[section]! / totalQuestionaires)
              .roundToDouble();
    }

    // Save the averages to the database
    try {
      await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .set(averages.toMap(), SetOptions(merge: true));
      print("Averages Updated");
    } catch (e) {
      throw Exception(e);
    }
  }
  // _calculateAverages
} // AssessmentService