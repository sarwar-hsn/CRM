import 'package:flutter/material.dart';
import 'package:manage/Model/stock.dart';
import 'package:manage/Screens/Stock/stockdetail.dart';
import 'package:manage/provider/stockdata.dart';
import 'package:provider/provider.dart';

class MyStockScreen extends StatelessWidget {
  static const routeName = '/MyStockScreen';
  @override
  Widget build(BuildContext context) {
    StockData stockData = Provider.of<StockData>(context);
    List<Stock> stocks = stockData.stocks;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stocks'),
      ),
      body: (stocks.isEmpty)
          ? Center(
              child: Text('nothing found in your stock'),
            )
          : Center(child: displayStock(context, stocks)),
    );
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
                  Icons.details,
                  size: 0,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              trailing: Icon(Icons.details),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
