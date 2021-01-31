import 'package:flutter/material.dart';
import '../mainDrawer.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Shohel\'s store'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Graph'),
        ));
  }
}
