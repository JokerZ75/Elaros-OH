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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Health Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // Add Coursel of 2 charts here
              MyRadarChart(
                title: 'Your Health',
                dataSets: <RawDataSet>[
                  RawDataSet(
                    title: 'Pre-covid',
                    color: Colors.blue,
                    values: [ 0, 0, 0, 0, 0],
                  ),
                  RawDataSet(
                    title: '0 Months',
                    color: Colors.red,
                    values: [3, 6, 2, 1, 5],
                  ),
                  RawDataSet(
                      title: '2 Months',
                      color: Colors.orange,
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

              // Take Assessment Button
              const SizedBox(height: 15),



              Row(children: <Widget>[
                Expanded(
                    child: MySubmitButton(
                        onPressed: () {
                          print('Take Assessment Button Pressed');
                        },
                        fontWeight: FontWeight.w600,
                        text: 'Click To Take A Covid\nAssessment')),
              ]),

              const SizedBox(height: 15),

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
                      size: 35,
                    ),
                    textSize: 18,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(
                    width: 20,
                  ),
                  // View Previous Assessments Button
                  MySubmitButton(
                    onPressed: () {},
                    text: 'Previously\nCompleted',
                    minWidth: 165,
                    icon: const Icon(
                      Icons.checklist,
                      color: Colors.black,
                      size: 35,
                    ),
                    textSize: 18,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
