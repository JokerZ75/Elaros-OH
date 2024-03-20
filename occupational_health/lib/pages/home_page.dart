import "package:flutter/material.dart";
import "package:occupational_health/components/my_assessment_card.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/model/questionaire.dart";
import "package:occupational_health/pages/health_page/complete_questionaire_page.dart";
import "package:occupational_health/pages/health_page/questionaire_page.dart";
import "package:occupational_health/services/Assessment/assessment_service.dart";
import "package:occupational_health/services/Location/location_service.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AssessmentService _assessmentService = AssessmentService();
  (List<Questionaire>, List<String>) questionaires = ([], []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecentQuestionaires();
  }

  getRecentQuestionaires() async {
    (List<Questionaire>, List<String>) questionaires =
        await _assessmentService.getRecentQuestionaires();

    if (questionaires.$1.isEmpty) {
      return;
    }
    setState(() {
      this.questionaires = questionaires;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 30),
          MySubmitButton(
              style: TextStyle(backgroundColor: const Color(0xFFEFD080)),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuestionairePage()))
                    .then((value) => getRecentQuestionaires());
              },
              text: "Click To Take Your Daily Assessment"),
          // your environment
          const SizedBox(height: 30),
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Your Environmment',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Column(
              children: <Widget>[
                //  air pollution row
                Row(
                  children: [
                    // text and icon
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Air pollution",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.2),
                          ),
                          Icon(Icons.info, size: 15),
                        ],
                      ),
                    ),
                    // need to get the air polution and display it here
                    Expanded(
                      child: Text(
                        '2 Low',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                    ),
                  ],
                ),
                // Temperature
                Row(
                  children: [
                    // text and icon
                    Expanded(
                      child: Text(
                        "Temperature ",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                    ),
                    // need to get the temperature and display it here
                    Expanded(
                      child: Text(
                        '9°',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // recent assessments
          const SizedBox(height: 30),

          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Recent Assessments',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            //  air pollution row
            child: questionaires.$1.isEmpty
                ? const Center(
                    child: Text(
                    "No recent assessments",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ))
                : Column(children: <Widget>[
                    for (int i = 0; i < questionaires.$1.length; i++)
                      MyAssessmentCard(
                        title:
                            "Assessment ${questionaires.$2[i].substring(0, 3)}",
                        subtitle:
                            "Date Taken: ${questionaires.$1[i].timestamp.toDate().toString().substring(0, 10)}",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CompleteQuestionariePage(
                                          id: questionaires.$2[i])));
                        },
                      ),
                  ]),
          ),

          // Container(
          //   child: InputDecorator(
          //     decoration: InputDecoration(
          //       labelText: 'Recent Assessments',
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //     child: Column(
          //       children: <Widget>[
          //         //  air pollution row
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    )));
  }
}
