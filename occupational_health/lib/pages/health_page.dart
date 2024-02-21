import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_radar_chart.dart';
import 'package:occupational_health/components/my_submit_button.dart';

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
                          print('Take Assessment Button Pressed');
                        },
                        fontWeight: FontWeight.w600,
                        text: 'Click To Take A Covid\nAssessment')),
              ]),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Create Export Button
                  MySubmitButton(
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
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  // View Previous Assessments Button
                  MySubmitButton(
                    onPressed: () {},
                    text: 'Previously\nCompleted',
                    minWidth: 165,
                    icon: const Icon(
                      Icons.checklist,
                      color: Colors.black,
                      size: 28,
                    ),
                    textSize: 18,
                    fontWeight: FontWeight.w600,
                  )
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
            dataSets: <RawDataSet>[
              RawDataSet(
                title: 'Pre-covid',
                color: Colors.blue,
                values: [0, 0, 0, 0, 0],
              ),
              RawDataSet(
                title: '0 Months',
                color: Colors.red,
                values: [3, 6, 2, 1, 5],
              ),
              RawDataSet(
                  title: '2 Months',
                  color: Colors.brown,
                  values: [6, 8, 8, 2, 6]),
              RawDataSet(
                  title: '4 Months',
                  color: Colors.green,
                  values: [3, 6, 10, 6, 9]),
              RawDataSet(
                  title: '6 Months',
                  color: Colors.purple,
                  values: [4, 8, 5, 8, 10]),
            ],
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
            dataSets: <RawDataSet>[
              RawDataSet(
                title: 'Pre-covid',
                color: Colors.blue,
                values: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
              ),
              RawDataSet(
                title: '0 Months',
                color: Colors.red,
                values: [3, 6, 2, 1, 5, 3, 6, 2, 1, 5],
              ),
              RawDataSet(
                  title: '2 Months',
                  color: Colors.brown,
                  values: [6, 8, 8, 2, 6, 6, 8, 8, 2, 6]),
              RawDataSet(
                  title: '4 Months',
                  color: Colors.green,
                  values: [3, 6, 10, 6, 9, 3, 6, 10, 6, 9]),
              RawDataSet(
                  title: '6 Months',
                  color: Colors.purple,
                  values: [4, 8, 5, 8, 10, 4, 8, 5, 8, 10]),
            ],
            getTitle: (index, value) {
              switch (index) {
                case 0:
                  return const RadarChartTitle(
                      text: 'Breathlessness', angle: 0);
                case 1:
                  return const RadarChartTitle(
                    text: 'Cough',
                    angle: 0,
                  );
                case 2:
                  return const RadarChartTitle(
                    text: 'Palpitations',
                    angle: 0,
                  );
                case 3:
                  return const RadarChartTitle(
                    text: 'Fatigue',
                    angle: 0,
                  );
                case 4:
                  return const RadarChartTitle(
                    text: 'Dizziness',
                    angle: 0,
                  );
                case 5:
                  return const RadarChartTitle(
                    text: 'Pain',
                    angle: 0,
                  );
                case 6:
                  return const RadarChartTitle(
                    text: 'Cognition',
                    angle: 0,
                  );
                case 7:
                  return const RadarChartTitle(
                    text: 'Anxiety',
                    angle: 0,
                  );
                case 8:
                  return const RadarChartTitle(
                    text: 'Depression',
                    angle: 0,
                  );
                case 9:
                  return const RadarChartTitle(
                    text: 'PTSD Screening',
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
