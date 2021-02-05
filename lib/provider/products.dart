import 'package:flutter/cupertino.dart';
import '../Model/Product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
        id: DateTime.now().toString(),
        name: 'rod',
        unitName: 'kg',
        unitPrice: 200,
        category: 'rod'),
    Product(
        id: DateTime.now().toString(),
        name: 'cement',
        unitName: 'kg',
        unitPrice: 50,
        category: 'cement'),
    Product(
        id: DateTime.now().toString(),
        name: 'balu',
        unitName: 'kg',
        unitPrice: 50,
        category: 'cement'),
    Product(
        id: DateTime.now().toString(),
        name: 'goru',
        unitName: 'kg',
        unitPrice: 50,
        category: 'animal'),
    Product(
        id: DateTime.now().toString(),
        name: 'murgi',
        unitName: 'kg',
        unitPrice: 50,
        category: 'animal'),
    Product(
        id: DateTime.now().toString(),
        name: 'hash',
        unitName: 'kg',
        unitPrice: 50,
        category: 'animal'),
    Product(
        id: DateTime.now().toString(),
        name: 'vhera',
        unitName: 'kg',
        unitPrice: 50,
        category: 'animal'),
  ];

  List<String> _categories = ['rod', 'balu', 'cement', 'animal'];

  void addCategory(String name) {
    for (int i = 0; i < categories.length; i++) {
      if (_categories[i] == name) {
        return;
      }
    }
    _categories.add(name);
    notifyListeners();
  }

  List<String> get categories {
    return [..._categories];
  }

  void addProduct(Product obj) {
    _products.add(obj);
    notifyListeners();
  }

  List<Product> getProductsbyCategory(String category) {
    return _products.where((element) => element.category == category).toList();
  }

  List<String> getProductsList() {
    return _products.map((item) {
      return item.name;
    }).toList();
  }

  Product getProductByName(String name) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].name == name) return _products[i];
    }
    return null;
  }

  List<Product> get products {
    return [..._products];
  }
}
