import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';
import 'package:manage/Widgets/CustomerProductDetail.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  static const routeName = '/CustomerDetailScreen';

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final customerId = ModalRoute.of(context).settings.arguments as String;
    Customer customer =
        Provider.of<Customers>(context).getCustomerById(customerId);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Customer Detail Screen'),
          actions: [
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height:
                      mediaQuery.height * .5 - AppBar().preferredSize.height,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                child: Text('Add Payment'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: Text('Edit Customer'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                  child: Text('Add Product'), onPressed: () {}),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('Name : ' + customer.name),
                                Text('Mobile : ' + customer.mobile),
                                Text('Address : ' + customer.address)
                              ],
                            ),
                            Column(
                              children: [
                                Text('Total : ' + customer.total.toString()),
                                Text('Paid : ' + customer.paid.toString()),
                                Text('Due : ' + customer.due.toString())
                              ],
                            )
                          ],
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

AlertDialog getProductsDetail(
    CustomerProduct productObj, BuildContext context) {
  return AlertDialog(
    actions: [
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('okay'))
    ],
    content: Row(
      children: [
        Text(productObj.productName),
        Text(productObj.unitPurchased.toString()),
        Text(productObj.unitPrice.toString() + ' / ' + productObj.unitName),
        Text(productObj.total.toString())
      ],
    ),
  );
}
