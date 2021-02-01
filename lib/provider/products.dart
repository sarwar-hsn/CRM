import 'package:flutter/cupertino.dart';
import '../Model/Product.dart';
import 'package:provider/provider.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: DateTime.now().toString(),
      name: 'rod',
      unitName: 'kg',
      unitPrice: 200,
    ),
    Product(
      id: DateTime.now().toString(),
      name: 'cement',
      unitName: 'kg',
      unitPrice: 50,
    ),
    Product(
      id: DateTime.now().toString(),
      name: 'balu',
      unitName: 'kg',
      unitPrice: 50,
    ),
    Product(
      id: DateTime.now().toString(),
      name: 'goru',
      unitName: 'kg',
      unitPrice: 50,
    ),
    Product(
      id: DateTime.now().toString(),
      name: 'murgi',
      unitName: 'kg',
      unitPrice: 50,
    ),
    Product(
      id: DateTime.now().toString(),
      name: 'hash',
      unitName: 'kg',
      unitPrice: 50,
    ),
    Product(
      id: DateTime.now().toString(),
      name: 'vhera',
      unitName: 'kg',
      unitPrice: 50,
    ),
  ];

  void addProduct(Product obj) {
    _products.add(obj);
    notifyListeners();
  }

  List<Product> get products {
    return [..._products];
  }
}
