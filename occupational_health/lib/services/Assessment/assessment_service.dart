import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:occupational_health/model/questionaire.dart';
import 'package:occupational_health/model/questionaire_averages.dart';
import 'package:geolocator/geolocator.dart';

class AssessmentService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if current user has taken onboarding questionaire
  Future<bool> hasTakenOnboardingQuestionaire() async {
    try {
      final assessmentData = await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .get();

      final data = assessmentData.data();
      if (data == null) {
        return false;
      }

      // check if onboarding_questionaire exists
      return data.containsKey('onboarding_questionaire');
    } catch (e) {
      throw Exception(e);
    }
  } // hasTakenOnboardingQuestionaire

  // Save onboarding questionaire
  Future<void> saveOnboardingQuestionaire(
      Map<String, Map<String, int>> questionaire) async {
    Questionaire newQuestionaire = Questionaire(
      questionaire: questionaire,
      timestamp: Timestamp.now(),
    );
    try {
      await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .set({
        'onboarding_questionaire': newQuestionaire.toMap(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  } // saveOnboardingQuestionaire

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
      _calculateAndUpdateAverages();
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

  Future<Map<GeoPoint, List<Questionaire>>>
      getQuestionairesFromUsersWithLocation() async {
    Map<GeoPoint, List<Questionaire>> questionaires = {};
    List<Questionaire> temp = [];
    Map<String, String> geoPoints = {};
    Map<String, List<Questionaire>> locationQuestionaire = {};
    try {
      final users = await _firestore
          .collection('users')
          .where('location', isNotEqualTo: null)
          .get();
      for (var user in users.docs) {
        final userdata = user.data();
        if (userdata['location'] == null) {
          continue;
        }

        // Put userID in a map with the location as the key
        final userLocation = userdata['location'] as GeoPoint;
        if (!geoPoints.containsKey(
                "${userLocation.latitude}, ${userLocation.longitude}") ||
            geoPoints.isEmpty) {
          geoPoints["${userLocation.latitude}, ${userLocation.longitude}"] =
              user.id;
        }
      }

      Map<String, List<String>> locationUsers = {};

      for (var geoPoint1 in geoPoints.keys) {
        for (var geoPoint2 in geoPoints.keys) {
          // If geo point 1 is within 1000m of geo point 2
          if (Geolocator.distanceBetween(
                  double.parse(geoPoint1.split(", ")[0]),
                  double.parse(geoPoint1.split(", ")[1]),
                  double.parse(geoPoint2.split(", ")[0]),
                  double.parse(geoPoint2.split(", ")[1])) <=
              1000) {
            // If the locationUsers map does not contain the key
            if (!locationUsers.containsKey(geoPoint1)) {
              locationUsers[geoPoint1] = [geoPoints[geoPoint2]!];
            } else {
              locationUsers[geoPoint1]!.add(geoPoints[geoPoint2]!);
            }
          }
        }
      }

      Map<String, List<String>> locationUsersCopy = Map.from(locationUsers);
      // Alrady deleted locations
      List<List<String>> lastDeleted = [];

      // if locations have the same array values remove the duplicate
      for (var location in locationUsersCopy.keys) {
        for (var location2 in locationUsersCopy.keys) {
          if (locationUsersCopy[location]!.every((element) =>
                  locationUsersCopy[location2]!.contains(element)) &&
              location != location2 &&
              locationUsersCopy[location]!.length > 1) {
            // if array is in last deleted
            if (lastDeleted.contains(locationUsersCopy[location]!)) {
              continue;
            }
            locationUsers.remove(location2);
            lastDeleted.add(locationUsersCopy[location2]!);
          }
        }
      }

      // If an array has less than 3 users remove it
      locationUsersCopy = Map.from(locationUsers);
      for (var location in locationUsersCopy.keys) {
        if (locationUsersCopy[location]!.length < 3) {
          locationUsers.remove(location);
        }
      }

      for (var location in locationUsers.keys) {
        for (var user in locationUsers[location]!) {
          final questionairesDocs = await _firestore
              .collection('assessments')
              .doc(user)
              .collection("completed_questionaires")
              .get();
          temp = questionairesDocs.docs
              .map((doc) =>
                  Questionaire.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          if (questionaires.containsKey(GeoPoint(
              double.parse(location.split(", ")[0]),
              double.parse(location.split(", ")[1])))) {
            questionaires[GeoPoint(double.parse(location.split(", ")[0]),
                    double.parse(location.split(", ")[1]))]!
                .addAll(temp);
          } else {
            questionaires[GeoPoint(double.parse(location.split(", ")[0]),
                double.parse(location.split(", ")[1]))] = temp;
          }
        }
      }

      return questionaires;
    } catch (e) {
      throw Exception(e);
    }
  }

  // get most recent post
  Future<Questionaire> getMostRecentQuestionaire() async {
    try {
      QuerySnapshot questionaires = await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .collection("completed_questionaires")
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      return questionaires.docs.isNotEmpty
          ? Questionaire.fromMap(
              questionaires.docs.first.data() as Map<String, dynamic>)
          : throw Exception("Questionaire does not exist");
    } catch (e) {
      throw Exception(e);
    }
  } // getMostRecentQuestionaire

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

      // Round Averages to nearest whole number
      for (var month in questionaireAverages.monthlySectionAverages.keys) {
        for (var section
            in questionaireAverages.monthlySectionAverages[month]!.keys) {
          questionaireAverages.monthlySectionAverages[month]![section] =
              questionaireAverages.monthlySectionAverages[month]![section]!
                  .roundToDouble();
        }
      }

      for (var section in questionaireAverages.overallAverages.keys) {
        questionaireAverages.overallAverages[section] =
            questionaireAverages.overallAverages[section]!.roundToDouble();
      }

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
  void _calculateAndUpdateAverages() async {
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

      // Make sure monthsPassed is positive
      monthsPassed = monthsPassed < 0 ? monthsPassed * -1 : monthsPassed;

      String monthsPassedString = monthsPassed.toString();

      // If the month key does not exist, create it
      if (averages.monthlySectionAverages[monthsPassedString] == null) {
        averages.monthlySectionAverages[monthsPassedString] = {};
      }

      // Increment number of questionaires
      averages.monthlySectionAverages[monthsPassedString]![
          "numberOfQuestionaires"] = (averages.monthlySectionAverages[
                  monthsPassedString]!["numberOfQuestionaires"] ??
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
        if (averages.monthlySectionAverages[monthsPassedString]![section] ==
            null) {
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

    // Divide the averages by the number of questionaires to get the actual averages
    for (var month in averages.monthlySectionAverages.keys) {
      for (var section in averages.monthlySectionAverages[month]!.keys) {
        if (section != "numberOfQuestionaires") {
          averages.monthlySectionAverages[month]![section] = (averages
                  .monthlySectionAverages[month]![section]! /
              averages
                  .monthlySectionAverages[month]!["numberOfQuestionaires"]!);
        }
      }
    }

    for (var section in averages.overallAverages.keys) {
      averages.overallAverages[section] =
          (averages.overallAverages[section]! / totalQuestionaires);
    }

    // Save the averages to the database
    try {
      await _firestore
          .collection('assessments')
          .doc(_auth.currentUser!.uid)
          .set(averages.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }
  // _calculateAverages
} // AssessmentService
