import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_radar_chart.dart';
import 'package:occupational_health/components/my_submit_button.dart';
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
      zeroMonths: [3, 6, 2, 1, 5],
      twoMonths: [6, 8, 8, 2, 6],
      fourMonths: [3, 6, 10, 6, 9],
      sixMonths: [4, 8, 5, 8, 10]);
  final SymptomServerityChartData symptomServerityChartData =
      SymptomServerityChartData(
          zeroMonths: [3, 6, 2, 1, 5, 3, 6, 2, 1, 5],
          twoMonths: [6, 8, 8, 2, 6, 6, 8, 8, 2, 6],
          fourMonths: [3, 6, 10, 6, 9, 3, 6, 10, 6, 9],
          sixMonths: [4, 8, 5, 8, 10, 4, 8, 5, 8, 10]);

  double value = 0;
  final Map<int, Map<String, double>> sectionAveragesState =
      {}; // {0(months): {section: average}, 2(months): {section: average}, 4(months): {section: average}, 6(months): {section: average}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setChartData();
  }

  void  _setChartData() {
    _assessmentService.getQuestionaireAverages().then((value) {
      setState(() {
        sectionAveragesState.addAll(value);
        functionalChartData.zeroMonths = [
          sectionAveragesState[0]?['Communication'] ?? 0,
          sectionAveragesState[0]?['Walking or moving around '] ?? 0,
          sectionAveragesState[0]?['Personal'] ?? 0,
          sectionAveragesState[0]?['Other activities of Daily Living'] ?? 0,
          sectionAveragesState[0]?['Social role'] ?? 0
        ];
        functionalChartData.twoMonths = [
          sectionAveragesState[2]?['Communication'] ?? 0,
          sectionAveragesState[2]?['Walking or moving around '] ?? 0,
          sectionAveragesState[2]?['Personal'] ?? 0,
          sectionAveragesState[2]?['Other activities of Daily Living'] ?? 0,
          sectionAveragesState[2]?['Social role'] ?? 0
        ];
        functionalChartData.fourMonths = [
          sectionAveragesState[4]?['Communication'] ?? 0,
          sectionAveragesState[4]?['Walking or moving around '] ?? 0,
          sectionAveragesState[4]?['Personal'] ?? 0,
          sectionAveragesState[4]?['Other activities of Daily Living'] ?? 0,
          sectionAveragesState[4]?['Social role'] ?? 0
        ];
        functionalChartData.sixMonths = [
          sectionAveragesState[6]?['Communication'] ?? 0,
          sectionAveragesState[6]?['Walking or moving around '] ?? 0,
          sectionAveragesState[6]?['Personal'] ?? 0,
          sectionAveragesState[6]?['Other activities of Daily Living'] ?? 0,
          sectionAveragesState[6]?['Social role'] ?? 0
        ];
        symptomServerityChartData.zeroMonths = [
          sectionAveragesState[0]?['Breathlessness'] ?? 0,
          sectionAveragesState[0]?['Throat sensitivity'] ?? 0,
          sectionAveragesState[0]?['Fatigue'] ?? 0,
          sectionAveragesState[0]?['Smell / Taste'] ?? 0,
          sectionAveragesState[0]?['Pain / Discomfort'] ?? 0,
          sectionAveragesState[0]?['Cognition'] ?? 0,
          sectionAveragesState[0]?['Palpitations / Dizziness'] ?? 0,
          sectionAveragesState[0]?['Worsening of symptoms'] ?? 0,
          sectionAveragesState[0]?['Anixety / Mood'] ?? 0,
          sectionAveragesState[0]?['Sleep'] ?? 0
        ];
        symptomServerityChartData.twoMonths = [
          sectionAveragesState[2]?['Breathlessness'] ?? 0,
          sectionAveragesState[2]?['Throat sensitivity'] ?? 0,
          sectionAveragesState[2]?['Fatigue'] ?? 0,
          sectionAveragesState[2]?['Smell / Taste'] ?? 0,
          sectionAveragesState[2]?['Pain / Discomfort'] ?? 0,
          sectionAveragesState[2]?['Cognition'] ?? 0,
          sectionAveragesState[2]?['Palpitations / Dizziness'] ?? 0,
          sectionAveragesState[2]?['Worsening of symptoms'] ?? 0,
          sectionAveragesState[2]?['Anixety / Mood'] ?? 0,
          sectionAveragesState[2]?['Sleep'] ?? 0
        ];
        symptomServerityChartData.fourMonths = [
          sectionAveragesState[4]?['Breathlessness'] ?? 0,
          sectionAveragesState[4]?['Throat sensitivity'] ?? 0,
          sectionAveragesState[4]?['Fatigue'] ?? 0,
          sectionAveragesState[4]?['Smell / Taste'] ?? 0,
          sectionAveragesState[4]?['Pain / Discomfort'] ?? 0,
          sectionAveragesState[4]?['Cognition'] ?? 0,
          sectionAveragesState[4]?['Palpitations / Dizziness'] ?? 0,
          sectionAveragesState[4]?['Worsening of symptoms'] ?? 0,
          sectionAveragesState[4]?['Anixety / Mood'] ?? 0,
          sectionAveragesState[4]?['Sleep'] ?? 0
        ];
        symptomServerityChartData.sixMonths = [
          sectionAveragesState[6]?['Breathlessness'] ?? 0,
          sectionAveragesState[6]?['Throat sensitivity'] ?? 0,
          sectionAveragesState[6]?['Fatigue'] ?? 0,
          sectionAveragesState[6]?['Smell / Taste'] ?? 0,
          sectionAveragesState[6]?['Pain / Discomfort'] ?? 0,
          sectionAveragesState[6]?['Cognition'] ?? 0,
          sectionAveragesState[6]?['Palpitations / Dizziness'] ?? 0,
          sectionAveragesState[6]?['Worsening of symptoms'] ?? 0,
          sectionAveragesState[6]?['Anixety / Mood'] ?? 0,
          sectionAveragesState[6]?['Sleep'] ?? 0
        ];
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionairePage(onAssessmentComplete: _setChartData )));
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
