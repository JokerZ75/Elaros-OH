import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarChart extends StatefulWidget {
  final String title;
  final List<BarChartGroupData> dataSets;

  const MyBarChart({
    Key? key,
    required this.title,
    required this.dataSets,
  }) : super(key: key);

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(' Communication ', style: TextStyle(color: Colors.blue)),
              Text(' Mobility ', style: TextStyle(color: Colors.green)),
              Text(' Personal Care ', style: TextStyle(color: Colors.red)),
              Text(' Daily Activities ',
                  style: TextStyle(color: Colors.purple)),
              Text(' Social Role ', style: TextStyle(color: Colors.black)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: BarChart(BarChartData(
              minY: 0,
              maxY: 3,
              barGroups: [
                for (var dataSet in widget.dataSets) dataSet,
              ],
              titlesData: const FlTitlesData(
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    axisNameWidget: Text("Months since covid"),
                    axisNameSize: 30),
              ),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
            )),
          ),
        ],
      ),
    );
  }


}
