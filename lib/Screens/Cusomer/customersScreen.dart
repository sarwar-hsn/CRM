import 'package:flutter/material.dart';
import 'package:manage/Widgets/CustomerListView.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import '../../Widgets/searchByName.dart';

class CustomersScreen extends StatelessWidget {
  static const routeName = '/customerScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Detail Screen'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                //showSearch(context: context, delegate: SearchByName());
              })
        ],
      ),
      drawer: MainDrawer(),
      body: CustomerListView(),
      backgroundColor: Colors.white70,
    );
  }
}
