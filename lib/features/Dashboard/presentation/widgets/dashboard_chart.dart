import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainLayoutChart extends StatefulWidget {
  const MainLayoutChart({Key? key}) : super(key: key);

  @override
  State<MainLayoutChart> createState() => _MainLayoutChartState();
}

class _MainLayoutChartState extends State<MainLayoutChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<ChartData, String>>[
            LineSeries<ChartData, String>(
                dataSource: [
                  ChartData('محاسب1', 30),
                  ChartData('محاسب2', 50),
                  ChartData('محاسب3', 40),
                  ChartData('محاسب4', 10),
                ],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y),
          ]),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
