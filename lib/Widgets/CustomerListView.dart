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
  final _style = TextStyle(fontWeight: FontWeight.bold);
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
              Expanded(
                  child: Text(
                'name',
                style: _style,
              )),
              Expanded(
                  child: Text(
                'mobile',
                style: _style,
              )),
              Expanded(
                  child: Text(
                'total',
                style: _style,
              )),
              Expanded(
                  child: Text(
                'paid',
                style: _style,
              )),
              Expanded(
                  child: Text(
                'due',
                style: _style,
              )),
              Expanded(
                  child: Text(
                'Go to Detail',
                style: _style,
              )),
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
