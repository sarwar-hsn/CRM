import 'package:flutter/material.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';

class AddCustomerScreen extends StatelessWidget {
  static const routeName = '/addCustomer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Center(
        child: Text('add customer'),
      ),
    );
  }
}
