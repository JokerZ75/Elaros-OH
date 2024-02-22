import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_radar_chart.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/pages/health_page/questionaire_page.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = true;
  int graphPage = 0;

  final AssessmentService _assessmentService = AssessmentService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FuncionalChartData functionalChartData = FuncionalChartData(
      zeroMonths: [3, 6, 2, 1, 5],
      twoMonths: [6, 8, 8, 2, 6],
      fourMonths: [3, 6, 10, 6, 9],
      sixMonths: [4, 8, 5, 8, 10]);
  final SymptomServerityChartData symptomServerityChartData = SymptomServerityChartData(
      zeroMonths: [3, 6, 2, 1, 5, 3, 6, 2, 1, 5],
      twoMonths: [6, 8, 8, 2, 6, 6, 8, 8, 2, 6],
      fourMonths: [3, 6, 10, 6, 9, 3, 6, 10, 6, 9],
      sixMonths: [4, 8, 5, 8, 10, 4, 8, 5, 8, 10]);

  double value = 0;
  final Map<int, Map<String, double>> sectionAveragesState =
      {}; // {0(months): {section: average}, 2(months): {section: average}, 4(months): {section: average}, 6(months): {section: average}

  // function to print section
  void printSection() {
    _assessmentService.getQuestionaireAverages().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Column(
        children: <Widget>[
          // Add Coursel of 2 charts here
          _buildChartCoursel(),

          // Circles to show page number
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < 2; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: graphPage == i
                            ? Colors.grey.shade500
                            : Colors.grey.shade300,
                        border: graphPage == i
                            ? Border.all(
                                color: Colors.black,
                                width: 2,
                              )
                            : Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                      ),
                    ),
                ],
              ),
              Text(
                'Page ${graphPage + 1} of 2',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Take Assessment Button

          Row(children: <Widget>[
            Expanded(
                child: MySubmitButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuestionairePage()));
                    },
                    fontWeight: FontWeight.w600,
                    text: 'Click To Take A Covid\nAssessment')),
          ]),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Create Export Button
              Expanded(
                  child: MySubmitButton(
                onPressed: () {},
                text: 'Create\nExport',
                minWidth: 165,
                icon: const Icon(
                  Icons.upload,
                  color: Colors.black,
                  size: 28,
                ),
                textSize: 18,
                fontWeight: FontWeight.w600,
              )),

              const SizedBox(
                width: 10,
              ),
              // View Previous Assessments Button
              Expanded(
                  child: MySubmitButton(
                onPressed: () {
                  printSection();
                },
                text: 'Previously\nCompleted',
                minWidth: 165,
                icon: const Icon(
                  Icons.checklist,
                  color: Colors.black,
                  size: 28,
                ),
                textSize: 18,
                fontWeight: FontWeight.w600,
              ))
            ],
          ),
        ],
      ),
    )));
  }

  Widget _buildChartCoursel() {
    return StreamBuilder<QuerySnapshot>(
        stream: _assessmentService.getQuestionaires(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text("Error occured while fetching data"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          if (snapshot.hasData) {
            // Questionaire
            DateTime accounntCreated =
                _auth.currentUser!.metadata.creationTime!;
            Map<int, Map<String, double>> sectionAverages = {};

            for (var doc in snapshot.data!.docs) {
              var questionaire = doc['questionaire'] as Map<String, dynamic>;

              // Check how many months have passed since account created and questionaire was taken
              Timestamp questionaireDate = doc['timestamp'];
              int monthsPassed = questionaireDate
                      .toDate()
                      .difference(accounntCreated)
                      .inDays ~/
                  30;

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
            ///////// THIS NEEDS REFACTORING

            // Functional Disability
            functionalChartData.zeroMonths = [
              sectionAverages[0]?['Communication'] ?? 0,
              sectionAverages[0]?['Walking or moving around '] ?? 0,
              sectionAverages[0]?['Personal'] ?? 0,
              sectionAverages[0]?['Other activities of Daily Living'] ?? 0,
              sectionAverages[0]?['Social role'] ?? 0,
            ];
            functionalChartData.twoMonths = [
              sectionAverages[2]?['Communication'] ?? 0,
              sectionAverages[2]?['Walking or moving around '] ?? 0,
              sectionAverages[2]?['Personal'] ?? 0,
              sectionAverages[2]?['Other activities of Daily Living'] ?? 0,
              sectionAverages[2]?['Social role'] ?? 0,
            ];
            functionalChartData.fourMonths = [
              sectionAverages[4]?['Communication'] ?? 0,
              sectionAverages[4]?['Walking or moving around '] ?? 0,
              sectionAverages[4]?['Personal'] ?? 0,
              sectionAverages[4]?['Other activities of Daily Living'] ?? 0,
              sectionAverages[4]?['Social role'] ?? 0,
            ];
            functionalChartData.sixMonths = [
              sectionAverages[6]?['Communication'] ?? 0,
              sectionAverages[6]?['Walking or moving around '] ?? 0,
              sectionAverages[6]?['Personal'] ?? 0,
              sectionAverages[6]?['Other activities of Daily Living'] ?? 0,
              sectionAverages[6]?['Social role'] ?? 0,
            ];

            // Symptom Serverity
            symptomServerityChartData.zeroMonths = [
              sectionAverages[0]?['Breathlessness'] ?? 0,
              sectionAverages[0]?['Throat sensitivity'] ?? 0,
              sectionAverages[0]?['Fatigue'] ?? 0,
              sectionAverages[0]?['Smell / Taste'] ?? 0,
              sectionAverages[0]?['Pain / Discomfort'] ?? 0,
              sectionAverages[0]?['Cognition'] ?? 0,
              sectionAverages[0]?['Palpitations / Dizziness'] ?? 0,
              sectionAverages[0]?['Worsening of symptoms'] ?? 0,
              sectionAverages[0]?['Anixety / Mood'] ?? 0,
              sectionAverages[0]?['Sleep'] ?? 0,
            ];
            symptomServerityChartData.twoMonths = [
              sectionAverages[2]?['Breathlessness'] ?? 0,
              sectionAverages[2]?['Throat sensitivity'] ?? 0,
              sectionAverages[2]?['Fatigue'] ?? 0,
              sectionAverages[2]?['Smell / Taste'] ?? 0,
              sectionAverages[2]?['Pain / Discomfort'] ?? 0,
              sectionAverages[2]?['Cognition'] ?? 0,
              sectionAverages[2]?['Palpitations / Dizziness'] ?? 0,
              sectionAverages[2]?['Worsening of symptoms'] ?? 0,
              sectionAverages[2]?['Anixety / Mood'] ?? 0,
              sectionAverages[2]?['Sleep'] ?? 0,
            ];
            symptomServerityChartData.fourMonths = [
              sectionAverages[4]?['Breathlessness'] ?? 0,
              sectionAverages[4]?['Throat sensitivity'] ?? 0,
              sectionAverages[4]?['Fatigue'] ?? 0,
              sectionAverages[4]?['Smell / Taste'] ?? 0,
              sectionAverages[4]?['Pain / Discomfort'] ?? 0,
              sectionAverages[4]?['Cognition'] ?? 0,
              sectionAverages[4]?['Palpitations / Dizziness'] ?? 0,
              sectionAverages[4]?['Worsening of symptoms'] ?? 0,
              sectionAverages[4]?['Anixety / Mood'] ?? 0,
              sectionAverages[4]?['Sleep'] ?? 0,
            ];
            symptomServerityChartData.sixMonths = [
              sectionAverages[6]?['Breathlessness'] ?? 0,
              sectionAverages[6]?['Throat sensitivity'] ?? 0,
              sectionAverages[6]?['Fatigue'] ?? 0,
              sectionAverages[6]?['Smell / Taste'] ?? 0,
              sectionAverages[6]?['Pain / Discomfort'] ?? 0,
              sectionAverages[6]?['Cognition'] ?? 0,
              sectionAverages[6]?['Palpitations / Dizziness'] ?? 0,
              sectionAverages[6]?['Worsening of symptoms'] ?? 0,
              sectionAverages[6]?['Anixety / Mood'] ?? 0,
              sectionAverages[6]?['Sleep'] ?? 0,
            ];
            ///////////////////////////////////

          }

          return SizedBox(
            height: 470,
            child: PageView(
              onPageChanged: (value) => {
                graphPage = value,
              },
              children: <Widget>[
                MyRadarChart(
                  title: 'Functional disability score',
                  dataSets: functionalChartData.getRawData(),
                  getTitle: (index, value) {
                    switch (index) {
                      case 0:
                        return const RadarChartTitle(
                            text: 'Communication', angle: 0);
                      case 1:
                        return const RadarChartTitle(
                          text: 'Mobility',
                          angle: 0,
                        );
                      case 2:
                        return const RadarChartTitle(
                          text: 'Personal Care',
                          angle: 0,
                        );
                      case 3:
                        return const RadarChartTitle(
                          text: 'Daily Activities',
                          angle: 0,
                        );
                      case 4:
                        return const RadarChartTitle(
                          text: 'Social Role',
                          angle: 0,
                        );
                      default:
                        return const RadarChartTitle(
                          text: '',
                          angle: 0,
                        );
                    }
                  },
                ),
                MyRadarChart(
                  title: 'Symptoms serverity score',
                  dataSets: symptomServerityChartData.getRawData(),
                  getTitle: (index, value) {
                    switch (index) {
                      case 0:
                        return const RadarChartTitle(
                            text: 'Breathlessness', angle: 0);
                      case 1:
                        return const RadarChartTitle(
                          text: 'Throat sensitivity',
                          angle: 0,
                        );
                      case 2:
                        return const RadarChartTitle(
                          text: 'Fatigue',
                          angle: 0,
                        );
                      case 3:
                        return const RadarChartTitle(
                          text: 'Smell / Taste',
                          angle: 0,
                        );
                      case 4:
                        return const RadarChartTitle(
                          text: 'Pain / Discomfort',
                          angle: 0,
                        );
                      case 5:
                        return const RadarChartTitle(
                          text: 'Cognition',
                          angle: 0,
                        );
                      case 6:
                        return const RadarChartTitle(
                          text: 'Palpitations / Dizziness',
                          angle: 0,
                        );
                      case 7:
                        return const RadarChartTitle(
                          text: 'Worsening',
                          angle: 0,
                        );
                      case 8:
                        return const RadarChartTitle(
                          text: 'Mood',
                          angle: 0,
                        );
                      case 9:
                        return const RadarChartTitle(
                          text: 'Sleep',
                          angle: 0,
                        );
                      default:
                        return const RadarChartTitle(
                          text: '',
                          angle: 0,
                        );
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}

class FuncionalChartData {
  List<double> preCovid = [
    0,
    0,
    0,
    0,
    0
  ]; // Communication, Mobility, Personal Care, Daily Activities, Social Role
  List<double> zeroMonths;
  List<double> twoMonths;
  List<double> fourMonths;
  List<double> sixMonths;

  FuncionalChartData(
      {required this.zeroMonths,
      required this.twoMonths,
      required this.fourMonths,
      required this.sixMonths});

  List<RawDataSet> getRawData() {
    return [
      RawDataSet(
        title: 'Pre-covid',
        color: Colors.blue,
        values: preCovid,
      ),
      RawDataSet(
        title: '0 Months',
        color: Colors.red,
        values: zeroMonths,
      ),
      RawDataSet(title: '2 Months', color: Colors.brown, values: twoMonths),
      RawDataSet(title: '4 Months', color: Colors.green, values: fourMonths),
      RawDataSet(title: '6 Months', color: Colors.purple, values: sixMonths),
    ];
  }
}

class SymptomServerityChartData {
  List<double> preCovid = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; // Breathlessness, Throat sensitivity, Fatigue, Smell / Taste, Pain / Discomfort, Cognition, Palpitations / Dizzness, Worsening of symptoms, Anxiety / Mood, Sleep
  List<double> zeroMonths;
  List<double> twoMonths;
  List<double> fourMonths;
  List<double> sixMonths;

  SymptomServerityChartData(
      {required this.zeroMonths,
      required this.twoMonths,
      required this.fourMonths,
      required this.sixMonths});

  List<RawDataSet> getRawData() {
    return [
      RawDataSet(
        title: 'Pre-covid',
        color: Colors.blue,
        values: preCovid,
      ),
      RawDataSet(
        title: '0 Months',
        color: Colors.red,
        values: zeroMonths,
      ),
      RawDataSet(title: '2 Months', color: Colors.brown, values: twoMonths),
      RawDataSet(title: '4 Months', color: Colors.green, values: fourMonths),
      RawDataSet(title: '6 Months', color: Colors.purple, values: sixMonths),
    ];
  }
}
