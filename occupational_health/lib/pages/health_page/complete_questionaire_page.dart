import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';
import 'package:occupational_health/model/questionaire.dart';


class CompleteQuestionariePage extends StatefulWidget {
  final String id;
  const CompleteQuestionariePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _CompleteQuestionariePageState();
}

class _CompleteQuestionariePageState extends State<CompleteQuestionariePage> {
  final AssessmentService _assessmentService = AssessmentService();
  Questionaire _questionaire = Questionaire(
    questionaire: {},
    timestamp: Timestamp.now(),
  );
  


  @override
  void initState() {
    super.initState();
    _assessmentService.getQuestionaireById(widget.id).then((questionaire) {
      setState(() {
        _questionaire = questionaire;
      });
    });
  }

  void _submitQuestionaire() {
    print("object");  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFB84C),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text("Questionaire",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600)),
      ),
      body:Center(child: Column(children: <Widget>[
        Text(widget.id, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text("Date: ${_questionaire.timestamp.toDate().toString()}"),
        
          ElevatedButton(
            onPressed: _submitQuestionaire,
            child: const Text("Submit"),
          ),
        
      ])),
    );
  }
}


class QuestionaireSection {
  final String sectionTitle;
  final Map<String, int> questions;

  QuestionaireSection({required this.sectionTitle, required this.questions});
}
