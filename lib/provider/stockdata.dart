import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:manage/Model/stock.dart';
import 'package:http/http.dart' as http;

class StockData with ChangeNotifier {
  List<Stock> _stocks = [];
  List<String> _companies = [];

  List<String> get companies {
    return [..._companies];
  }

  Future<List<Stock>> fetchAndSetStock() async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/stocks.json';
      var response = await http.get(url);
      if (response.statusCode != 200) throw response.statusCode;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Stock> loadedStocks = [];
      if (extractedData != null)
        extractedData.forEach((stockId, stockData) {
          Stock temp = Stock.fromJson(stockData);
          temp.id = stockId;
          loadedStocks.add(temp);
        });
      _stocks = loadedStocks;
      notifyListeners();
      return loadedStocks;
    } catch (e) {
      throw e;
    }
  }

  Future<List<String>> fetchAndSetCompanies() async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/companies.json';
      var response = await http.get(url);
      if (response.statusCode != 200) throw response.statusCode;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<String> loadedCompanies = [];
      if (extractedData != null)
        extractedData.forEach((id, data) {
          loadedCompanies.add(data['companyName']);
        });
      _companies = loadedCompanies;
      notifyListeners();
      return loadedCompanies;
    } catch (e) {
      throw e;
    }
  }

  Future<void> addCompany(String companyName) async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/companies.json';
      var response = await http.post(url,
          body: json.encode({
            'companyName': companyName,
          }));
      if (response.statusCode == 200) {
        _companies.add(companyName);
      }
    } catch (e) {
      throw e;
    }

    notifyListeners();
  }

  List<Stock> get stocks {
    return [..._stocks];
  }

  List<Stock> activeStocks() {
    List<Stock> temp = [];
    for (int i = 0; i < _stocks.length; i++) {
      if (_stocks[i].isActive) {
        temp.add(_stocks[i]);
      }
    }
    temp.sort((a, b) => b.date.compareTo(a.date));
    return temp;
  }

  Future<void> addStock(Stock newStock) async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/stocks.json';
      var response = await http.post(url,
          body: json.encode({
            'companyName': newStock.companyName,
            'productName': newStock.productName,
            'totalUnit': double.parse(newStock.totalUnit.toStringAsFixed(2)),
            'unitPrice': double.parse(newStock.unitPrice.toStringAsFixed(2)),
            'totalCost': double.parse(newStock.totalCost.toStringAsFixed(2)),
            'paid': double.parse(newStock.paid.toStringAsFixed(2)),
            'due': double.parse(newStock.due.toStringAsFixed(2)),
            'extraFee': double.parse(newStock.extraFee.toStringAsFixed(2)),
            'date': newStock.date,
            'paymentHistory': newStock.paymentHistory,
            'isActive': newStock.isActive,
          }));
      if (response.statusCode == 200) {
        newStock.id = json.decode(response.body)['name'];
        print(newStock.id);
        _stocks.add(newStock);
      }
    } catch (e) {
      throw e;
    }

    notifyListeners();
  }

  Future<void> toggleActivate(Stock stock) async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/stocks/${stock.id}.json';
      // ignore: unused_local_variable
      var response =
          http.patch(url, body: json.encode({'isActive': stock.isActive}));
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePayment(Stock stock) async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/stocks/${stock.id}.json';
      var response = await http.patch(url,
          body: json.encode({
            'totalCost': double.parse(stock.totalCost.toStringAsFixed(2)),
            'paid': double.parse(stock.paid.toStringAsFixed(2)),
            'due': double.parse(stock.due.toStringAsFixed(2)),
            'paymentHistory': stock.paymentHistory,
          }));
      if (response.statusCode != 200) throw response.statusCode;
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Stock getStockById(String id) {
    for (int i = 0; i < _stocks.length; i++) {
      if (_stocks[i].id == id) {
        return _stocks[i];
      }
    }
    return null;
  }

  int getIndexbyId(String id) {
    for (int i = 0; i < _stocks.length; i++) {
      if (_stocks[i].id == id) return i;
    }
    return -1;
  }

  void callListerner() {
    notifyListeners();
  }
}
