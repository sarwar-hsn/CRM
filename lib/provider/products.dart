import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../Model/Product.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
        id: Uuid().v1(),
        name: 'Fire Rod',
        unitName: 'kg',
        unitPrice: 200,
        category: 'rod',
        availableAmount: 300),
    Product(
        id: Uuid().v4(),
        name: 'Crown cement',
        unitName: 'bag',
        unitPrice: 50,
        category: 'cement',
        availableAmount: 500),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
        name: 'shosta balu',
        unitName: 'kg',
        unitPrice: 50,
        category: 'balu',
        availableAmount: 5000),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.facebook.com'),
        name: 'goru',
        unitName: 'piece',
        unitPrice: 10000,
        category: 'animal',
        availableAmount: 10),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.twitter.com'),
        name: 'murgi',
        unitName: 'kg',
        unitPrice: 350,
        category: 'animal',
        availableAmount: 500),
    Product(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.instagram.com'),
        name: 'hash',
        unitName: 'kg',
        unitPrice: 50,
        category: 'animal',
        availableAmount: 200),
    Product(
        id: Uuid().v1(),
        name: 'vhera',
        unitName: 'piece',
        unitPrice: 2000,
        category: 'animal',
        availableAmount: 30),
  ];

  List<String> _categories = [];

  Future<void> addCategory(String name) async {
    final url =
        'https://shohel-traders-default-rtdb.firebaseio.com/categories.json';
    for (int i = 0; i < categories.length; i++) {
      if (_categories[i] == name) {
        return;
      }
    }
    try {
      var response =
          await http.post(url, body: json.encode({'category': name}));
      if (response.statusCode == 200) {
        _categories.add(name);
      } else
        throw response.statusCode;
    } catch (e) {
      throw e;
    }

    notifyListeners();
  }

  void updateProduct(Product temp, int index) {
    _products.removeAt(index);
    _products.add(new Product(
        availableAmount: temp.availableAmount,
        category: temp.category,
        id: temp.id,
        name: temp.name,
        unitName: temp.unitName,
        unitPrice: temp.unitPrice));
    notifyListeners();
  }

  void deleteProduct({String id}) {
    int index = getIndexById(id);
    if (index != -1) {
      _products.removeAt(index);
    }
    notifyListeners();
  }

  Product getProductById(String id) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == id) return _products[i];
    }
    return null;
  }

  List<String> get categories {
    return [..._categories];
  }

  bool checkDuplicate(String value) {
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i] == value) return true;
    }
    return false;
  }

  Future<void> addProduct(Product obj) async {
    final url =
        'https://shohel-traders-default-rtdb.firebaseio.com/products.json';
    try {
      var response = await http.post(url,
          body: json.encode({
            'name': obj.name,
            'unitPrice': obj.unitPrice,
            'unitName': obj.unitName,
            'availableAmount': obj.availableAmount,
            'category': obj.category,
          }));
      if (response.statusCode == 200) {
        obj.id = json.decode(response.body)['name'];
        _products.add(obj);
      } else
        throw response.statusCode;
    } catch (e) {
      throw e;
    }

    notifyListeners();
  }

  Future<void> editProduct(Product product) async {
    final url =
        'https://shohel-traders-default-rtdb.firebaseio.com/products/${product.id}.json';
    try {
      var response = await http.patch(url,
          body: json.encode({
            'name': product.name,
            'unitPrice': product.unitPrice,
            'unitName': product.unitName,
            'availableAmount': product.availableAmount,
          }));
      if (response.statusCode != 200) throw response.statusCode;
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  int getIndexById(String id) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == id) return i;
    }
    return -1;
  }

  void callListener() {
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
