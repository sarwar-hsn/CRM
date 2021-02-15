import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'mainDrawer.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('M/S. Shohel Traders (Beta Version)'),
          centerTitle: true,
        ),
        body: Center(
          child: Graph(),
        ));
  }
}

class Graph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      maxY: 500000,
      minY: 0,
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return value.toString();
            },
          )),
    ));
  }
}
