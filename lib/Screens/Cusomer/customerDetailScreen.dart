import 'package:flutter/material.dart';
import 'package:manage/Model/Customer.dart';

class CustomerDetailScreen extends StatefulWidget {
  static const routeName = '/CustomerDetailScreen';

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final customerId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Center(
        child: Text('dummy name'),
      ),
    );
  }
}
