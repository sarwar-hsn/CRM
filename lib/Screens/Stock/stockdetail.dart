import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/stock.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';

import 'package:manage/Screens/Stock/updatestockpayment.dart';
import 'package:manage/provider/stockdata.dart';
import 'package:provider/provider.dart';

import '../../provider/stockdata.dart';

class StockDetailScreen extends StatefulWidget {
  static const routeName = '/StockDetailScreen';

  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  void _aciveHandler(StockData stockdata, Stock stock) {
    setState(() {
      stock.isActive = !stock.isActive;
      stockdata.toggleActivate(stock);
    });
  }

  @override
  Widget build(BuildContext context) {
    String stockId = ModalRoute.of(context).settings.arguments;
    StockData stockData = Provider.of<StockData>(context);
    final mediaQuery = MediaQuery.of(context).size;
    Stock stock = stockData.getStockById(stockId);
    return Scaffold(
        appBar: AppBar(
          title: Text('Stock Detail'),
        ),
        drawer: MainDrawer(),
        body: SafeArea(
          child: (stock == null)
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
                                                  UpdateStockPaymentScreen
                                                      .routeName,
                                                  arguments: stock);
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                            child: (stock.isActive)
                                                ? Text(
                                                    'Account is Active',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.greenAccent),
                                                  )
                                                : Text(
                                                    'Account is Deactive',
                                                    style: TextStyle(
                                                        color: Colors.brown,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            onPressed: () {
                                              _aciveHandler(stockData, stock);
                                            },
                                          ),
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
                                              Text('Company Name : ' +
                                                  stock.companyName),
                                              Text('Product Name : ' +
                                                  stock.productName),
                                              Text('Date  : ' + stock.date)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 300,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Total Unit : ' +
                                                  stock.totalUnit.toString()),
                                              Text('Unit Price : ' +
                                                  stock.unitPrice.toString()),
                                              Text(
                                                  'Transportation / Extras : ' +
                                                      stock.extraFee
                                                          .toString()),
                                              Text('Total : ' +
                                                  stock.totalCost.toString()),
                                              Text('Paid : ' +
                                                  stock.paid.toString()),
                                              Text('Due : ' +
                                                  stock.due.toString()),
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
                                child: (stock.paymentHistory.length == 0)
                                    ? Text(
                                        'No payment yet',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            stock.paymentHistory.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return Text('Payment History');
                                          }
                                          index -= 1;
                                          return Text('Date : ' +
                                              stock.paymentHistory[index]
                                                  ['date'] +
                                              '     Amount paid : ' +
                                              stock.paymentHistory[index]
                                                      ['payment']
                                                  .toString());
                                        },
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
