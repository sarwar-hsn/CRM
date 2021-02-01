import 'package:flutter/material.dart';
import 'package:manage/Screens/mainDrawer.dart';

class AddCustomerScreen extends StatelessWidget {
  static const routeName = '/addCustomer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('add customer'),
      ),
    );
  }
}
