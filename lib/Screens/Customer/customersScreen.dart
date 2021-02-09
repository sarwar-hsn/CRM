import 'package:flutter/material.dart';
import 'package:manage/Widgets/CustomerListView.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/provider/Customers.dart';
import '../../Widgets/searchByName.dart';

class CustomersScreen extends StatefulWidget {
  static const routeName = '/customerScreen';

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer OverView Screen'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Customers());
              })
        ],
      ),
      drawer: MainDrawer(),
      body: CustomerListView(),
      backgroundColor: Colors.white70,
    );
  }
}
