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
  List<String> filterItems = ['Active Stocks', 'All stocks'];
  List<Stock> stocks;

  @override
  Widget build(BuildContext context) {
    StockData stockData = Provider.of<StockData>(context);
    if (filterValue == null || filterValue == filterItems[0]) {
      stocks = stockData.activeStocks();
    } else {
      stocks = stockData.stocks;
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
            : Center(child: displayStock(context, stocks)));
  }
}

Container displayStock(BuildContext context, List<Stock> stocks) {
  return Container(
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text('Date')),
                    Expanded(child: Text('companyName')),
                    Expanded(child: Text('productName')),
                    Expanded(child: Text('totalCost')),
                    Expanded(child: Text('paid')),
                    Expanded(child: Text('due')),
                  ],
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
              trailing: Icon(Icons.arrow_right),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(stocks[index].date)),
                  Expanded(child: Text(stocks[index].companyName)),
                  Expanded(child: Text(stocks[index].productName)),
                  Expanded(child: Text(stocks[index].totalCost.toString())),
                  Expanded(child: Text(stocks[index].paid.toString())),
                  Expanded(child: Text(stocks[index].due.toString())),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
