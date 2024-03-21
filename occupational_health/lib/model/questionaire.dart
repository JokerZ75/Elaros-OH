import 'package:cloud_firestore/cloud_firestore.dart';

class Questionaire {
  final Map<String, Map<String, int>>
      questionaire; // {section: {question: answer, question: answer}, section: {question: answer, question: answer}
  final Timestamp timestamp;

  Questionaire({
    required this.questionaire,
    required this.timestamp,
  });


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
