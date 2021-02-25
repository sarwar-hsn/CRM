import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../Model/Product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<String> _categories = [];

  Future<List<String>> fetchAndSetCategories() async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/categories.json';
      var response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<String> loadedCategories = [];
      if (extractedData != null)
        extractedData.forEach((id, data) {
          loadedCategories.add(data['category']);
        });
      _categories = loadedCategories;
      notifyListeners();
      return loadedCategories;
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/products.json';
      var response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProduct = [];
      if (extractedData != null)
        extractedData.forEach((prodId, data) {
          Product temp = Product.fromJson(data);
          temp.id = prodId;
          loadedProduct.add(temp);
        });
      _products = loadedProduct;
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    for (int i = 0; i < categories.length; i++) {
      if (_categories[i] == name) {
        return;
      }
    }
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/categories.json';
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

  Future<void> deleteProduct({String id}) async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/products/$id.json';
      int index = getIndexById(id);
      if (index != -1) {
        var response = await http.delete(url);

        if (response.statusCode == 200) _products.removeAt(index);
      }
    } catch (e) {
      throw e;
    }

    notifyListeners();
  }

  Future<void> addProduct(Product obj) async {
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/products.json';
      var response = await http.post(url,
          body: json.encode({
            'name': obj.name,
            'unitPrice': double.parse(obj.unitPrice.toStringAsFixed(2)),
            'unitName': obj.unitName,
            'availableAmount':
                double.parse(obj.availableAmount.toStringAsFixed(2)),
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
    try {
      final url =
          'https://shohel-traders-default-rtdb.firebaseio.com/products/${product.id}.json';
      var response = await http.patch(url,
          body: json.encode({
            'name': product.name,
            'unitPrice': double.parse(product.unitPrice.toStringAsFixed(2)),
            'unitName': product.unitName,
            'availableAmount':
                double.parse(product.availableAmount.toStringAsFixed(2)),
          }));
      if (response.statusCode != 200) throw response.statusCode;
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  bool checkDuplicate(String value) {
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i] == value) return true;
    }
    return false;
  }

  void callListener() {
    notifyListeners();
  }

  List<String> get categories {
    return [..._categories];
  }

  Product getProductById(String id) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == id) return _products[i];
    }
    return null;
  }

  int getIndexById(String id) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == id) return i;
    }
    return -1;
  }

  List<Product> getProductsbyCategory(String category) {
    return _products
        .where((element) =>
            (element.category == category && element.availableAmount != 0))
        .toList();
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
