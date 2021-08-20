import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState.withSampleData();
}

class _ChartPageState extends State<ChartPage> {
  late List<charts.Series> seriesList;
  final bool animate = true;

  _ChartPageState(this.seriesList);

  /// Creates a [PieChart] with sample data and no transition.
  factory _ChartPageState.withSampleData() {
    return new _ChartPageState(
      _createSampleData(0, 0),
      // Disable animations for image tests.
    );
  }

  @override
  void initState() {
    super.initState();

    loadTheChart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadTheChart() {
    try {
      FirebaseFirestore.instance
          .collection('targets')
          .snapshots()
          .listen((data) {
        num amount = 0;
        num complete = 0;

        data.docs.forEach((doc) {
          amount += doc["amount"];
          complete += doc["contribution_total"];
        });
        if (this.mounted) {
          setState(() {
            seriesList = _createSampleData(amount, complete);
          });
        }
      });
    } catch (e) {
      print("Some thing went wrong " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(
      amount, complete) {
    final data = [
      new LinearSales(0, complete),
      new LinearSales(1, amount - complete),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
