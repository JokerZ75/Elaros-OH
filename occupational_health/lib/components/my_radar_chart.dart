import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyRadarChart extends StatefulWidget {
  final String title;
  final List<RawDataSet> dataSets;
  final RadarChartTitle Function(int, double)? getTitle;

  const MyRadarChart({
    Key? key,
    required this.title,
    required this.dataSets,
    required this.getTitle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyRadarChartState();
}

class _MyRadarChartState extends State<MyRadarChart> {
  int selectedDataSetIndex = -1;
  double angleValue = 0;
  bool relativeAngleMode = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDataSetIndex = -1;
                    });
                  },
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
              
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // ignore: avoid_unnecessary_containers
              const Text("Select a dataset to view", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w200)),
              Container(
                child: Wrap(
                  children: rawDataSets()
                      .asMap()
                      .map((index, value) {
                        final isSelected = index == selectedDataSetIndex;
                        return MapEntry(
                          index,
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDataSetIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              height: 26,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF2C351)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(46),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInToLinear,
                                    padding: EdgeInsets.all(isSelected ? 8 : 6),
                                    decoration: BoxDecoration(
                                      color: value.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                
                                  const SizedBox(width: 8),
                
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInToLinear,
                                    style: TextStyle(
                                      color:
                                          isSelected ? value.color : Colors.blue,
                                    ),
                                    child: Text(value.title),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 270,
                height: 270,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      radarTouchData: RadarTouchData(
                        touchCallback: (FlTouchEvent event, response) {
                          if (!event.isInterestedForInteractions) {
                            setState(() {
                              selectedDataSetIndex = -1;
                            });
                            return;
                          }
                          setState(() {
                            selectedDataSetIndex =
                                response?.touchedSpot?.touchedDataSetIndex ?? -1;
                          });
                        },
                      ),
                      dataSets: showingDataSets(),
                      radarBackgroundColor: Colors.grey.shade100,
                      borderData: FlBorderData(show: false),
                      radarBorderData:
                          const BorderSide(color: Colors.transparent),
                      titlePositionPercentageOffset: 0.175,
                      titleTextStyle:
                          const  TextStyle(color: Colors.black, fontSize: 14),
                      getTitle: widget.getTitle,
                      tickCount: 5,
                      ticksTextStyle: const TextStyle(
                          color: Colors.black, fontSize: 10),
                      tickBorderData: BorderSide(color: Colors.grey.shade400, width: 1),
                      gridBorderData: const BorderSide(color: Colors.black, width: 2)
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 400),
                  ),
                ),
              ),
            ]));
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
              ? true
              : false;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withOpacity(0.2)
            : rawDataSet.color.withOpacity(0.05),
        borderColor:
            isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return widget.dataSets;
  }
}

int indexOf(String value, List<String> array){
    for(int i = 0; i < array.length; i++){
        if(array[i] == value){
            return i;
        }
    }
    //return a place holder value
    return -1;
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}
