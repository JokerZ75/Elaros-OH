import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Questionaire {
  final Map<String, Map<String, int>>
      questionaire; // {section: {question: answer, question: answer}, section: {question: answer, question: answer}
  final Timestamp timestamp;
  GeoPoint? location;

  Questionaire({
    required this.questionaire,
    required this.timestamp,
    this.location,
  });

  // set location
  Future<void> setLocation(GeoPoint position) async {
    this.location = position;  
  }

  Map<String, dynamic> toMap() {
    return {
      'questionaire': {
        for (var section in questionaire.keys)
          section: {
            for (var question in questionaire[section]!.keys)
              question: questionaire[section]![question],
          }
      },
      'timestamp': timestamp,
    };
  }

  factory Questionaire.fromMap(Map<String, dynamic> map) {
    return Questionaire(
      questionaire: {
        for (var section in map['questionaire'].keys)
          section: {
            for (var question in map['questionaire'][section].keys)
              question: map['questionaire'][section][question],
          }
      },
      timestamp: map['timestamp'],
    );
  }
}
