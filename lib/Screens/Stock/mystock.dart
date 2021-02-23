import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manage/Model/stock.dart';
import 'package:manage/Screens/Stock/stockdetail.dart';
import 'package:manage/provider/stockdata.dart';
import 'package:provider/provider.dart';

import '../../provider/stockdata.dart';

class MyStockScreen extends StatefulWidget {
  static const routeName = '/MyStockScreen';

  @override
  _MyStockScreenState createState() => _MyStockScreenState();
}

class _MyStockScreenState extends State<MyStockScreen> {
  bool isLoading = false;
  String filterValue;
  List<String> filterItems = [
    'Active Stocks',
    'All stocks',
    'Sort By Date (Oldest)',
    'Sort By Date (Newest)'
  ];
  List<Stock> stocks;

  @override
  Widget build(BuildContext context) {
    StockData stockData = Provider.of<StockData>(context);
    if (filterValue == null || filterValue == filterItems[0]) {
      stocks = stockData.activeStocks();
    } else if (filterValue == filterItems[1]) {
      stocks = stockData.stocks;
    } else if (filterValue == filterItems[2]) {
      stocks.sort((a, b) => a.date.compareTo(b.date));
    } else {
      //sort by date descending
      stocks.sort((a, b) => b.date.compareTo(a.date));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('My Stocks'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  filterValue = value;
                });
              },
              initialValue: filterItems[0],
              itemBuilder: (context) {
                return filterItems.map((value) {
                  return PopupMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList();
              },
            )
          ],
        ),
        body: (stocks.isEmpty)
            ? Center(
                child: Text('Nothing to display'),
              )
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blueGrey, Colors.white70])),
                child: Center(child: displayStock(context, stocks))));
  }
}

Container displayStock(BuildContext context, List<Stock> stocks) {
  final _style = TextStyle(fontWeight: FontWeight.bold);
  return Container(
    // decoration: BoxDecoration(
    //     gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent])),
    padding: EdgeInsets.all(20),
    width: MediaQuery.of(context).size.width * .8,
    child: ListView.builder(
      itemCount: stocks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            height: 50,
            alignment: Alignment.center,
            child: Container(
              child: ListTile(
                trailing: Icon(
                  Icons.arrow_right,
                  size: 0,
                ),
                title: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(width: 1, color: Colors.black12),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        'Date',
                        style: _style,
                      )),
                      Expanded(
                          child: Text(
                        'Comany Name',
                        style: _style,
                      )),
                      Expanded(
                          child: Text(
                        'Product Name',
                        style: _style,
                      )),
                      Expanded(
                          child: Text(
                        'Total Cost',
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        index -= 1;
        return Container(
          height: 50,
          alignment: Alignment.center,
          child: Container(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                    StockDetailScreen.routeName,
                    arguments: stocks[index].id);
              },
              trailing: Icon(
                Icons.arrow_right,
                size: 0,
                color: Colors.black,
              ),
              title: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(stocks[index].date)),
                    Expanded(child: Text(stocks[index].companyName)),
                    Expanded(child: Text(stocks[index].productName)),
                    Expanded(
                        child:
                            Text(stocks[index].totalCost.toStringAsFixed(2))),
                    Expanded(
                        child: Text(stocks[index].paid.toStringAsFixed(2))),
                    Expanded(child: Text(stocks[index].due.toStringAsFixed(2))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
