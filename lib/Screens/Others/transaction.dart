import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/Screens/Customer/customerDetailScreen.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/Screens/Stock/stockdetail.dart';
import 'package:manage/provider/Customers.dart';
import 'package:provider/provider.dart';

import '../../Model/stock.dart';
import '../../provider/stockdata.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static const routeName = '/TransactionHistoryScreen';

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime selectDate;

  Future<void> _pickDateforCustomerProduct() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (date != null)
      setState(() {
        selectDate = date;
      });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Customers>(context, listen: false).fetCustomers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      drawer: MainDrawer(),
      body: (selectDate != null)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            selectDate = null;
                          });
                        }),
                    InsideContainer(
                      date: selectDate,
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              itemCount: 7,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisExtent: 500),
              itemBuilder: (context, index) {
                return SingleBoxDesign(
                  date: DateTime.now().subtract(Duration(days: index)),
                );
              }),
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

bool checkDuplicateCustomerById(String id, List<Customer> list) {
  if (list.isEmpty) return false;
  for (int i = 0; i < list.length; i++) {
    if (list[i].id == id) return true;
  }
  return false;
}

Map<String, Object> listofCustomerandTotalByDate(
    DateTime date, List<Customer> customer) {
  List<Customer> temp = [];
  List<String> id = [];
  double total = 0;
  double deposite = 0;
  double due = 0;
  for (int i = 0; i < customer.length; i++) {
    for (int j = 0; j < customer[i].products.length; j++) {
      if (customer[i].products[j].date ==
          DateFormat('dd-MM-yyyy').format(date).toString()) {
        id.add(customer[i].id);
        for (int k = 0; k < customer[i].products[j].products.length; k++) {
          total += customer[i].products[j].products[k].total;
        }
        temp.add(customer[i]);
      }
    }
    for (int j = 0; j < customer[i].paymentDate.length; j++) {
      if (DateFormat('dd-MM-yyyy').format(date).toString() ==
          customer[i].paymentDate[j]['date']) {
        if (checkDuplicateCustomerById(customer[i].id, temp) == false) {
          temp.add(customer[i]);
          id.add(customer[i].id);
        }
      }
    }
  }

  for (int i = 0; i < temp.length; i++) {
    for (int j = 0; j < temp[i].paymentDate.length; j++) {
      if (temp[i].paymentDate[j]['date'] ==
          DateFormat('dd-MM-yyyy').format(date).toString()) {
        deposite += temp[i].paymentDate[j]['paid'];
      }
    }
  }
  due = total - deposite;
  return {
    'customers': temp,
    'total': total.toStringAsFixed(2),
    'deposite': deposite.toStringAsFixed(2),
    'due': due.toStringAsFixed(2),
    'id': id
  };
}

Map<String, Object> getStockByDate(String date, List<Stock> stocks) {
  List<Stock> tempStock = [];
  double total = 0;
  if (stocks.isEmpty == false) {
    for (int i = 0; i < stocks.length; i++) {
      for (int j = 0; j < stocks[i].paymentHistory.length; j++) {
        if (date == stocks[i].paymentHistory[j]['date']) {
          tempStock.add(stocks[i]);
          total += stocks[i].paymentHistory[j]['payment'];
        }
      }
    }
  }
  return {'stocks': tempStock, 'totalExpense': total};
}

