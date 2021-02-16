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

  Stock deleteStock(String id) {
    Stock temp = getStockById(id);
    int index = getIndexbyId(id);
    if (index != -1) {
      _stocks.removeAt(index);
    }
    notifyListeners();
    return temp;
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
