import 'package:flutter/material.dart';

import 'package:manage/Model/Customer.dart';
import 'package:manage/Screens/Customer/customerDetailScreen.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

class CustomerListView extends StatefulWidget {
  @override
  _CustomerListViewState createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView> {
  @override
  Widget build(BuildContext context) {
    Provider.of<Customers>(context).customerByName();
    final List<Customer> customers = Provider.of<Customers>(context).customers;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blueGrey,
              border:
                  Border(bottom: BorderSide(width: 2, color: Colors.blueGrey))),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(child: Text('name')),
              Expanded(child: Text('mobile')),
              Expanded(child: Text('total')),
              Expanded(child: Text('paid')),
              Expanded(child: Text('due')),
              Expanded(child: Text('Go to Detail')),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white70,
                    border: Border(
                        bottom: BorderSide(
                            width: 2, color: Colors.blueGrey.withOpacity(.7)))),
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 50),
                    Expanded(child: Text(customers[index].name)),
                    Expanded(child: Text(customers[index].mobile)),
                    Expanded(child: Text(customers[index].total.toString())),
                    Expanded(child: Text(customers[index].paid.toString())),
                    Expanded(child: Text(customers[index].due.toString())),
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.only(right: 140),
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          print(customers[index].id);
                          Navigator.of(context).pushNamed(
                              CustomerDetailScreen.routeName,
                              arguments: customers[index].id);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
