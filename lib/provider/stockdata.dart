import 'package:flutter/cupertino.dart';
import 'package:manage/Model/stock.dart';

class StockData with ChangeNotifier {
  List<Stock> _stocks = [
    new Stock(
        date: DateTime.now(),
        totalUnit: 100,
        totalCost: 1000,
        unitPrice: 10,
        due: 500,
        paid: 500,
        productName: 'cement',
        companyName: 'BDgrps',
        id: DateTime.now().toIso8601String()),
  ];
  List<String> _companies = ['BDgrps'];

  List<String> get companies {
    return [..._companies];
  }

  void addCompany(String companyName) {
    _companies.add(companyName);
    notifyListeners();
  }

  List<Stock> get stocks {
    return [..._stocks];
  }

  void addStock(Stock newStock) {
    _stocks.add(newStock);
  }
}
