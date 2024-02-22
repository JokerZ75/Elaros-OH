import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_assessment_card.dart';
import 'package:occupational_health/pages/health_page/complete_questionaire_page.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';

class PreviousAssessmentPage extends StatefulWidget {
  const PreviousAssessmentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreviousAssessmentPageState();
}

class _PreviousAssessmentPageState extends State<PreviousAssessmentPage> {
  final AssessmentService _assessmentService = AssessmentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFB84C),
        actionsIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 159, 155, 155)),
        centerTitle: false,
        title: const Text("Assessments",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _assessmentService.getQuestionaires(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // sort docs by timestamp
          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          docs.sort((a, b) {
            Timestamp aTimestamp = a['timestamp'];
            Timestamp bTimestamp = b['timestamp'];
            return bTimestamp.compareTo(aTimestamp);
          });

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
            child: ListView(
              children: docs
                  .map((document) => _buildAssessmentCard(document))
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssessmentCard(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'];
    // convert timestamp to date
    DateTime date = timestamp.toDate();
    // date should be in format 20-10-2022
    String formattedDate = "${date.day}-${date.month}-${date.year}";
    return MyAssessmentCard(
        title: "Assessment ${document.id.substring(0, 5)}", // Shorten the title
        subtitle: "Date Taken: ${formattedDate}",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompleteQuestionariePage(
                        id: document.id,
                      )));
        });
  }
}
