import 'package:flutter/material.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';

class TransactionHistoryScreen extends StatelessWidget {
  static const routeName = '/TransactionHistoryScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      drawer: MainDrawer(),
    );
  }
}
