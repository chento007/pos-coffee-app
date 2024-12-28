import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartComponent extends StatefulWidget {
  const BarChartComponent({super.key});

  @override
  State<BarChartComponent> createState() => _BarChartComponentState();
}

class _BarChartComponentState extends State<BarChartComponent> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Apple', 12),
      _ChartData('Banana', 15),
      _ChartData('Orange', 30),
      _ChartData('Mango', 6.4),
      _ChartData('Pineapple', 14),
      _ChartData('Grapes', 9.5),
      _ChartData('Blueberry', 18.2),
      _ChartData('Strawberry', 25.7),
      _ChartData('Avocado', 13.4),
      _ChartData('Papaya', 20),
      _ChartData('Watermelon', 22),
      _ChartData('Lemon', 16.5),
      _ChartData('Peach', 28),
      _ChartData('Plum', 35),
      _ChartData('Kiwi', 19),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 870,
      height: 600,
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 5),
          tooltipBehavior: _tooltip,
          series: <CartesianSeries<_ChartData, String>>[
            BarSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'Sales',
                color: Color.fromRGBO(8, 142, 255, 1))
          ]),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
