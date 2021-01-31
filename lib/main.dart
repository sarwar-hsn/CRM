import 'package:flutter/material.dart';
import 'Screens/homepage.dart';
import './Screens/customersScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
      routes: {
        CustomersScreen.routeName: (context) => CustomersScreen(),
      },
    );
  }
}