class SingleBoxDesign extends StatelessWidget {
  final DateTime date;
  final _style = TextStyle(fontWeight: FontWeight.bold);
  SingleBoxDesign({this.date});
  @override
  Widget build(BuildContext context) {
    Customers customers = Provider.of<Customers>(context);
    StockData stockData = Provider.of<StockData>(context);
    List<Customer> customer = customers.customers;
    List<Stock> stocks = stockData.stocks;
    Map<String, Object> data = listofCustomerandTotalByDate(date, customer);
    Map<String, Object> stockInfo =
        getStockByDate(DateFormat('dd-MM-yyyy').format(date), stocks);
    List<Customer> tempCustomer = data['customers'] as List<Customer>;
    List<Stock> tempStock = stockInfo['stocks'];
    List<String> id = data['id'] as List<String>;
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.deepPurpleAccent.withOpacity(.09),
            Colors.orange.withOpacity(.09)
          ]),
          border: Border.all(width: 1, color: Colors.black12)),
      child: (tempCustomer.length == 0 && tempStock.length == 0)
          ? Text('No transaction on this day')
          : ListView.builder(
              itemCount: tempCustomer.length + 1 + tempStock.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    children: [
                      Text(
                        'Date : ' +
                            DateFormat('dd-MM-yyyy').format(date).toString() +
                            '   ',
                        style: _style,
                      ),
                      Text(
                        ' Cash In : ' + data['deposite'].toString() + '   ',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' Cash Out : ' +
                            stockInfo['totalExpense'].toString() +
                            '   ',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      Text('Total Sell : ' + data['total'].toString() + '   '),
                    ],
                  );
                }

                index -= 1;
                if (index < tempCustomer.length)
                  return ListTile(
                    onTap: () {
                      // print('index value = ' + index.toString() + ' id = ' + id[i]);
                      Navigator.of(context).pushNamed(
                          CustomerDetailScreen.routeName,
                          arguments: id[index]);
                    },
                    leading: Icon(Icons.person),
                    title: Row(
                      children: [
                        Text(
                          tempCustomer[index].name + ' : ',
                          style: _style,
                        ),
                        Text(' total : ' +
                            customers
                                .getCustomerPaymentInfoByDate(
                                    tempCustomer[index].id, date)['total']
                                .toString() +
                            '  paid : ' +
                            customers
                                .getCustomerPaymentInfoByDate(
                                    tempCustomer[index].id, date)['paid']
                                .toString()),
                      ],
                    ),
                  );

                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(StockDetailScreen.routeName,
                        arguments: tempStock[index - tempCustomer.length].id);
                  },
                  leading: Icon(Icons.account_box),
                  title: Row(
                    children: [
                      Text(
                        'Date : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(tempStock[index - tempCustomer.length].date),
                      Text(' Company Name : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(tempStock[index - tempCustomer.length].companyName),
                      Text(' Item Name : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(tempStock[index - tempCustomer.length].productName),
                      Text(' Paid : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(tempStock[index - tempCustomer.length]
                          .paid
                          .toString())
                    ],
                  ),
                );

                // : Text('fuck');
              },
            ),
    );
  }
}

class InsideContainer extends StatelessWidget {
  final DateTime date;
  final _style = TextStyle(fontWeight: FontWeight.bold);
  InsideContainer({this.date});
  @override
  Widget build(BuildContext context) {
    Customers customers = Provider.of<Customers>(context);
    StockData stockData = Provider.of<StockData>(context);
    List<Customer> customer = customers.customers;
    List<Stock> stocks = stockData.stocks;
    Map<String, Object> data = listofCustomerandTotalByDate(date, customer);
    Map<String, Object> stockInfo =
        getStockByDate(DateFormat('dd-MM-yyyy').format(date), stocks);
    List<Customer> tempCustomer = data['customers'] as List<Customer>;
    List<Stock> tempStock = stockInfo['stocks'];
    List<String> id = data['id'] as List<String>;
    return (tempCustomer.length == 0 && tempStock.length == 0)
        ? Text('No Customer on this day')
        : Center(
            child: Container(
              height: 500,
              width: 800,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: tempCustomer.length + 1 + tempStock.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Date : ' +
                                DateFormat('dd-MM-yyyy')
                                    .format(date)
                                    .toString() +
                                '   ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' Cash In : ' + data['deposite'].toString() + '   ',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' Cash Out : ' +
                                stockInfo['totalExpense'].toString() +
                                '   ',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          Text('Total Sell : ' + data['total'].toString()),
                        ],
                      );
                    }

                    index -= 1;
                    if (index < tempCustomer.length)
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              CustomerDetailScreen.routeName,
                              arguments: id[index]);
                        },
                        leading: Icon(Icons.person),
                        title: Row(
                          children: [
                            Text(
                              tempCustomer[index].name + ' : ',
                              style: _style,
                            ),
                            Text(' total : ' +
                                customers
                                    .getCustomerPaymentInfoByDate(
                                        tempCustomer[index].id, date)['total']
                                    .toString()),
                            Text('  paid : ' +
                                customers
                                    .getCustomerPaymentInfoByDate(
                                        tempCustomer[index].id, date)['paid']
                                    .toString()),
                          ],
                        ),
                      );

                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            StockDetailScreen.routeName,
                            arguments:
                                tempStock[index - tempCustomer.length].id);
                      },
                      leading: Icon(Icons.account_box),
                      title: Row(
                        children: [
                          Text(
                            'Date : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(tempStock[index - tempCustomer.length].date),
                          Text(' Company Name : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(tempStock[index - tempCustomer.length]
                              .companyName),
                          Text(' Paid : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(tempStock[index - tempCustomer.length]
                              .paid
                              .toString())
                        ],
                      ),
                    );

                    // : Text('fuck');
                  },
                ),
              ),
            ),
          );
  }
}
