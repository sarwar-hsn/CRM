import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

class DailyCheck extends StatefulWidget {
  static const routeName = '/DailyCheck';

  @override
  _DailyCheckState createState() => _DailyCheckState();
}

class _DailyCheckState extends State<DailyCheck> {
  DateTime selectDate = DateTime.now();

  Future<void> _pickDateforCustomerProduct() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (date != null)
      setState(() {
        selectDate = date;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers scheduled to pay on ' +
            DateFormat('dd-MM-yyyy').format(selectDate).toString()),
      ),
      body: Center(
        child: SchedulePaymentDay(
          date: selectDate,
        ),
      ),
      drawer: MainDrawer(),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          _pickDateforCustomerProduct();
        },
        child: Icon(
          Icons.date_range,
        ),
      ),
    );
  }
}

class SchedulePaymentDay extends StatelessWidget {
  final DateTime date;
  SchedulePaymentDay({this.date});
  @override
  Widget build(BuildContext context) {
    Customers customers = Provider.of<Customers>(context);
    List<Customer> scheduledCustomers = customers.scheduledCustomer(date);
    if (scheduledCustomers.isEmpty)
      return Center(
        child: Text('No Schedule Payment found'),
      );
    return ListView.builder(
      itemCount: scheduledCustomers.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.person),
          title: Text('Name : ' +
              scheduledCustomers[index].name +
              '    Due : ' +
              scheduledCustomers[index].due.toStringAsFixed(2) +
              '   Mobile : ' +
              scheduledCustomers[index].mobile),
        );
      },
    );
  }
}
