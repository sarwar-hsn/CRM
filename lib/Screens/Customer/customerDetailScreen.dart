import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';
import 'package:manage/Screens/EditScreens.dart/editCustomer.dart';
import 'package:manage/Screens/EditScreens.dart/updatepayment.dart';
import 'package:manage/Widgets/CustomerProductDetail.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

import 'addcustomerproductscreen.dart';

class CustomerDetailScreen extends StatefulWidget {
  static const routeName = '/CustomerDetailScreen';

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  double amount = 0;

  @override
  Widget build(BuildContext context) {
    final customerId = ModalRoute.of(context).settings.arguments;
    // print(customerId);
    Customer customer =
        Provider.of<Customers>(context).getCustomerById(customerId);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: (customer == null)
              ? Text('Customer Detail Screen')
              : Text(customer.name),
          actions: [
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
        body: SafeArea(
          child: (customer == null)
              ? Text('something went wrong')
              : Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.deepPurple.withOpacity(.08),
                    Colors.deepPurpleAccent.withOpacity(.08)
                  ])),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black12, width: 1),
                              color: Colors.white),
                          height: mediaQuery.height * .5 -
                              AppBar().preferredSize.height,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ElevatedButton(
                                            child: Text('Update Payment'),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  UpdatePayment.routeName,
                                                  arguments: customer);
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                            child: Text('Edit Customer'),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  EditCustomerScreen.routeName,
                                                  arguments: customer);
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              child: Text('Add Product'),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    AddCustomerProductScreen
                                                        .routeName,
                                                    arguments: customer);
                                              }),
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 300,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Name : ' + customer.name),
                                              Text('Mobile : ' +
                                                  customer.mobile),
                                              Text('Address : ' +
                                                  customer.address),
                                              (customer.schedulePay == null)
                                                  ? Text(
                                                      'Schedule Payment Day : ----')
                                                  : Text(
                                                      'Scheduled payment Day : ' +
                                                          customer.schedulePay)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 300,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total : ' +
                                                  customer.total.toString()),
                                              Text('Paid : ' +
                                                  customer.paid.toString()),
                                              Text('Due : ' +
                                                  customer.due.toString()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 200,
                                width: 400,
                                child: (customer.paymentDate.length == 0)
                                    ? Text(
                                        'No payment yet',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            customer.paymentDate.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return Text('Payment History');
                                          }
                                          index -= 1;
                                          return Text('Date : ' +
                                              customer.paymentDate[index]
                                                  ['date'] +
                                              '     Amount paid : ' +
                                              customer.paymentDate[index]
                                                      ['paid']
                                                  .toString());
                                        },
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                      CustomerProductDetail(
                        customer: customer,
                        mediaQuery: mediaQuery,
                      )
                    ],
                  ),
                ),
        ));
  }
}
