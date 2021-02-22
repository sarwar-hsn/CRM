import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';

import 'package:provider/provider.dart';

import '../../provider/Customers.dart';
import '../../provider/products.dart';
import '../../provider/stockdata.dart';
import '../../provider/stockdata.dart';
import 'mainDrawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime date = DateTime.now();

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
        this.date = date;
      });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Customers>(context, listen: false).fetCustomers();
      Provider.of<Products>(context, listen: false).fetchAndSetProducts();
      Provider.of<Products>(context, listen: false).fetchAndSetCategories();
      Provider.of<StockData>(context, listen: false).fetchAndSetStock();
      Provider.of<StockData>(context, listen: false).fetchAndSetCompanies();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Customer> customer = Provider.of<Customers>(context).customers;
    List<Map<String, Object>> data =
        sellPerDay(customer, DateFormat('dd-MM-yyyy').format(date));
    return Scaffold(
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
        appBar: AppBar(
          title: Text('M/S. Shohel Traders (Beta Version)'),
          centerTitle: true,
        ),
        body: (data.isEmpty)
            ? Center(
                child: Text('Nothing to Display for ' +
                    DateFormat('dd-MM-yyyy').format(date)))
            : Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(color: Colors.black12, width: 1)),
                  height: MediaQuery.of(context).size.height * .8,
                  width: 600,
                  child: ListView.builder(
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sell Board',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                              Text(
                                'Date : ' +
                                    DateFormat('dd-MM-yyyy').format(date),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              )
                            ],
                          );
                        }
                        index -= 1;
                        return Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Product Name : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(data[index]['productName']),
                                  Text(
                                    ' Amount Sold : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(data[index]['quantity'].toString() +
                                      ' ' +
                                      data[index]['unitName']),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ));
  }
}

class SellTrack extends StatelessWidget {
  final String date;
  final List<Map<String, Object>> sellPerDay;
  SellTrack({this.date, this.sellPerDay});
  @override
  Widget build(BuildContext context) {
    if (sellPerDay.isEmpty)
      return Center(
        child: Text('no data'),
      );
    return Center(
      child: Text('has Data'),
    );
  }
}

int _checkProductNameIndex(String name, List<Map<String, Object>> list) {
  if (list.isEmpty) return -1;
  for (int i = 0; i < list.length; i++) {
    if (list[i]['productName'] == name) {
      return i;
    }
  }
  return -1;
}

List<Map<String, Object>> sellPerDay(List<Customer> customer, String date) {
  List<Map<String, Object>> list = [];
  for (int i = 0; i < customer.length; i++) {
    for (int j = 0; j < customer[i].products.length; j++) {
      if (customer[i].products[j].date == date) {
        for (int k = 0; k < customer[i].products[j].products.length; k++) {
          double totalUnit = customer[i].products[j].products[k].unitPurchased;
          String productName = customer[i].products[j].products[k].productName;
          String unitName = customer[i].products[j].products[k].unitName;
          int index = _checkProductNameIndex(productName, list);
          if (index != -1) {
            double tempTotalUnit =
                totalUnit + double.parse(list[index]['quantity']);
            list[index]['quantity'] = tempTotalUnit.toString();
          } else {
            list.add({
              'productName': productName,
              'quantity': totalUnit.toString(),
              'unitName': unitName
            });
          }
        }
      }
    }
  }
  return list;
}
