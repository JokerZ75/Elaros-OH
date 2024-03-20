import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_radar_chart.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_top_progress_card.dart';
import 'package:occupational_health/pages/health_page/pdf_page.dart';
import 'package:occupational_health/pages/health_page/previous_page.dart';
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
  final FuncionalChartData functionalChartData = FuncionalChartData(
      monthlyAverages: {} // Monthly averages will be added here
      );
  final SymptomServerityChartData symptomServerityChartData =
      SymptomServerityChartData(
          monthlyAverages: {} // Monthly averages will be added here
          );
  int biggestFunctionalValue = 3;
  int biggestSymptomValue = 3;

  double value = 0;

  @override
  void initState() {
    super.initState();
    _setChartData();
  }

  void _setChartData() {
    _assessmentService.getQuestionaireAverages().then((value) {
      Map<String, String> funcNames = {
        "Communication": "Communication",
        "Walking or moving around ": "Mobility",
        "Personal": "Personal Care",
        "Other activities of Daily Living": "Daily Activities",
        "Social role": "Social Role"
      };

      Map<String, String> symptomNames = {
        "Breathlessness": "Breathlessness", //
        "Throat sensitivity": "Throat sensitivity", //
        "Fatigue": "Fatigue", //
        "Smell / Taste": "Smell / Taste", //
        "Pain / Discomfort": "Pain / Discomfort", //
        "Cognition": "Cognition", //
        "Palpitations / Dizziness": "Palpitations / Dizziness", //
        "Worsening of symptoms": "Worsening", //
        "Anxiety / Mood": "Mood",
        "Sleep": "Sleep" //
      };
      Map<String, Map<String, double>> functionalData = {};
      Map<String, Map<String, double>> symptomData = {};

      // Only take the 5 most recent months
      var keys = value.monthlySectionAverages.keys.toList();

      // sort the keys
      keys.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      if (keys.length > 4) {
        keys = keys.sublist(keys.length - 4);
      }

      double bigF = 0;
      double bigS = 0;

      // convert the data to the format we need
      for (var month in keys) {
        functionalData[month] = {};
        symptomData[month] = {};

        if (value.monthlySectionAverages[month] != null) {
          Map<String, double> monthData = value.monthlySectionAverages[month]!;
          for (var section in monthData.keys) {
            if (funcNames.containsKey(section)) {
              if (monthData[section]! > bigF) {
                bigF = monthData[section]!;
              }
              functionalData[month]![funcNames[section]!] = monthData[section]!;
            } else if (symptomNames.containsKey(section)) {
              if (monthData[section]! > bigS) {
                bigS = monthData[section]!;
              }
              symptomData[month]![symptomNames[section]!] = monthData[section]!;
            }
          }
        }
      }

      setState(() {
        if (functionalData.isEmpty) {
          functionalData["0"] = {
            "Communication": 0,
            "Mobility": 0,
            "Personal Care": 0,
            "Daily Activities": 0,
            "Social Role": 0
          };
          biggestFunctionalValue = 0;
        }
        if (symptomData.isEmpty) {
          symptomData["0"] = {
            "Breathlessness": 0,
            "Throat sensitivity": 0,
            "Fatigue": 0,
            "Smell / Taste": 0,
            "Pain / Discomfort": 0,
            "Cognition": 0,
            "Palpitations / Dizziness": 0,
            "Worsening": 0,
            "Mood": 0,
            "Sleep": 0
          };
          biggestSymptomValue = 1;
          biggestFunctionalValue = 1;
        } else {
          functionalChartData.monthlyAverages = functionalData;
          symptomServerityChartData.monthlyAverages = symptomData;
          biggestFunctionalValue = bigF.toInt();
          biggestSymptomValue = bigS.toInt();
        }
      });
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
                    style: const TextStyle(backgroundColor: Color(0xFFEFD080)),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const QuestionairePage())).then((value) => {
                            // Show Linear Progress Indicator in snackbar
                            if (value != null)
                              {
                                MyTopProgressCard(
                                        duration: const Duration(seconds: 2),
                                        title: "Refreshing Graph",
                                        distanceFromTop: 250)
                                    .showSnackBar(context),

                                // wait 500ms before updating the chart
                                Future.delayed(const Duration(seconds: 2), () {
                                  _setChartData();
                                })
                              }
                          });
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
                style: const TextStyle(backgroundColor: Color(0xFFEFD080)),
                onPressed: () {
                  PDFPage().createPDF();
                },
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
                style: const TextStyle(backgroundColor: Color(0xFFEFD080)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PreviousAssessmentPage()));
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
    return SizedBox(
      height: 470,
      child: PageView(
        onPageChanged: (value) => {
          setState(() {
            graphPage = value;
          })
        },
        children: <Widget>[
          MyRadarChart(
            title: 'Functional disability score',
            dataSets: functionalChartData.getRawData(),
            ticks: biggestFunctionalValue,
            getTitle: (index, value) {
              switch (index) {
                case 0:
                  return const RadarChartTitle(text: 'Communication', angle: 0);
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
            ticks: biggestSymptomValue,
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
  Map<String, Map<String, double>> monthlyAverages = {};

  FuncionalChartData({required this.monthlyAverages});

  List<RawDataSet> getRawData() {
    return [
      RawDataSet(title: 'Pre-covid', color: Colors.blue, values: preCovid),
      // Loop through the monthly averages and create a RawDataSet for each
      for (var month in monthlyAverages.keys)
        RawDataSet(
          title: '$month Months',
          color: Colors.primaries[int.parse(month)],
          values: monthlyAverages[month]!.values.toList(),
        )
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
  Map<String, Map<String, double>> monthlyAverages;

  SymptomServerityChartData({
    required this.monthlyAverages,
  });

  List<RawDataSet> getRawData() {
    return [
      RawDataSet(
        title: 'Pre-covid',
        color: Colors.blue,
        values: preCovid,
      ),
      // Loop through the monthly averages and create a RawDataSet for each
      for (var month in monthlyAverages.keys)
        RawDataSet(
          title: '$month Months',
          color: Colors.primaries[int.parse(month)],
          values: monthlyAverages[month]!.values.toList(),
        )
    ];
  }
}
