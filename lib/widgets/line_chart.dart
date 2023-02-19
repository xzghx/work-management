// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class LineChart extends StatefulWidget {
//   const LineChart({Key? key}) : super(key: key);
//
//   @override
//   State<LineChart> createState() => _LineChartState();
// }
//
// class _LineChartState extends State<LineChart> {
//   late TooltipBehavior _tooltipBehavior;
//
//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//         aspectRatio: 8 / 9,
//         child: SfCartesianChart(
//             primaryXAxis: CategoryAxis(),
//             title: ChartTitle(text: 'Half yearly sales analysis'),
//             legend: Legend(isVisible: true),
//             tooltipBehavior: _tooltipBehavior,
//             series: <LineSeries<SalesData, String>>[
//               LineSeries<SalesData, String>(
//                   dataSource: <SalesData>[
//                     SalesData('Jan', 35),
//                     SalesData('Feb', 28),
//                     SalesData('Mar', 34),
//                     SalesData('Apr', 32),
//                     SalesData('May', 40)
//                   ],
//                   xValueMapper: (SalesData sales, _) => sales.year,
//                   yValueMapper: (SalesData sales, _) => sales.sales,
//                   // Enable data label
//                   dataLabelSettings: DataLabelSettings(isVisible: true))
//             ]));
//   }
// }
//
// class SalesData {
//   SalesData(this.year, this.sales);
//
//   final String year;
//   final double sales;
// }
