import 'package:flutter/material.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  static const routeName = '/CustomerDetailScreen';

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final customerId = ModalRoute.of(context).settings.arguments as String;
    Customer customer =
        Provider.of<Customers>(context).getCustomerById(customerId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Detail Screen'),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Center(
        child: Text(customer.name),
      ),
    );
  }
}
