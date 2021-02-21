import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../provider/stockdata.dart';
import 'mainDrawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<StockData>(context, listen: false).fetchAndSetCompanies();
    super.initState();
  }

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
