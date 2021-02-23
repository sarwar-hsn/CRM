import 'package:flutter/material.dart';

import 'package:manage/Model/Customer.dart';
import 'package:manage/Screens/Customer/customerDetailScreen.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

class CustomerListView extends StatefulWidget {
  final String sortingOrder;

  CustomerListView({this.sortingOrder});
  @override
  _CustomerListViewState createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView> {
  final _style = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    print(widget.sortingOrder);
    Customers customersObj = Provider.of<Customers>(context);
    switch (widget.sortingOrder) {
      case 'Sort By Name':
        customersObj.customerByName();

        break;
      case 'Due (Decreasing Order)':
        customersObj.sortByDue();

        break;
      default:
    }
    final List<Customer> customers = customersObj.customers;

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //shape: BoxShape.rectangle,
                color: Colors.blueGrey,
                border: Border.all(width: 1, color: Colors.black26)),
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
                  'Name',
                  style: _style,
                )),
                Expanded(
                    child: Text(
                  'Mobile',
                  style: _style,
                )),
                Expanded(
                    child: Text(
                  'Total',
                  style: _style,
                )),
                Expanded(
                    child: Text(
                  'Paid',
                  style: _style,
                )),
                Expanded(
                    child: Text(
                  'Due',
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
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 50),
                        Expanded(child: Text(customers[index].name)),
                        Expanded(child: Text(customers[index].mobile)),
                        Expanded(
                            child: Text(customers[index].total.toString())),
                        Expanded(child: Text(customers[index].paid.toString())),
                        Expanded(child: Text(customers[index].due.toString())),
                        Expanded(
                          child: IconButton(
                            splashRadius: 1,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
