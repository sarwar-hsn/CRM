import 'package:flutter/material.dart';
import 'package:manage/provider/Customer.dart';
import '../provider/dummyData.dart';

enum CustomColor {
  red,
  blue,
  green,
  purple,
}

class CustomerListView extends StatelessWidget {
  final List<Customer> customers = customerByName();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blueGrey,
              border:
                  Border(bottom: BorderSide(width: 2, color: Colors.black))),
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
                        bottom: BorderSide(width: 2, color: Colors.black))),
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
                    Expanded(child: Text(customers[index].due.toString()))
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
