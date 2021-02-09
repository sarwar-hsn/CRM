import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

class TransactionHistoryScreen extends StatelessWidget {
  static const routeName = '/TransactionHistoryScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      drawer: MainDrawer(),
      body: SingleBoxDesign(
        date: DateTime.now(),
      ),
    );
  }
}

Map<String, Object> listofCustomerandTotalByDate(
    DateTime date, List<Customer> customer) {
  print('Date : ' + DateFormat('dd-MM-yyyy').format(date).toString());
  List<Customer> temp = [];
  double total = 0;
  double deposite = 0;
  double due = 0;
  for (int i = 0; i < customer.length; i++) {
    for (int j = 0; j < customer[i].products.length; j++) {
      print('customer purchase Date : ' +
          DateFormat('dd-MM-yyyy')
              .format(customer[i].products[j].date)
              .toString());
      if (DateFormat('dd-MM-yyyy')
              .format(customer[i].products[j].date)
              .toString() ==
          DateFormat('dd-MM-yyyy').format(date).toString()) {
        for (int k = 0; k < customer[i].products[j].products.length; k++) {
          total += customer[i].products[j].products[k].total;
        }
        temp.add(customer[i]);
      }
    }
  }
  for (int i = 0; i < temp.length; i++) {
    deposite += temp[i].paid;
  }
  due = total - deposite;
  return {'customers': temp, 'total': total, 'deposite': deposite, 'due': due};
}

class SingleBoxDesign extends StatelessWidget {
  final DateTime date;
  SingleBoxDesign({this.date});
  @override
  Widget build(BuildContext context) {
    List<Customer> customer = Provider.of<Customers>(context).customers;
    Map<String, Object> data = listofCustomerandTotalByDate(date, customer);
    List<Customer> tempCustomer = data['customers'] as List<Customer>;
    return Container(
      height: 300,
      child: (tempCustomer.length == 0)
          ? Text('No Customer on this day')
          : ListView.builder(
              itemCount: tempCustomer.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    children: [
                      Text('Date : ' +
                          DateFormat('dd-MM-yyyy').format(date).toString() +
                          '   '),
                      Text('Total Sell : ' + data['total'].toString() + '   '),
                      Text('Deposite : ' + data['deposite'].toString() + '   '),
                      Text('Due : ' + data['due'].toString()),
                    ],
                  );
                }
                index -= 1;
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(tempCustomer[index].name),
                );
              },
            ),
    );
  }
}
